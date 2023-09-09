import 'package:build/build.dart';
import 'package:menthe_generator/menthe_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Builds generators for `build_runner` to run
Builder mentheBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [MentheGenerator(options.config)],
    'menthe',
  );
}
