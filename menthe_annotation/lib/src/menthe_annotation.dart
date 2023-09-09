import 'package:meta/meta_meta.dart';

const menthe = Menthe();

@Target({TargetKind.classType})
class Menthe {
  final String? extensionGetter;

  const Menthe({this.extensionGetter});
}
