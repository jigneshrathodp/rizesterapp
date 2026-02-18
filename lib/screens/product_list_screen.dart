import 'package:flutter/material.dart';
import 'create_product_screen.dart';
import 'update_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedEntries = '10';
  final List<String> _entriesOptions = ['10', '25', '50', '100'];
  int _currentPage = 1;
  int _totalPages = 1;
  
  // Sample jewelry data
  final List<Map<String, dynamic>> _productData = [
    {
      'id': 1,
      'name': 'Gold Diamond Ring',
      'category': 'Rings',
      'sku': 'JWL-001',
      'price': '₹52,000',
      'quantity': '2',
      'status': 'Active',
    },
    {
      'id': 2,
      'name': 'Silver Chain Necklace',
      'category': 'Necklaces',
      'sku': 'JWL-002',
      'price': '₹25,000',
      'quantity': '1',
      'status': 'Active',
    },
    {
      'id': 3,
      'name': 'Pearl Earrings',
      'category': 'Earrings',
      'sku': 'JWL-003',
      'price': '₹35,000',
      'quantity': '3',
      'status': 'Active',
    },
    {
      'id': 4,
      'name': 'Gold Bracelet',
      'category': 'Bracelets',
      'sku': 'JWL-004',
      'price': '₹45,000',
      'quantity': '0',
      'status': 'Inactive',
    },
    {
      'id': 5,
      'name': 'Diamond Pendant',
      'category': 'Pendants',
      'sku': 'JWL-005',
      'price': '₹28,000',
      'quantity': '4',
      'status': 'Active',
    },
  ];

  List<Map<String, dynamic>> get _paginatedData {
    final entriesPerPage = int.parse(_selectedEntries);
    _totalPages = (_productData.length / entriesPerPage).ceil();
    
    final startIndex = (_currentPage - 1) * entriesPerPage;

    if (startIndex >= _productData.length) {
      _currentPage = 1;
      return _productData.take(entriesPerPage).toList();
    }
    
    return _productData.skip(startIndex).take(entriesPerPage).toList();
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
                    Text(
                      'Product List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateProductScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text(
                        'Add Product',
                        style: TextStyle(fontSize: 14),
                      ),
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
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
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
                                    data['name'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(Text(data['category'] ?? '')),
                              DataCell(Text(data['sku'] ?? '')),
                              DataCell(Text(
                                data['price'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              )),
                              DataCell(Text(data['quantity'] ?? '')),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: data['status'] == 'Active' ? Colors.green : Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    data['status'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdateProductScreen(productData: data),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Product'),
                                            content: Text('Are you sure you want to delete ${data['name']}?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _productData.removeWhere((p) => p['id'] == data['id']);
                                                  });
                                                },
                                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
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
                  child: Text('Showing ${((_currentPage - 1) * int.parse(_selectedEntries)) + 1} to ${((_currentPage - 1) * int.parse(_selectedEntries)) + paginatedData.length} of ${_productData.length} entries'),
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
