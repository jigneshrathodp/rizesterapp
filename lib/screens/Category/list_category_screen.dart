import 'package:flutter/material.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import 'update_category_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final _searchController = TextEditingController();
  String _selectedEntries = '10';
  List<CategoryItem> _categories = [
    CategoryItem(
      id: 1,
      name: 'Electronics',
      sku: 'CAT-001',
      barcode: '1234567890123',
      imageUrl: 'assets/electronics.jpg',
      productCount: 45,
    ),
    CategoryItem(
      id: 2,
      name: 'Clothing',
      sku: 'CAT-002',
      barcode: '2345678901234',
      imageUrl: 'assets/clothing.jpg',
      productCount: 32,
    ),
    CategoryItem(
      id: 3,
      name: 'Books',
      sku: 'CAT-003',
      barcode: '3456789012345',
      imageUrl: 'assets/books.jpg',
      productCount: 18,
    ),
    CategoryItem(
      id: 4,
      name: 'Home & Garden',
      sku: 'CAT-004',
      barcode: '4567890123456',
      imageUrl: 'assets/home.jpg',
      productCount: 27,
    ),
    CategoryItem(
      id: 5,
      name: 'Sports',
      sku: 'CAT-005',
      barcode: '5678901234567',
      imageUrl: 'assets/sports.jpg',
      productCount: 15,
    ),
    CategoryItem(
      id: 6,
      name: 'Toys & Games',
      sku: 'CAT-006',
      barcode: '6789012345678',
      imageUrl: 'assets/toys.jpg',
      productCount: 22,
    ),
    CategoryItem(
      id: 7,
      name: 'Beauty',
      sku: 'CAT-007',
      barcode: '7890123456789',
      imageUrl: 'assets/beauty.jpg',
      productCount: 38,
    ),
    CategoryItem(
      id: 8,
      name: 'Automotive',
      sku: 'CAT-008',
      barcode: '8901234567890',
      imageUrl: 'assets/automotive.jpg',
      productCount: 12,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: CustomDrawer(
        selectedIndex: 2, // Category List index
        onItemTapped: (index) {
          Navigator.pop(context);
          _handleDrawerNavigation(index);
        },
        headerTitle: 'Category Management',
      ),
      appBar: CustomAppBar(
        title: 'Category List',
        onBackPressed: () => Navigator.pop(context),
        showNotifications: false,
        showProfile: false,
      ),
      body: CustomScrollWidget(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: CustomColumn(
              children: [
                // Top controls
                _buildTopControls(),
                
                // Table
                _buildTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleDrawerNavigation(int index) {
    // Since screens don't exist, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation to screen ${index + 1} selected'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildTopControls() {
    return Container(
      padding: EdgeInsets.all(ResponsiveConfig.responsivePadding(context, 16)),
      child: Row(
        children: [
          // Show entries dropdown
          Row(
            children: [
              Text(
                "Show",
                style: AppTextStyles.getBody(context).copyWith(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: ResponsiveConfig.spacingXs(context)),
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
                  items: ['10', '25', '50', '100'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEntries = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(width: ResponsiveConfig.spacingXs(context)),
              Text(
                "entries",
                style: AppTextStyles.getBody(context).copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),

          // Search field
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: ResponsiveConfig.spacingMd(context)),
              child: CustomTextField(
                controller: _searchController,
                hintText: "Search...",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: ResponsiveConfig.responsiveFont(context, 20),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConfig.responsivePadding(context, 12),
                  vertical: ResponsiveConfig.responsivePadding(context, 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.responsivePadding(context, 16),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: ResponsiveConfig.responsivePadding(context, 16),
          headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
          dataRowMaxHeight: ResponsiveConfig.responsiveHeight(context, 80),
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
                'Image',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Category Name',
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
                'Barcode',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Products',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
          rows: _categories.map((category) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    category.id.toString(),
                    style: AppTextStyles.getBody(context),
                  ),
                ),
                DataCell(
                  Container(
                    width: ResponsiveConfig.responsiveWidth(context, 50),
                    height: ResponsiveConfig.responsiveHeight(context, 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        category.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.category,
                            color: Colors.grey[400],
                            size: ResponsiveConfig.responsiveFont(context, 24),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: ResponsiveConfig.responsiveWidth(context, 150),
                    child: Text(
                      category.name,
                      style: AppTextStyles.getBody(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveConfig.responsivePadding(context, 8),
                      vertical: ResponsiveConfig.responsivePadding(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      category.sku,
                      style: AppTextStyles.getSmall(context).copyWith(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    category.barcode,
                    style: AppTextStyles.getBody(context),
                  ),
                ),
                DataCell(
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveConfig.responsivePadding(context, 8),
                      vertical: ResponsiveConfig.responsivePadding(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Text(
                      '${category.productCount}',
                      style: AppTextStyles.getSmall(context).copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      // Update button
                      IconButton(
                        onPressed: () => _updateCategory(category),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: ResponsiveConfig.responsiveFont(context, 20),
                        ),
                        tooltip: 'Update Category',
                      ),
                      SizedBox(width: ResponsiveConfig.spacingXs(context)),
                      // Delete button
                      IconButton(
                        onPressed: () => _deleteCategory(category.id),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: ResponsiveConfig.responsiveFont(context, 20),
                        ),
                        tooltip: 'Delete Category',
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

  void _updateCategory(CategoryItem category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCategoryScreen(
          categoryData: {
            'id': category.id,
            'name': category.name,
            'sku': category.sku,
            'barcode': category.barcode,
            'imageUrl': category.imageUrl,
          },
        ),
      ),
    );
  }

  void _deleteCategory(int id) {
    setState(() {
      _categories.removeWhere((category) => category.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category #$id deleted'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _categories.insert(id - 1, CategoryItem(
                id: id,
                name: 'Restored Category',
                sku: 'CAT-000',
                barcode: '0000000000000',
                imageUrl: 'assets/category.jpg',
                productCount: 0,
              ));
            });
          },
        ),
      ),
    );
  }
}

class CategoryItem {
  final int id;
  final String name;
  final String sku;
  final String barcode;
  final String imageUrl;
  final int productCount;

  CategoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.imageUrl,
    required this.productCount,
  });
}
