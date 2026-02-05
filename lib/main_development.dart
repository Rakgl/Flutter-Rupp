import 'package:flutter_super_aslan_app/app/app.dart';
import 'package:flutter_super_aslan_app/bootstrap.dart';
import 'package:flutter_super_aslan_app/features/shared/export_shared.dart';

Future<void> main() async {
  await bootstrap(
    () => App(
      environment: EnvironmentModel.development(),
    ),
  );
}
