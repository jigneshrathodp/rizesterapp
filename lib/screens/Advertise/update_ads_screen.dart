import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';
import '../../services/advertise_service.dart';
import '../../App_model/Advertise_model/UpdateAdvertiseModel.dart';

class UpdateAdsScreen extends StatefulWidget {
  final Map<String, dynamic> adData;
  final bool showAppBar;

  const UpdateAdsScreen({super.key, required this.adData, this.showAppBar = false});

  @override
  State<UpdateAdsScreen> createState() => _UpdateAdsScreenState();
}

class _UpdateAdsScreenState extends State<UpdateAdsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _urlController;
  late final TextEditingController _platformController;
  String _selectedPlatform = '';
  late final TextEditingController _dateController;
  DateTime selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.adData['title'] ?? '');
    _priceController = TextEditingController(text: widget.adData['price']?.toString() ?? '');
    _urlController = TextEditingController(text: widget.adData['url'] ?? '');
    _platformController = TextEditingController(text: widget.adData['socialmedia'] ?? '');
    _selectedPlatform = widget.adData['socialmedia'] ?? '';
    _dateController = TextEditingController(text: widget.adData['date'] ?? '');
    
    // Parse existing date if available
    if (widget.adData['date'] != null && widget.adData['date'].isNotEmpty) {
      try {
        selectedDate = DateTime.parse(widget.adData['date']);
      } catch (e) {
        selectedDate = DateTime.now();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _urlController.dispose();
    _platformController.dispose();
    _dateController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: widget.showAppBar
          ? CustomAppBar(
              logoAsset: 'assets/black.png',
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
              onNotificationPressed: () => Get.to(() => const notification.NotificationScreen()),
              onProfilePressed: () => Get.to(() => const ProfileScreen()),
            )
          : null,
      drawer: widget.showAppBar
          ? SizedBox(
              width: ResponsiveConfig.getWidth(context) * 0.6,
              child: CustomDrawer(
                selectedIndex: 5,
                onItemTapped: (index) {
                  Navigator.pop(context);
                  Get.offAll(() => const MainScreen());
                  Future.microtask(() {
                    final main = Get.find<MainScreenController>();
                    main.onItemTapped(index);
                  });
                },
                logoAsset: 'assets/white.png',
              ),
            )
          : null,
      body: CustomScrollWidget(
        children: [
          const ScreenTitle(title: 'Update Advertisement'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: Form(
              key: _formKey,
              child: CustomColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSpacer(height: 30),
                  
                  // Ad Title
                  CustomTextField(
                    controller: _titleController,
                    labelText: 'Ad Title',
                    hintText: 'Enter advertisement title',
                    prefixIcon: const Icon(Icons.title, color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ad title';
                      }
                      if (value.length < 2) {
                        return 'Title must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Platform
                  DropdownButtonFormField<String>(
                    value: _selectedPlatform.isEmpty ? null : _selectedPlatform,
                    decoration: const InputDecoration(
                      labelText: 'Platform',
                      hintText: 'Select social media platform',
                      prefixIcon: Icon(Icons.public, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'instagram', child: Text('Instagram')),
                      DropdownMenuItem(value: 'facebook', child: Text('Facebook')),
                      DropdownMenuItem(value: 'threads', child: Text('Threads')),
                      DropdownMenuItem(value: 'pinterest', child: Text('Pinterest')),
                      DropdownMenuItem(value: 'twitter', child: Text('Twitter')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPlatform = value ?? '';
                        _platformController.text = value ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a platform';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Date
                  CustomTextField(
                    controller: _dateController,
                    labelText: 'Date',
                    hintText: 'Select date',
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.black),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Budget/Price
                  CustomTextField(
                    controller: _priceController,
                    labelText: 'Budget/Price',
                    hintText: 'Enter budget amount',
                    prefixIcon: const Icon(Icons.attach_money, color: Colors.black),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter budget amount';
                      }
                      if (double.tryParse(value.replaceAll('\$', '')) == null) {
                        return 'Please enter valid amount';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Destination URL
                  CustomTextField(
                    controller: _urlController,
                    labelText: 'Destination URL',
                    hintText: 'Enter landing page URL',
                    prefixIcon: const Icon(Icons.link, color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter destination URL';
                      }
                      // More flexible URL validation
                      if (!Uri.parse(value).hasAbsolutePath && !value.startsWith('http')) {
                        return 'Please enter valid URL (e.g., https://example.com)';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 32),
                  
                  // Action Buttons
                  CustomRow(
                    children: [
                      Expanded(
                        child: CustomOutlineButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      CustomSpacer(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Update Ad',
                          onPressed: _handleSubmit,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          isLoading: _isLoading,
                        ),
                      ),
                    ],
                  ),
                  
                  CustomSpacer(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final advertiseData = {
          'title': _titleController.text.trim(),
          'price': int.tryParse(_priceController.text.replaceAll('\$', '').trim()) ?? 0,
          'url': _urlController.text.trim(),
          'socialmedia': _platformController.text.trim(),
          'date': _dateController.text.trim(),
        };

        UpdateAdvertiseModel result = await AdvertiseService.updateAdvertise(
          widget.adData['id'],
          advertiseData,
        );
        
        setState(() {
          _isLoading = false;
        });
        
        if (result.status == true) {
          _showSuccessDialog();
        } else {
          Get.snackbar(
            'Error',
            result.message ?? 'Failed to update advertisement',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        Get.snackbar(
          'Error',
          'Failed to update advertisement: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Advertisement updated successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to list screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
