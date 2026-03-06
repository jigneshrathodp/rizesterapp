import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_ad_controller.dart';
import '../../utils/responsive_config.dart';
import '../../widgets/widgets.dart';
import 'package:rizesterapp/screens/main_screen.dart';
import '../notification_screen.dart' as notification;
import 'package:rizesterapp/screens/Profile/profile_screen.dart';

class CreateAdScreen extends StatefulWidget {
  final bool showAppBar;
  const CreateAdScreen({super.key, this.showAppBar = false});

  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateAdController());
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
                selectedIndex: 7,
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
          const ScreenTitle(title: 'Create Advertisement'),
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: Form(
              key: controller.formKey,
              child: CustomColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSpacer(height: 30),
                  CustomTextField(
                    controller: controller.titleController,
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
                  DropdownButtonFormField<String>(
                    value: controller.selectedPlatform.value.isEmpty ? null : controller.selectedPlatform.value,
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
                      controller.selectedPlatform.value = value ?? '';
                      controller.platformController.text = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a platform';
                      }
                      return null;
                    },
                  ),
                  CustomSpacer(height: 16),
                  CustomTextField(
                    controller: controller.dateController,
                    labelText: 'Date',
                    hintText: 'Select date',
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.black),
                    readOnly: true,
                    onTap: () => controller.selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date';
                      }
                      return null;
                    },
                  ),
                  CustomSpacer(height: 16),
                  CustomTextField(
                    controller: controller.priceController,
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
                  CustomTextField(
                    controller: controller.urlController,
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
                  CustomRow(
                    children: [
                      Expanded(
                        child: CustomOutlineButton(
                          text: 'Cancel',
                          onPressed: () => Get.back(),
                        ),
                      ),
                      CustomSpacer(width: 16),
                      Expanded(
                        child: Obx(
                          () => CustomButton(
                            text: 'Create Ad',
                            onPressed: controller.handleSubmit,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            isLoading: controller.isLoading.value,
                          ),
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
}
