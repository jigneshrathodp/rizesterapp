import 'package:flutter/material.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final _searchController = TextEditingController();
  String _selectedEntries = '10';
  List<OrderItem> _orders = [
    OrderItem(
      id: 1,
      imageUrl: 'assets/headphones.jpg',
      productName: 'Noise Cancelling Headphones',
      category: 'Electronics',
      userName: 'Jignesh Rathod',
      shippingCost: '₹0',
      totalPrice: '₹999.99',
      date: '27-02-2026',
    ),
    OrderItem(
      id: 2,
      imageUrl: 'assets/laptop.jpg',
      productName: 'MacBook Pro M2',
      category: 'Computers',
      userName: 'Jane Smith',
      shippingCost: '₹50',
      totalPrice: '₹1,299.00',
      date: '27-02-2026',
    ),
    OrderItem(
      id: 3,
      imageUrl: 'assets/phone.jpg',
      productName: 'iPhone 13 Pro',
      category: 'Mobile',
      userName: 'John Doe',
      shippingCost: '₹0',
      totalPrice: '₹799.99',
      date: '26-02-2026',
    ),
    OrderItem(
      id: 4,
      imageUrl: 'assets/watch.jpg',
      productName: 'Smart Watch Ultra',
      category: 'Wearables',
      userName: 'Mike Johnson',
      shippingCost: '₹25',
      totalPrice: '₹399.99',
      date: '26-02-2026',
    ),
    OrderItem(
      id: 5,
      imageUrl: 'assets/tablet.jpg',
      productName: 'iPad Air',
      category: 'Tablets',
      userName: 'Sarah Wilson',
      shippingCost: '₹0',
      totalPrice: '₹599.99',
      date: '25-02-2026',
    ),
    OrderItem(
      id: 6,
      imageUrl: 'assets/camera.jpg',
      productName: 'DSLR Camera',
      category: 'Photography',
      userName: 'David Brown',
      shippingCost: '₹75',
      totalPrice: '₹1,499.00',
      date: '25-02-2026',
    ),
    OrderItem(
      id: 7,
      imageUrl: 'assets/speaker.jpg',
      productName: 'Bluetooth Speaker',
      category: 'Audio',
      userName: 'Emma Davis',
      shippingCost: '₹15',
      totalPrice: '₹149.99',
      date: '24-02-2026',
    ),
    OrderItem(
      id: 8,
      imageUrl: 'assets/keyboard.jpg',
      productName: 'Mechanical Keyboard',
      category: 'Accessories',
      userName: 'Chris Lee',
      shippingCost: '₹10',
      totalPrice: '₹199.99',
      date: '24-02-2026',
    ),
    OrderItem(
      id: 9,
      imageUrl: 'assets/mouse.jpg',
      productName: 'Gaming Mouse',
      category: 'Accessories',
      userName: 'Alex Kim',
      shippingCost: '₹5',
      totalPrice: '₹79.99',
      date: '23-02-2026',
    ),
    OrderItem(
      id: 10,
      imageUrl: 'assets/monitor.jpg',
      productName: '4K Monitor',
      category: 'Displays',
      userName: 'Lisa Chen',
      shippingCost: '₹100',
      totalPrice: '₹899.99',
      date: '23-02-2026',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Orders List',
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
                
                // Top controls
                _buildTopControls(),
                
                CustomSpacer(height: 20),
                
                // Table
                _buildTable(),
                
                CustomSpacer(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    return CustomCard(
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
      child: CustomRow(
        children: [
          // Show entries dropdown
          CustomRow(
            children: [
              Text(
                "Show",
                style: AppTextStyles.getBody(context).copyWith(
                  color: Colors.grey[700],
                ),
              ),
              CustomSpacer(width: ResponsiveConfig.spacingXs(context)),
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
              CustomSpacer(width: ResponsiveConfig.spacingXs(context)),
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
    return CustomCard(
      padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
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
                'Product Name',
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
                'User Name',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Shipping Cost',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Total Price',
                style: AppTextStyles.getBody(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
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
          rows: _orders.map((order) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    order.id.toString(),
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
                        order.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
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
                      order.productName,
                      style: AppTextStyles.getBody(context),
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
                      color: _getCategoryColor(order.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.category,
                      style: AppTextStyles.getSmall(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    order.userName,
                    style: AppTextStyles.getBody(context),
                  ),
                ),
                DataCell(
                  Text(
                    order.shippingCost,
                    style: AppTextStyles.getBody(context).copyWith(
                      fontWeight: FontWeight.w500,
                      color: order.shippingCost == '₹0' ? Colors.green : Colors.black87,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    order.totalPrice,
                    style: AppTextStyles.getBody(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    order.date,
                    style: AppTextStyles.getBody(context),
                  ),
                ),
                DataCell(
                  IconButton(
                    onPressed: () => _deleteOrder(order.id),
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: ResponsiveConfig.responsiveFont(context, 20),
                    ),
                    tooltip: 'Delete Order',
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Colors.blue;
      case 'computers':
        return Colors.purple;
      case 'mobile':
        return Colors.green;
      case 'wearables':
        return Colors.orange;
      case 'tablets':
        return Colors.red;
      case 'photography':
        return Colors.brown;
      case 'audio':
        return Colors.teal;
      case 'accessories':
        return Colors.indigo;
      case 'displays':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _deleteOrder(int id) {
    setState(() {
      _orders.removeWhere((order) => order.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #$id deleted'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _orders.insert(id - 1, OrderItem(
                id: id,
                imageUrl: 'assets/headphones.jpg',
                productName: 'Restored Order',
                category: 'Electronics',
                userName: 'Restored User',
                shippingCost: '₹0',
                totalPrice: '₹0.00',
                date: '27-02-2026',
              ));
            });
          },
        ),
      ),
    );
  }
}

class OrderItem {
  final int id;
  final String imageUrl;
  final String productName;
  final String category;
  final String userName;
  final String shippingCost;
  final String totalPrice;
  final String date;

  OrderItem({
    required this.id,
    required this.imageUrl,
    required this.productName,
    required this.category,
    required this.userName,
    required this.shippingCost,
    required this.totalPrice,
    required this.date,
  });
}
