import 'package:flutter/material.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
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
      appBar: CustomAppBar(
        title: 'Product List',
        onBackPressed: () => Navigator.pop(context),
        showNotifications: false,
        showProfile: false,
      ),
      body: CustomScrollWidget(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: CustomColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacer(height: 20),
                
                // Header with Add Product button
                CustomRow(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product List',
                      style: AppTextStyles.getHeading(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    CustomButton(
                      text: 'Add Product',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateProductScreen(),
                          ),
                        );
                      },
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: ResponsiveConfig.responsiveFont(context, 14),
                    ),
                  ],
                ),
                
                CustomSpacer(height: 20),
                
                // Show entries and search controls
                CustomCard(
                  padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
                  child: CustomColumn(
                    children: [
                      // Show entries dropdown
                      CustomRow(
                        children: [
                          Text(
                            'Show ',
                            style: AppTextStyles.getBody(context).copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveConfig.responsivePadding(context, 12),
                              vertical: ResponsiveConfig.responsivePadding(context, 8),
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedEntries,
                              underline: const SizedBox(),
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
                          ),
                          Text(
                            ' entries',
                            style: AppTextStyles.getBody(context).copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      
                      CustomSpacer(height: 16),
                      
                      // Search field
                      CustomTextField(
                        controller: _searchController,
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                
                CustomSpacer(height: 20),
                
                // Table
                _buildTable(paginatedData),
                
                CustomSpacer(height: 20),
                
                // Pagination
                _buildPagination(paginatedData),
                
                CustomSpacer(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> paginatedData) {
    return CustomCard(
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: ResponsiveConfig.responsivePadding(context, 16),
          headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
          columns: [
            DataColumn(
              label: Text(
                '#',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Name',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Category',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'SKU',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Price',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Qty',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Action',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
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
                            style: AppTextStyles.getBody(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(Text(data['category'] ?? '')),
                      DataCell(Text(data['sku'] ?? '')),
                      DataCell(Text(
                        data['price'] ?? '',
                        style: AppTextStyles.getBody(context).copyWith(
                          fontWeight: FontWeight.w500,
                        ),
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
                        CustomRow(
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
    );
  }

  Widget _buildPagination(List<Map<String, dynamic>> paginatedData) {
    if (paginatedData.isEmpty) {
      return CustomCard(
        padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
        child: Center(
          child: Text(
            'No data available in table',
            style: AppTextStyles.getBody(context).copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return CustomCard(
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      child: CustomRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Showing ${((_currentPage - 1) * int.parse(_selectedEntries)) + 1} to ${((_currentPage - 1) * int.parse(_selectedEntries)) + paginatedData.length} of ${_productData.length} entries',
              style: AppTextStyles.getBody(context),
            ),
          ),
          CustomRow(
            children: [
              CustomButton(
                text: 'Previous',
                onPressed: _currentPage > 1 ? () {
                  setState(() {
                    _currentPage--;
                  });
                } : () {},
                backgroundColor: _currentPage > 1 ? Colors.black : Colors.grey[300]!,
                textColor: _currentPage > 1 ? Colors.white : Colors.black,
              ),
              CustomSpacer(width: ResponsiveConfig.spacingSm(context)),
              CustomButton(
                text: 'Next',
                onPressed: _currentPage < _totalPages ? () {
                  setState(() {
                    _currentPage++;
                  });
                } : () {},
                backgroundColor: _currentPage < _totalPages ? Colors.black : Colors.grey[300]!,
                textColor: _currentPage < _totalPages ? Colors.white : Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
