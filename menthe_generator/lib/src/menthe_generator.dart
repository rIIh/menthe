import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:menthe_annotation/menthe_annotation.dart';
import 'package:menthe_generator/src/models.dart';
import 'package:menthe_generator/src/parser_generator.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

/// Matches with the [Menthe] annotation from riverpod_annotation.
const mentheType = TypeChecker.fromRuntime(Menthe);

@immutable
class MentheGenerator extends ParserGenerator<Menthe> {
  final BuildYamlOptions options;

  MentheGenerator(Map<String, Object?> mapConfig)
      : options = BuildYamlOptions.fromMap(mapConfig);

  @override
  FutureOr<String> generateForUnit(List<CompilationUnit> compilationUnits,
      [LibraryReader? library]) {
    final buffer = StringBuffer(); //
    for (final unit in compilationUnits) {
      unit.visitChildren(_Visitor(buffer));
    }

    // Only emit the header if we actually generated something
    if (buffer.isNotEmpty) {
      buffer.write(
        '''
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
''',
      );
    }

    return buffer.toString();
  }

  bool Function(Annotation element) isA<T>() => (e) => e.element is T;
}

const colorType = Reference("Color", "dart:ui");

class _Visitor extends RecursiveAstVisitor {
  final StringBuffer buffer;

  _Visitor(this.buffer);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final themeAnnotation =
        mentheType.annotationsOfExact(node.declaredElement!).singleOrNull;

    if (themeAnnotation != null) {
      var name = node.name.lexeme.replaceAll(RegExp(r'^[_$]'), '');
      if (name == node.name.lexeme) name = '\$$name';

      var extensionGetterName =
          themeAnnotation.getField('extensionGetter')?.toStringValue() ??
              name.camelCase;

      final fields = node.members.whereType<FieldDeclaration>().map((e) {
        return Field(
          (b) => b
            ..docs.add(
              '/// See [${node.name.lexeme}.${e.fields.variables.first.name.lexeme}]',
            )
            ..modifier = FieldModifier.final$
            ..name = e.fields.variables.first.name.lexeme
            ..type = colorType,
        );
      });

      final (variantValues, variantFactories) =
          generateFactories(node, fields, name);

      final Class code = Class(
        (b) => b
          ..name = name
          ..extend = refer(
            "ThemeExtension<$name>",
            "package:flutter/material.dart",
          )
          ..fields.addAll(variantValues)
          ..fields.addAll(fields)
          ..constructors.add(Constructor(
            (b) => b.optionalParameters.addAll([
              for (final field in fields)
                Parameter(
                  (b) => b
                    ..named = true
                    ..required = true
                    ..toThis = true
                    ..name = field.name,
                )
            ]),
          ))
          ..constructors.addAll(variantFactories)
          ..methods.addAll([
            Method(
              (b) => b
                ..returns = refer(name)
                ..name = 'copyWith'
                ..optionalParameters.addAll([
                  for (final field in fields)
                    Parameter(
                      (b) => b
                        ..named = true
                        ..type = nullable(typeOf(field))
                        ..name = field.name,
                    )
                ])
                ..body = Code('''
return $name(
  ${fields.map((e) => '${e.name}: ${e.name} ?? this.${e.name}').join(',\n')}${fields.length > 0 ? ',' : ''}
);
'''),
            ),

            //  @override
            //  PTColorThemeTemplate lerp(covariant PTColorThemeTemplate? other, double t) {
            //    return PTColorThemeTemplate(
            //      primary: Color.lerp(primary, other?.primary, t)!,
            //      background: Color.lerp(background, other?.background, t)!,
            //    );
            //  }
            Method(
              (b) => b
                ..returns = refer(name)
                ..name = 'lerp'
                ..requiredParameters.addAll([
                  Parameter(
                    (b) => b
                      ..name = 'other'
                      ..covariant = true
                      ..type = refer('$name?'),
                  ),
                  Parameter(
                    (b) => b
                      ..name = 't'
                      ..type = refer('double'),
                  ),
                ])
                ..body = Code('''
return $name(
  ${fields.map((e) => '${e.name}: Color.lerp(${e.name}, other?.${e.name}, t)!').join(',\n')}${fields.length > 0 ? ',' : ''}
);
'''),
            )
          ]),
      );

      final emitter = DartEmitter();
      buffer.write(DartFormatter().format('${code.accept(emitter)}'));

      final extension = Extension(
        (b) => b
          ..name = '${name}X'
          ..on = refer("ThemeData")
          ..methods.add(Method(
            (b) => b
              ..returns = refer(name)
              ..type = MethodType.getter
              ..name = extensionGetterName
              ..lambda = true
              ..body = Code('extension<$name>()!'),
          )),
      );

      buffer.write(DartFormatter().format('${extension.accept(emitter)}'));
    }

    return super.visitClassDeclaration(node);
  }

  (List<Field>, List<Constructor>) generateFactories(
    ClassDeclaration theme,
    Iterable<Field> fields,
    String name,
  ) {
    final Map<String, Map<String, String>> initializers = {};

    for (final field in theme.members.whereType<FieldDeclaration>()) {
      final map = initializers[field.fields.variables.first.name.lexeme] = {};
      field.visitChildren(_VariantVisitor(map));
    }

    // asd
    final Set<String> variants = initializers.values.fold<Set<String>>(
      initializers.values.firstOrNull?.keys.toSet() ?? {},
      (acc, element) {
        print([acc, element.keys]);
        return acc..addAll(element.keys.toSet());
      },
    );

    String getInitializer(Field field, String variant) {
      var initializer = initializers[field.name]![variant];
      if (initializer?.isNotEmpty != true) {
        initializer = '${theme.name}.${field.name}.$variant';
      }

      return initializer ?? '';
    }

    return (
      [
        for (final variant in variants)
          Field(
            (b) => b
              ..static = true
              ..type = refer(name)
              ..name = '_k${variant.pascalCase}'
              ..assignment = Code(
                '''
                $name(
                  ${[
                  for (final field in fields)
                    '${field.name}: ${getInitializer(field, variant)}',
                ].join(',\n')}${fields.isNotEmpty ? ',' : ''}
                )
                ''', //asd
              ),
          ),
      ],
      [
        for (final variant in variants)
          Constructor(
            (b) {
              b
                ..name = variant
                ..factory = true
                ..lambda = true
                ..body = Code('_k${variant.pascalCase}');
            },
          ),
      ]
    );
  }
}

class _VariantVisitor extends RecursiveAstVisitor {
  final Map<String, String> initializers;

  _VariantVisitor(this.initializers);

  @override
  visitConstructorName(ConstructorName node) {
    // TODO(@melvspace): try to extract color initializer.
    final properties = node.staticElement?.enclosingElement.accessors;
    final colorFields = properties?.where((element) =>
            TypeChecker.fromUrl('dart:ui#Color')
                .isAssignableFromType(element.returnType)) ??
        [];

    for (final color in colorFields) {
      initializers[color.name] = '';
    }

    return super.visitConstructorName(node);
  }
}

TypeReference? typeOf(Spec spec) {
  return switch (spec) {
    Field field => field.type?.type,
    _ => null,
  } as TypeReference?;
}

TypeReference? nullable(TypeReference? reference) {
  return reference?.rebuild((b) => b..symbol = '${b.symbol}?');
}
