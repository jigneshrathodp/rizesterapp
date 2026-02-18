import 'package:flutter/material.dart';
import 'create_ad_screen.dart';
import 'update_ads_screen.dart';

class AdvertiseListScreen extends StatefulWidget {
  const AdvertiseListScreen({super.key});

  @override
  State<AdvertiseListScreen> createState() => _AdvertiseListScreenState();
}

class _AdvertiseListScreenState extends State<AdvertiseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedEntries = '10';
  final List<String> _entriesOptions = ['10', '25', '50', '100'];
  int _currentPage = 1;
  int _totalPages = 1;
  
  // Sample data with more advertisements
  final List<Map<String, dynamic>> _advertiseData = [
    {
      'id': 1,
      'title': 'Summer Sale 2024',
      'price': '\$500',
      'platform': 'Facebook',
      'url': 'https://example.com/summer-sale',
      'date': '2024-01-15',
    },
    {
      'id': 2,
      'title': 'New Product Launch',
      'price': '\$1000',
      'platform': 'Google',
      'url': 'https://example.com/launch',
      'date': '2024-01-20',
    },
    {
      'id': 3,
      'title': 'Weekend Special',
      'price': '\$300',
      'platform': 'Instagram',
      'url': 'https://example.com/weekend',
      'date': '2024-01-25',
    },
    {
      'id': 4,
      'title': 'Flash Sale',
      'price': '\$750',
      'platform': 'Twitter',
      'url': 'https://example.com/flash',
      'date': '2024-01-30',
    },
  ];

  List<Map<String, dynamic>> get _paginatedData {
    final entriesPerPage = int.parse(_selectedEntries);
    _totalPages = (_advertiseData.length / entriesPerPage).ceil();
    
    final startIndex = (_currentPage - 1) * entriesPerPage;

    if (startIndex >= _advertiseData.length) {
      _currentPage = 1;
      return _advertiseData.take(entriesPerPage).toList();
    }
    
    return _advertiseData.skip(startIndex).take(entriesPerPage).toList();
  }

  @override
  Widget build(BuildContext context) {
    final paginatedData = _paginatedData;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed header section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Advertise List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAdScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Advertise'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Show '),
                    DropdownButton<String>(
                      value: _selectedEntries,
                      items: _entriesOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEntries = newValue!;
                          _currentPage = 1;
                        });
                      },
                    ),
                    const Text(' entries'),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Expandable table section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Platform', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: paginatedData.isEmpty
                      ? []
                      : paginatedData.map((data) {
                          return DataRow(
                            cells: [
                              DataCell(Text((data['id'] ?? '').toString())),
                              DataCell(
                                Container(
                                  width: 150,
                                  child: Text(
                                    data['title'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(Text(
                                data['price'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              )),
                              DataCell(Text(data['platform'] ?? '')),
                              DataCell(Text(data['date'] ?? '')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdateAdsScreen(adData: data),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                ),
              ),
            ),
          ),
          if (paginatedData.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  'No data available in table',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          // Fixed bottom pagination section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('Showing ${((_currentPage - 1) * int.parse(_selectedEntries)) + 1} to ${((_currentPage - 1) * int.parse(_selectedEntries)) + paginatedData.length} of ${_advertiseData.length} entries'),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: _currentPage > 1 ? () {
                        setState(() {
                          _currentPage--;
                        });
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage > 1 ? Colors.black : Colors.grey[300],
                        foregroundColor: _currentPage > 1 ? Colors.white : Colors.black,
                      ),
                      child: const Text('Previous'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _currentPage < _totalPages ? () {
                        setState(() {
                          _currentPage++;
                        });
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage < _totalPages ? Colors.black : Colors.grey[300],
                        foregroundColor: _currentPage < _totalPages ? Colors.white : Colors.black,
                      ),
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/images/rizester.png',
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Rizester',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Notification Screen',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

