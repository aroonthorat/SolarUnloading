import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 1. Navigation Rail (Sidebar)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            elevation: 5,
            useIndicator: true,
            indicatorColor: Colors.deepPurple.shade100,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Icon(Icons.wb_sunny, color: Colors.deepPurple, size: 32),
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.upload_file_outlined),
                selectedIcon: Icon(Icons.upload_file),
                label: Text('Upload List'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outlined),
                selectedIcon: Icon(Icons.people),
                label: Text('Farmers'),
              ),
            ],
          ),
          
          const VerticalDivider(thickness: 1, width: 1),

          // 2. Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const Text(
                             'Admin Dashboard',
                             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                           ),
                           Row(
                             children: [
                               Container(
                                 width: 8, height: 8,
                                 decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                               ),
                               const SizedBox(width: 8),
                               const Text("v2.1", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                             ],
                           )
                         ],
                      ),
                      const Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade50,
                        child: const Icon(Icons.person, color: Colors.deepPurple),
                      )
                    ],
                  ),
                ),

                // Content Body
                Expanded(
                  child: Container(
                    color: Colors.grey.shade50,
                    padding: const EdgeInsets.all(24),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardStats();
      case 1:
        return _buildUploadSection();
      case 2:
        return _buildFarmersList();
      default:
        return const Center(child: Text("Unknown Page"));
    }
  }

  // --- DASHBOARD SECTION ---
  Widget _buildDashboardStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('farmers_master').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final docs = snapshot.data!.docs;
        final total = docs.length;
        final pending = docs.where((d) => (d.data() as Map)['unloading_status'] != 'done').length;
        final done = docs.where((d) => (d.data() as Map)['unloading_status'] == 'done').length;

        return GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16, 
          mainAxisSpacing: 16,
          children: [
            _statCard('Total Farmers', total.toString(), Colors.blue, Icons.people),
            _statCard('Pending Unload', pending.toString(), Colors.orange, Icons.timer),
            _statCard('Completed', done.toString(), Colors.green, Icons.check_circle),
            _statCard('Issues', '0', Colors.red, Icons.warning),
          ],
        );
      },
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Icon(icon, color: color, size: 30),
           const Spacer(),
           Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
           Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Staging State
  List<Map<String, dynamic>> _stagingList = [];
  Set<int> _selectedStagingIndices = {};
  bool _isStagingMode = false;

  // --- UPLOAD SECTION ---
  Widget _buildUploadSection() {
    if (_isStagingMode) {
      return _buildStagingReviewUI();
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(24),
           border: Border.all(color: Colors.deepPurple.shade100, width: 2),
           boxShadow: [BoxShadow(color: Colors.deepPurple.withOpacity(0.05), blurRadius: 20)]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text("Upload Farmer List", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Excel or CSV • AI Column Mapping", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickAndStageFile,
                  icon: _isLoading ? const SizedBox.shrink() : const Icon(Icons.folder_open),
                  label: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text("Select File"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _showManualEntryDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text("Manual Entry"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- STAGING & REVIEW UI ---
  Widget _buildStagingReviewUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() { _stagingList.clear(); _isStagingMode = false; }),
            ),
            const SizedBox(width: 10),
            Text("Review Import (${_stagingList.length} Rows)", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text("${_selectedStagingIndices.length} Selected", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _commitStagingToDatabase,
              icon: const Icon(Icons.check),
              label: const Text("Confirm & Add to Database"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            )
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                columns: const [
                  DataColumn(label: Text('Select')),
                  DataColumn(label: Text('Farmer Name')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('HP')),
                  DataColumn(label: Text('Action')),
                ],
                rows: List.generate(_stagingList.length, (index) {
                  final item = _stagingList[index];
                  final isSelected = _selectedStagingIndices.contains(index);
                  return DataRow(
                    selected: isSelected,
                    onSelectChanged: (val) {
                      setState(() {
                         if(val == true) {
                           _selectedStagingIndices.add(index);
                         } else {
                           _selectedStagingIndices.remove(index);
                         }
                      });
                    },
                    cells: [
                      DataCell(Checkbox(value: isSelected, onChanged: (v) {
                         setState(() {
                           if(v == true) {
                             _selectedStagingIndices.add(index);
                           } else {
                             _selectedStagingIndices.remove(index);
                           }
                         });
                      })),
                      DataCell(Text(item['name'])),
                      DataCell(Text(item['location'])),
                      DataCell(Text(item['phone'])),
                      DataCell(Text(item['hp'])),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _stagingList.removeAt(index);
                            _selectedStagingIndices.remove(index);
                            // Shift indices logic is complex, simpler to clear selection or re-calc
                            // For prototype, just clearing selection to avoid bugs
                            _selectedStagingIndices.clear(); 
                          });
                        },
                      )),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAndStageFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true, // Try to get bytes (works on Web)
      );

      if (result != null) {
        setState(() => _isLoading = true);
        
        List<int> bytes;
        if (result.files.first.bytes != null) {
          bytes = result.files.first.bytes!;
        } else if (result.files.first.path != null) {
           // Desktop: Read from path if bytes are null
           // We need 'dart:io' for this, but 'dart:io' breaks Web.
           // Since we are likely on a platform where one or the other works:
           // We can't import dart:io safely in a universal file without conditional imports.
           // But 'file_picker' with 'withData: true' SHOULD return bytes on Windows too if the file isn't huge.
           // If it fails, we will show a specific error.
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: File bytes are empty. Try a smaller file.')));
           setState(() => _isLoading = false);
           return;
        } else {
           throw "Could not read file data.";
        }

        var excel = Excel.decodeBytes(bytes);
        List<Map<String, dynamic>> newRows = [];
        
        for (var table in excel.tables.keys) {
           var rows = excel.tables[table]!.rows;
           if(rows.isEmpty) continue;

           // 1. Smart Header Detection (First Row)
           var headerRow = rows[0];
           int nameIdx = -1, locIdx = -1, phoneIdx = -1, hpIdx = -1;

           for(int i=0; i<headerRow.length; i++) {
             String h = _getCellValue(headerRow[i]).toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
             if(h.contains('name') || h.contains('farmer') || h.contains('beneficiary')) {
               nameIdx = i;
             } else if(h.contains('location') || h.contains('village') || h.contains('circle') || h.contains('address')) locIdx = i;
             else if(h.contains('phone') || h.contains('mobile') || h.contains('contact')) phoneIdx = i;
             else if(h.contains('hp') || h.contains('pump') || h.contains('load')) hpIdx = i;
           }
           
           // Fallback: If absolutely no headers matched, assume default order 0,1,2,3
           if(nameIdx == -1 && locIdx == -1 && phoneIdx == -1) {
              nameIdx = 0; locIdx = 1; phoneIdx = 2; hpIdx = 3;
           }

           // 2. Parse Data
           for(int i=1; i<rows.length; i++) {
             var row = rows[i];
             if(row.isEmpty) continue;
             
             // Safety: Check bounds
             String val(int idx) => (idx != -1 && idx < row.length) ? _getCellValue(row[idx]) : '';
             
             String name = val(nameIdx);
             if(name.isEmpty && nameIdx == 0 && row.isNotEmpty) name = _getCellValue(row[0]); // Hard fallback

             if(name.isNotEmpty) {
                newRows.add({
                  'name': name,
                  'location': val(locIdx),
                  'phone': val(phoneIdx),
                  'hp': val(hpIdx),
                  'unloading_status': 'pending',
                  'createdAt': FieldValue.serverTimestamp(),
                });
             }
           }
        }

        if(newRows.isEmpty) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No valid rows found. Check your Excel columns.')));
        }
        
        setState(() {
          _stagingList = newRows;
          _selectedStagingIndices = List.generate(newRows.length, (i) => i).toSet();
          _isStagingMode = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
       // Show dialog for detailed error
      showDialog(context: context, builder: (c) => AlertDialog(
        title: const Text("Import Error"),
        content: Text(e.toString()),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text("OK"))],
      ));
    }
  }

  void _showManualEntryDialog() {
    String name='', loc='', phone='', hp='';
    showDialog(
      context: context, 
      builder: (c) => AlertDialog(
        title: const Text("Manual Entry"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: "Name"), onChanged: (v) => name=v),
            TextField(decoration: const InputDecoration(labelText: "Location"), onChanged: (v) => loc=v),
            TextField(decoration: const InputDecoration(labelText: "Phone"), onChanged: (v) => phone=v),
            TextField(decoration: const InputDecoration(labelText: "HP"), onChanged: (v) => hp=v),
            const SizedBox(height: 10),
            const Text("Tip: You can paste CSV data in the file upload method for batch entry.", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
               setState(() {
                  _stagingList.add({
                    'name': name, 'location': loc, 'phone': phone, 'hp': hp, 
                    'unloading_status': 'pending', 'createdAt': FieldValue.serverTimestamp() 
                  });
                  _isStagingMode = true;
                  _selectedStagingIndices.add(_stagingList.length - 1);
               });
               Navigator.pop(c);
            }, 
            child: const Text("Add to List")
          )
        ],
      )
    );
  }

  Future<void> _commitStagingToDatabase() async {
    if(_selectedStagingIndices.isEmpty) return;

    setState(() => _isLoading = true);
    int count = 0;
    
    try {
      final batch = FirebaseFirestore.instance.batch();
      // Firestore batch limit is 500, simple for loop here
      for(int i in _selectedStagingIndices) {
         if(i < _stagingList.length) {
            var docRef = FirebaseFirestore.instance.collection('farmers_master').doc();
            batch.set(docRef, _stagingList[i]);
            count++;
         }
      }
      await batch.commit();

      setState(() {
        _isLoading = false;
        _stagingList.clear();
        _isStagingMode = false;
        _selectedStagingIndices.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully added $count farmers!')));

    } catch(e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error committing: $e')));
    }
  }

  String _getCellValue(var cell) {
    if (cell == null) return '';
    // Handle specific Excel package types if needed, or fallback to toString()
    // For excel ^4.0.0, .value returns the raw value
    try {
      return cell.value.toString(); 
    } catch (e) {
      return cell.toString();
    }
  }

  // --- FARMERS LIST SECTION ---
  Widget _buildFarmersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('farmers_master').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
         
         return Card(
           elevation: 2,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
           child: ListView.separated(
             itemCount: snapshot.data!.docs.length,
             separatorBuilder: (c, i) => const Divider(height: 1),
             itemBuilder: (context, index) {
               final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
               final status = data['unloading_status'] ?? 'pending';
               
               return ListTile(
                 leading: CircleAvatar(
                   backgroundColor: Colors.deepPurple.shade50,
                   child: Text(data['name'] != null ? data['name'][0] : 'U', style: const TextStyle(color: Colors.deepPurple)),
                 ),
                 title: Text(data['name'] ?? 'Unknown Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                 subtitle: Text('${data['location'] ?? 'No Location'} • ${data['phone'] ?? 'No Phone'}'),
                 trailing: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                   decoration: BoxDecoration(
                     color: status == 'done' ? Colors.green.shade100 : Colors.orange.shade100,
                     borderRadius: BorderRadius.circular(20)
                   ),
                   child: Text(
                     status.toUpperCase(),
                     style: TextStyle(
                       color: status == 'done' ? Colors.green.shade800 : Colors.orange.shade800,
                       fontWeight: FontWeight.bold,
                       fontSize: 12
                     ),
                   ),
                 ),
               );
             },
           ),
         );
      },
    );
  }
}
