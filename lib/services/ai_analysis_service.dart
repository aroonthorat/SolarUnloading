import 'package:flutter/material.dart';

enum InsightType {
  success,    // Green: Good trends (High acceptance)
  warning,    // Orange: Anomalies (Strange patterns)
  alert,      // Red: Critical issues (High rejection, Data errors)
  info        // Blue: General stats
}

class AIInsight {
  final String title;
  final String description;
  final InsightType type;
  final IconData icon;
  final double? score; // 0.0 to 1.0 confidence/severity

  AIInsight({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    this.score,
  });
}

class FarmerData {
  final String id;
  final String circle;
  final String status;
  final double? amount;
  
  FarmerData(this.id, this.circle, this.status, {this.amount});
}

class AIAnalysisService {
  
  /// Analyzes a list of farmers and returns smart insights
  static List(AIInsight) analyzeList(List<FarmerData> farmers) {
    if (farmers.isEmpty) return [];
    
    List<AIInsight> insights = [];
    
    // 1. Calculate Stats
    int total = farmers.length;
    int accepted = farmers.where((f) => f.status.contains("ACCEPTED")).length;
    int rejected = farmers.where((f) => f.status.contains("REJECTED")).length;
    
    double acceptanceRate = (accepted / total) * 100;
    
    // 2. Acceptance Analysis
    if (acceptanceRate > 90) {
      insights.add(AIInsight(
        title: "High Approval Rate",
        description: "${acceptanceRate.toStringAsFixed(1)}% of applications are approved. Process is healthy.",
        type: InsightType.success,
        icon: Icons.check_circle_outline,
      ));
    } else if (acceptanceRate < 50) {
      insights.add(AIInsight(
        title: "Low Approval Warning",
        description: "Only ${acceptanceRate.toStringAsFixed(1)}% approved. Check document verification process.",
        type: InsightType.alert,
        icon: Icons.warning_amber_rounded,
        score: 0.8,
      ));
    }
    
    // 3. Cluster Analysis (Circle Distribution)
    Map<String, int> circleCounts = {};
    for (var f in farmers) {
      circleCounts[f.circle] = (circleCounts[f.circle] ?? 0) + 1;
    }
    
    var dominantCircle = circleCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    double dominance = (dominantCircle.value / total);
    
    if (dominance > 0.6) {
      insights.add(AIInsight(
        title: "Uneven Distribution",
        description: "${(dominance * 100).toInt()}% of load is from ${dominantCircle.key}.",
        type: InsightType.info,
        icon: Icons.pie_chart_outline,
      ));
    }
    
    // 4. Anomaly Detection (Rare Statuses)
    Map<String, int> statusCounts = {};
    for (var f in farmers) {
      statusCounts[f.status] = (statusCounts[f.status] ?? 0) + 1;
    }
    
    statusCounts.forEach((status, count) {
      if (count < 3 && total > 20) { // Rare status in a large list
        insights.add(AIInsight(
          title: "Rare Status Detected",
          description: "'$status' appears only $count times. Verify this is valid.",
          type: InsightType.warning,
          icon: Icons.search,
        ));
      }
    });

    return insights;
  }
}
