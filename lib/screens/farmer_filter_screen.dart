import 'package:flutter/material.dart';
import '../widgets/searchable_filter.dart';

class FarmerFilterScreen extends StatefulWidget {
  const FarmerFilterScreen({Key? key}) : super(key: key);

  @override
  State<FarmerFilterScreen> createState() => _FarmerFilterScreenState();
}

class _FarmerFilterScreenState extends State<FarmerFilterScreen> {
  String? selectedCircle;
  String? selectedStatus;
  
  // Sample data from the Excel file
  final List<String> circles = [
    'CH. SAMBHAJINAGAR CIRCLE',
    'JALGAON CIRCLE',
    'JALNA CIRCLE',
  ];
  
  final List<String> statuses = [
    'JSR OUTCOME ACCEPTED',
    'JSR OUTCOME REJECTED',
    'JSR SUBMITTED',
    'VENDOR INFORMATION RECEIVED',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Filter'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
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
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Farmers',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Use search filters to find specific records',
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
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
                        
                        SizedBox(height: 24),
                        
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
                        
                        SizedBox(height: 32),
                        
                        // Filter Summary Card
                        if (selectedCircle != null || selectedStatus != null)
                          Container(
                            padding: EdgeInsets.all(16),
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
                                    SizedBox(width: 8),
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
                                SizedBox(height: 12),
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
                        
                        SizedBox(height: 24),
                        
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
                                icon: Icon(Icons.clear_all),
                                label: Text('Clear All'),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _applyFilters,
                                icon: Icon(Icons.search),
                                label: Text('Apply Filters'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  padding: EdgeInsets.symmetric(vertical: 16),
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
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  SizedBox(width: 8),
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
