import 'package:flutter_super_aslan_app/app/app.dart';
import 'package:flutter_super_aslan_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
