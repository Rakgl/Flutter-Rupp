import '../../api_http_client.dart';

class HealthBotChartResponse extends BaseResponse {
  HealthBotChartResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] is List) {
      healthBotChart = json
          .getListOrDefault('data')
          .map((e) => HealthBotChart.fromJson(e))
          .toList();
    } else if (json['data'] is Map) {
      healthBotChart = [HealthBotChart.fromJson(json['data'])];
    } else {
      healthBotChart = [];
    }
  }

  late List<HealthBotChart> healthBotChart;
}

class HealthBotChart {
  final String aiResponse;
  final String userMessage;
  final DateTime timestamp;

  HealthBotChart({
    required this.aiResponse,
    required this.userMessage,
    required this.timestamp,
  });

  factory HealthBotChart.fromJson(Map<String, dynamic> json) {
    return HealthBotChart(
      aiResponse: json['ai_response'] ?? '',
      userMessage: json['user_message'] ?? '',
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ai_response": aiResponse,
      "user_message": userMessage,
      "timestamp": timestamp.toIso8601String(),
    };
  }
}
