import 'package:flutter/material.dart';
import '../widgets/searchable_filter.dart';
import '../services/ai_analysis_service.dart';
import '../widgets/ai_insights_card.dart';

class FarmerFilterScreen extends StatefulWidget {
  const FarmerFilterScreen({super.key});

  @override
  State<FarmerFilterScreen> createState() => _FarmerFilterScreenState();
}

class _FarmerFilterScreenState extends State<FarmerFilterScreen> {
  String? selectedCircle;
  String? selectedStatus;
  List<AIInsight> aiInsights = [];
  bool isLoadingAnalysis = true;

  // Sample data simulating the Excel file structure
  late List<FarmerData> allFarmers;
  
  // Filter lists
  List<String> circles = [];
  List<String> statuses = [];

  @override
  void initState() {
    super.initState();
    _loadDataAndAnalyze();
  }

  Future<void> _loadDataAndAnalyze() async {
    // Simmons loading data
    await Future.delayed(const Duration(seconds: 1));
    
    // Create mock data based on the Excel file we analyzed:
    // 187 Accepted, 3 Rejected, 1 Submitted, 9 Vendor Info
    // Circles: Sambhajinagar (~54%), Jalgaon (~35%), Jalna (~11%)
    
    List<FarmerData> mockData = [];
    
    // Add Sambhajinagar farmers (Accepted)
    for(int i=0; i<100; i++) {
      mockData.add(FarmerData("F$i", "CH. SAMBHAJINAGAR CIRCLE", "JSR OUTCOME ACCEPTED"));
    }
    // Add Sambhajinagar (Rejected)
    for(int i=0; i<4; i++) {
      mockData.add(FarmerData("F$i", "CH. SAMBHAJINAGAR CIRCLE", "JSR OUTCOME REJECTED")); // Anomaly
    }
    
    // Add Jalgaon farmers
    for(int i=0; i<60; i++) {
      mockData.add(FarmerData("F$i", "JALGAON CIRCLE", "JSR OUTCOME ACCEPTED"));
    }
    for(int i=0; i<5; i++) {
      mockData.add(FarmerData("F$i", "JALGAON CIRCLE", "VENDOR INFORMATION RECEIVED"));
    }
    
    // Add Jalna
    for(int i=0; i<20; i++) {
      mockData.add(FarmerData("F$i", "JALNA CIRCLE", "JSR OUTCOME ACCEPTED"));
    }
    mockData.add(FarmerData("F999", "JALGAON CIRCLE", "JSR SUBMITTED")); // Rare one

    setState(() {
      allFarmers = mockData;
      circles = mockData.map((e) => e.circle).toSet().toList();
      statuses = mockData.map((e) => e.status).toSet().toList();
      
      // RUN AI ANALYSIS
      aiInsights = AIAnalysisService.analyzeList(mockData);
      isLoadingAnalysis = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Filter'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("AI Analysis re-run completed")));
               setState(() {
                 aiInsights = AIAnalysisService.analyzeList(allFarmers);
               });
            },
            tooltip: "Re-run AI Analysis",
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade50,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Farmers',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${allFarmers.length} Records Loaded',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Filter Section
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24), // Added padding at bottom
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AI INSIGHTS SECTION
                        if (isLoadingAnalysis)
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else
                          AIInsightsOverview(insights: aiInsights),
                          
                        Divider(thickness: 1, color: Colors.grey.shade100),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Circle Filter
                              SearchableFilter<String>(
                                label: 'Circle',
                                items: circles,
                                selectedItem: selectedCircle,
                                itemLabel: (item) => item,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCircle = value;
                                  });
                                },
                                hintText: 'Search for a circle...',
                                prefixIcon: Icons.location_on,
                                allowClear: true,
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Status Filter
                              SearchableFilter<String>(
                                label: 'Application Status',
                                items: statuses,
                                selectedItem: selectedStatus,
                                itemLabel: (item) => item,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value;
                                  });
                                },
                                hintText: 'Search for a status...',
                                prefixIcon: Icons.assignment,
                                allowClear: true,
                              ),
                              
                              const SizedBox(height: 32),
                              
                              // Filter Summary Card
                              if (selectedCircle != null || selectedStatus != null)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.filter_list, 
                                            color: Colors.blue.shade700, 
                                            size: 20
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Active Filters',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                const SizedBox(height: 12),
                                if (selectedCircle != null)
                                  _buildFilterChip(
                                    'Circle',
                                    selectedCircle!,
                                    () => setState(() => selectedCircle = null),
                                  ),
                                if (selectedStatus != null)
                                  _buildFilterChip(
                                    'Status',
                                    selectedStatus!,
                                    () => setState(() => selectedStatus = null),
                                  ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedCircle = null;
                                    selectedStatus = null;
                                  });
                                },
                                icon: const Icon(Icons.clear_all),
                                label: const Text('Clear All'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _applyFilters,
                                icon: const Icon(Icons.search),
                                label: const Text('Apply Filters'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    '$label: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onRemove,
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // Here you would apply the filters to your data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Filters Applied: ${selectedCircle ?? "All Circles"}, ${selectedStatus ?? "All Statuses"}',
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
