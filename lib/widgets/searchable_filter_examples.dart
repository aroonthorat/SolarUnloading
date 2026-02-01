// Quick Reference: How to Use Searchable Filter
// ============================================

// 1. IMPORT THE WIDGET
import '../widgets/searchable_filter.dart';

// 2. DEFINE YOUR DATA & STATE
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // State variable to store selection
  String? selectedValue;
  
  // Your data list
  final List<String> myItems = ['Item 1', 'Item 2', 'Item 3'];

  // 3. USE THE WIDGET
  @override
  Widget build(BuildContext context) {
    return SearchableFilter<String>(
      label: 'My Filter Label',              // Required
      items: myItems,                         // Required
      selectedItem: selectedValue,            // Optional: current selection
      itemLabel: (item) => item,             // Required: how to display each item
      onChanged: (value) {                   // Required: handle selection
        setState(() {
          selectedValue = value;
        });
      },
      hintText: 'Search...',                 // Optional
      prefixIcon: Icons.search,              // Optional
      allowClear: true,                      // Optional (default: true)
    );
  }
}

// EXAMPLE 1: Simple String Filter
// ================================
SearchableFilter<String>(
  label: 'Circle',
  items: ['Circle A', 'Circle B', 'Circle C'],
  selectedItem: selectedCircle,
  itemLabel: (item) => item,
  onChanged: (value) => setState(() => selectedCircle = value),
  prefixIcon: Icons.location_on,
)

// EXAMPLE 2: Custom Object Filter
// ================================
class Person {
  final String name;
  final int age;
  Person(this.name, this.age);
}

SearchableFilter<Person>(
  label: 'Select Person',
  items: peopleList,
  selectedItem: selectedPerson,
  itemLabel: (person) => '${person.name} (${person.age})',
  onChanged: (person) => setState(() => selectedPerson = person),
  hintText: 'Search by name...',
  prefixIcon: Icons.person,
)

// EXAMPLE 3: Number Filter
// =========================
SearchableFilter<int>(
  label: 'Year',
  items: [2020, 2021, 2022, 2023, 2024],
  selectedItem: selectedYear,
  itemLabel: (year) => year.toString(),
  onChanged: (year) => setState(() => selectedYear = year),
  prefixIcon: Icons.calendar_today,
)

// EXAMPLE 4: Map/Dictionary Filter
// =================================
final Map<String, String> statusMap = {
  'pending': 'Pending Approval',
  'approved': 'Approved',
  'rejected': 'Rejected',
};

SearchableFilter<String>(
  label: 'Status',
  items: statusMap.keys.toList(),
  selectedItem: selectedStatus,
  itemLabel: (key) => statusMap[key]!,
  onChanged: (key) => setState(() => selectedStatus = key),
  prefixIcon: Icons.assignment,
)

// TIPS:
// -----
// ✓ Use meaningful labels
// ✓ Provide search hints
// ✓ Choose appropriate icons
// ✓ Always call setState() in onChanged
// ✓ Handle null selections gracefully
// ✓ Keep itemLabel concise
