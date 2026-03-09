import 'package:flutter_methgo_app/app/app.dart';
import 'package:flutter_methgo_app/bootstrap.dart';
import 'package:flutter_methgo_app/features/shared/export_shared.dart';

Future<void> main() async {
  await bootstrap(
    () => App(
      environment: EnvironmentModel.production(),
    ),
  );
}
