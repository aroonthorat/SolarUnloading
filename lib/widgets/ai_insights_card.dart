import 'package:flutter/material.dart';
import '../services/ai_analysis_service.dart';

class AIInsightsOverview extends StatelessWidget {
  final List<AIInsight> insights;
  final VoidCallback? onRefresh;

  const AIInsightsOverview({
    super.key,
    required this.insights,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purple.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                "AI List Analysis",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.purple.shade800,
                ),
              ),
              const Spacer(),
              if (onRefresh != null)
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18, color: Colors.grey),
                  onPressed: onRefresh,
                ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: insights.map((insight) => _buildInsightCard(insight)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(AIInsight insight) {
    Color bg;
    Color fg;
    Color border;

    switch (insight.type) {
      case InsightType.success:
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        border = Colors.green.shade200;
        break;
      case InsightType.alert:
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        border = Colors.red.shade200;
        break;
      case InsightType.warning:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade800;
        border = Colors.orange.shade200;
        break;
      case InsightType.info:
      default:
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade700;
        border = Colors.blue.shade200;
        break;
    }

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(insight.icon, color: fg, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: fg,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight.description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
