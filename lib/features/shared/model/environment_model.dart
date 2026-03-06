// enum environment
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Environment {
  development,
  uat,
  demo,
  qas,
  staging,
  production,
}

class EnvironmentModel extends Equatable {
  const EnvironmentModel({
    required this.name,
    required this.baseUrl,
    required this.apiVersion,
    required this.environment,
    this.color,
  });

  // dev
  factory EnvironmentModel.development({
    String apiVersion = 'v1',
    String? name,
    String? baseUrl,
    Color? color,
  }) {
    return EnvironmentModel(
      name: name ?? 'Dev',
      apiVersion: apiVersion,
      color: color ?? Colors.red,
      environment: Environment.development,
      baseUrl: baseUrl ?? 'http://0.0.0.0:8000/api/v1/admin',
    );
  }

  // qas
  factory EnvironmentModel.qas({
    String apiVersion = 'v1',
    String? name,
    String? baseUrl,
    Color? color,
  }) {
    return EnvironmentModel(
      name: name ?? 'Qas',
      apiVersion: apiVersion,
      color: color ?? Colors.pink,
      environment: Environment.qas,
      baseUrl:
          baseUrl ??
          'https://dev-tele-api.d.aditidemo.asia/api/$apiVersion/mobile',
    );
  }

  // uat
  factory EnvironmentModel.uat({
    String apiVersion = 'v1',
    String? name,
    String? baseUrl,
    Color? color,
  }) {
    return EnvironmentModel(
      name: name ?? 'Uat',
      apiVersion: apiVersion,
      color: color ?? Colors.pink,
      environment: Environment.uat,
      baseUrl:
          baseUrl ??
          'https://dev-tele-api.d.aditidemo.asia/api/$apiVersion/mobile',
    );
  }

  // demo
  factory EnvironmentModel.demo({
    String apiVersion = 'v1',
    String? name,
    String? baseUrl,
    Color? color,
  }) {
    return EnvironmentModel(
      name: name ?? 'Demo',
      apiVersion: apiVersion,
      color: color ?? Colors.pink,
      environment: Environment.demo,
      baseUrl:
          baseUrl ??
          'https://dev-tele-api.d.aditidemo.asia/api/$apiVersion/mobile',
    );
  }

  // staging
  factory EnvironmentModel.staging({
    String apiVersion = 'v1',
    String? name,
    String? baseUrl,
    Color? color,
  }) {
    return EnvironmentModel(
      name: name ?? 'Staging',
      apiVersion: apiVersion,
      color: color ?? Colors.orange,
      environment: Environment.staging,
      baseUrl:
          baseUrl ??
          'https://dev-tele-api.d.aditidemo.asia/api/$apiVersion/mobile',
    );
  }

  // production
  factory EnvironmentModel.production({
    String apiVersion = 'v1',
    String? name,
    String? baseUrl,
    Color? color,
  }) {
    return EnvironmentModel(
      name: name ?? 'Production',
      apiVersion: apiVersion,
      color: color ?? Colors.green,
      environment: Environment.production,
      baseUrl:
          baseUrl ??
          'https://dev-tele-api.d.aditidemo.asia/api/$apiVersion/mobile',
    );
  }

  final String name;
  final String baseUrl;
  final String apiVersion;
  final Color? color;
  final Environment environment;

  @override
  List<Object?> get props => [name, baseUrl, apiVersion, color, environment];
}
