# Searchable Filter Widget - Implementation Guide

## 📱 Overview

A modern, reusable **Searchable Filter** widget that replaces traditional dropdowns with an intuitive search interface, providing better UX especially for large datasets.

## ✨ Features

- ✅ **Real-time search** - Filter items as you type
- ✅ **Overlay dropdown** - Modern floating dropdown UI
- ✅ **Selected item highlighting** - Visual feedback for selection
- ✅ **Clear selection** - Quick clear button when item is selected
- ✅ **Empty state** - Customizable message when no results found
- ✅ **Type-safe** - Generic implementation works with any data type
- ✅ **Keyboard navigation** - Auto-focus on search input
- ✅ **Responsive design** - Adapts to available space

## 📁 Files Created

1. **`lib/widgets/searchable_filter.dart`** - Main reusable widget
2. **`lib/screens/farmer_filter_screen.dart`** - Example implementation

## 🚀 Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import '../widgets/searchable_filter.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  String? selectedCircle;
  
  final List<String> circles = [
    'CH. SAMBHAJINAGAR CIRCLE',
    'JALGAON CIRCLE',
    'JALNA CIRCLE',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SearchableFilter<String>(
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
      ),
    );
  }
}
```

### Advanced Usage - Custom Objects

```dart
class Farmer {
  final String id;
  final String name;
  final String village;
  
  Farmer({required this.id, required this.name, required this.village});
}

// In your widget:
SearchableFilter<Farmer>(
  label: 'Select Farmer',
  items: farmersList,
  selectedItem: selectedFarmer,
  itemLabel: (farmer) => '${farmer.name} - ${farmer.village}',
  onChanged: (farmer) {
    setState(() {
      selectedFarmer = farmer;
    });
  },
  hintText: 'Search by name or village...',
  prefixIcon: Icons.person,
)
```

## 🎨 Widget Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `label` | `String` | Yes | Label text displayed above the filter |
| `items` | `List<T>` | Yes | List of items to display |
| `itemLabel` | `String Function(T)` | Yes | Function to extract display text from item |
| `onChanged` | `void Function(T?)` | Yes | Callback when selection changes |
| `selectedItem` | `T?` | No | Currently selected item |
| `hintText` | `String` | No | Placeholder in search box (default: "Search...") |
| `prefixIcon` | `IconData?` | No | Icon to show before the label |
| `allowClear` | `bool` | No | Show clear button when item selected (default: true) |
| `emptyMessage` | `String?` | No | Message when no items found (default: "No items found") |

## 🎯 Benefits Over Traditional Dropdowns

### Traditional Dropdown Problems:
- ❌ Requires scrolling through long lists
- ❌ No search capability
- ❌ Poor UX for 10+ items
- ❌ Difficult to find specific items
- ❌ No visual indication of filtering

### Searchable Filter Advantages:
- ✅ **Instant search** - Find items in milliseconds
- ✅ **Better performance** - Only shows matching items
- ✅ **Improved accessibility** - Keyboard-friendly
- ✅ **Modern UI** - Floating overlay with shadows
- ✅ **Visual feedback** - Checkmarks and highlighting
- ✅ **Scalable** - Works great with 100+ items

## 📊 Example: Farmer Data Filter

The `farmer_filter_screen.dart` demonstrates filtering farmer data from your Excel file:

**Data from "New Farmer test list.xls":**
- **Circles:** CH. Sambhajinagar, Jalgaon, Jalna
- **Statuses:** JSR Outcome Accepted, JSR Outcome Rejected, etc.

## 🎨 UI Components

### 1. Filter Input Field
- Clean white background
- Border highlighting on focus
- Icon support (prefix)
- Clear button (when selected)
- Dropdown indicator

### 2. Search Overlay
- Floating panel with shadow
- Search input with icon
- Filtered list view
- Selected item highlighting
- Empty state message

### 3. Active Filters Display
- Blue info card
- Individual filter chips
- Quick remove buttons
- Visual summary

## 🔧 Customization

### Changing Colors

```dart
// In searchable_filter.dart, modify colors:

// Border color (line ~185)
border: Border.all(
  color: _isExpanded ? Colors.green : Colors.grey.shade300, // Change from blue to green
),

// Selected item background (line ~105)
color: isSelected ? Colors.green.shade50 : Colors.transparent,

// Checkmark color (line ~131)
color: Colors.green.shade700,
```

### Modifying Dropdown Height

```dart
// In _createOverlayEntry() method
Container(
  constraints: BoxConstraints(maxHeight: 400), // Change from 300 to 400
  // ...
)
```

## 🚀 Testing the Widget

### Run the Example Screen

1. Update `main.dart` to use the farmer filter screen:

```dart
import 'screens/farmer_filter_screen.dart';

// In MaterialApp
home: const FarmerFilterScreen(),
```

2. Run the app:

```bash
flutter run -d chrome  # For web
# or
flutter run  # For mobile
```

## 📱 Integration Checklist

- [ ] Copy `searchable_filter.dart` to `lib/widgets/`
- [ ] Import widget in your screen
- [ ] Define your data list
- [ ] Add state variable for selected item
- [ ] Implement SearchableFilter widget
- [ ] Handle `onChanged` callback
- [ ] Test search functionality
- [ ] Customize styling if needed

## 🐛 Troubleshooting

### Overlay not showing?
- Ensure widget is wrapped in a Material or Scaffold
- Check that context has an Overlay ancestor

### Search not working?
- Verify `itemLabel` function returns correct string
- Check that items list is not empty

### Selection not updating?
- Make sure you call `setState()` in `onChanged`
- Verify state variable is properly initialized

## 📈 Performance Tips

For lists with 1000+ items:
1. Consider lazy loading
2. Implement debouncing on search
3. Use virtual scrolling
4. Add pagination

## 🎓 Best Practices

1. **Always provide meaningful labels** - Users should understand what they're filtering
2. **Use appropriate icons** - Visual cues improve UX
3. **Keep item labels concise** - Long text may truncate
4. **Provide empty states** - Tell users when no results found
5. **Allow clearing** - Users should be able to reset easily

## 🔗 Related Components

Consider pairing with:
- Date range filters
- Multi-select filters
- Sort options
- Export buttons

## 📝 License

This component is part of the Solar Unloading project.

---

**Created:** 2026-02-01  
**Version:** 1.0.0  
**Author:** Solar Unloading Team
