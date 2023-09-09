// ignore_for_file: unused_local_variable, unnecessary_null_comparison

String? isEmpty(String? string) => string.run((it) => it.isEmpty ? it : null);
String? isNotEmpty(String? string) =>
    string.run((it) => it.isNotEmpty ? it : null);

extension LetNullableExtension<T extends Object> on T? {
  R? let<R>(R closure(T it)) {
    return this != null ? closure(this!) : null;
  }

  R? run<R>(R? closure(T it)) {
    return this != null ? closure(this!) : null;
  }
}

extension LetExtension<T extends Object> on T {
  R let<R>(R closure(T it)) {
    return closure(this);
  }

  R? run<R>(R? closure(T it)) {
    return closure(this);
  }
}

extension AlsoExtension<T extends Object?> on T {
  T also(void closure(T it)) {
    closure(this);
    return this;
  }
}

void main() {
  final a = "String";
  final b = a.let((it) => it * 2);
  final c = b == null;

  final String? nullableA = "String";
  final String? nullableB = nullableA.let((it) => it * 2);
}
