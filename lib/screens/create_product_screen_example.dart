import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/responsive_config.dart';
import '../widgets/widgets.dart';

class CreateProductScreenExample extends StatefulWidget {
  const CreateProductScreenExample({super.key});

  @override
  State<CreateProductScreenExample> createState() => _CreateProductScreenExampleState();
}

class _CreateProductScreenExampleState extends State<CreateProductScreenExample> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController(text: 'Rings');
  final List<String> _jewelleryCategories = ['Rings', 'Necklaces', 'Earrings', 'Bracelets', 'Pendants', 'Chains', 'Bangles', 'Anklets'];
  final _nameController = TextEditingController(text: 'Gold Diamond Ring');
  final _skuController = TextEditingController(text: 'JWL-001');
  final _quantityController = TextEditingController(text: '2');
  final _weightGmController = TextEditingController(text: '5.2');
  final _costPerGmController = TextEditingController(text: '4500');
  final _totalCostController = TextEditingController(text: '46800');
  final _sellingPriceController = TextEditingController(text: '52000');
  String _selectedStatus = 'Active';
  bool _forSale = true;
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Create Product',
        onBackPressed: () => Navigator.pop(context),
        showNotifications: false,
        showProfile: false,
      ),
      body: CustomScrollWidget(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
            child: Form(
              key: _formKey,
              child: CustomColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSpacer(height: 30),
                  
                  // Image Upload Section
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: ResponsiveConfig.responsiveHeight(context, 200),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _selectedImagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
                              child: Image.asset(
                                _selectedImagePath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(context),
                              ),
                            )
                          : _buildImagePlaceholder(context),
                    ),
                  ),
                  
                  CustomSpacer(height: 24),
                  
                  // Category Dropdown
                  CustomTextFormField(
                    controller: _categoryController,
                    labelText: 'Category',
                    hintText: 'Select category',
                    isDropdown: true,
                    dropdownItems: _jewelleryCategories,
                    onChanged: (value) {
                      setState(() {
                        _categoryController.text = value!;
                      });
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Product Name
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Product Name',
                    hintText: 'Enter product name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // SKU
                  CustomTextFormField(
                    controller: _skuController,
                    labelText: 'SKU',
                    hintText: 'Enter SKU',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter SKU';
                      }
                      return null;
                    },
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Quantity and Weight Row
                  ResponsiveLayout(
                    mobile: CustomColumn(
                      children: [
                        CustomTextFormField(
                          controller: _quantityController,
                          labelText: 'Quantity',
                          hintText: 'Enter quantity',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter quantity';
                            }
                            return null;
                          },
                        ),
                        CustomSpacer(height: 16),
                        CustomTextFormField(
                          controller: _weightGmController,
                          labelText: 'Weight (gm)',
                          hintText: 'Enter weight in grams',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    tablet: CustomRow(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: _quantityController,
                            labelText: 'Quantity',
                            hintText: 'Enter quantity',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter quantity';
                              }
                              return null;
                            },
                          ),
                        ),
                        CustomSpacer(width: 16),
                        Expanded(
                          child: CustomTextFormField(
                            controller: _weightGmController,
                            labelText: 'Weight (gm)',
                            hintText: 'Enter weight in grams',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter weight';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  CustomSpacer(height: 16),
                  
                  // Cost and Price Row
                  ResponsiveLayout(
                    mobile: CustomColumn(
                      children: [
                        CustomTextFormField(
                          controller: _costPerGmController,
                          labelText: 'Cost per gm',
                          hintText: 'Enter cost per gram',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter cost per gram';
                            }
                            return null;
                          },
                        ),
                        CustomSpacer(height: 16),
                        CustomTextFormField(
                          controller: _totalCostController,
                          labelText: 'Total Cost',
                          hintText: 'Enter total cost',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter total cost';
                            }
                            return null;
                          },
                        ),
                        CustomSpacer(height: 16),
                        CustomTextFormField(
                          controller: _sellingPriceController,
                          labelText: 'Selling Price',
                          hintText: 'Enter selling price',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter selling price';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    tablet: CustomColumn(
                      children: [
                        CustomRow(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: _costPerGmController,
                                labelText: 'Cost per gm',
                                hintText: 'Enter cost per gram',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter cost per gram';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            CustomSpacer(width: 16),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _totalCostController,
                                labelText: 'Total Cost',
                                hintText: 'Enter total cost',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter total cost';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        CustomSpacer(height: 16),
                        CustomTextFormField(
                          controller: _sellingPriceController,
                          labelText: 'Selling Price',
                          hintText: 'Enter selling price',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter selling price';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  CustomSpacer(height: 24),
                  
                  // Status and For Sale switches
                  CustomRow(
                    children: [
                      Expanded(
                        child: CustomCard(
                          padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
                          child: CustomRow(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: AppTextStyles.getBody(context),
                              ),
                              Switch(
                                value: _selectedStatus == 'Active',
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStatus = value ? 'Active' : 'Inactive';
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomSpacer(width: 16),
                      Expanded(
                        child: CustomCard(
                          padding: EdgeInsets.all(ResponsiveConfig.spacingMd(context)),
                          child: CustomRow(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'For Sale',
                                style: AppTextStyles.getBody(context),
                              ),
                              Switch(
                                value: _forSale,
                                onChanged: (value) {
                                  setState(() {
                                    _forSale = value;
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                          text: 'Create Product',
                          onPressed: _createProduct,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
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

  Widget _buildImagePlaceholder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: ResponsiveConfig.responsiveFont(context, 48),
          color: Colors.grey[400],
        ),
        CustomSpacer(height: 8),
        Text(
          'Tap to add image',
          style: AppTextStyles.getBody(context).copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _createProduct() {
    if (_formKey.currentState!.validate()) {
      // Create product logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}

// Extended CustomTextField with dropdown support
class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.isDropdown = false,
    this.dropdownItems,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDropdown && dropdownItems != null) {
      return DropdownButtonFormField<String>(
        value: controller?.text,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveConfig.responsiveRadius(context, 12)),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveConfig.responsivePadding(context, 16),
            vertical: ResponsiveConfig.responsivePadding(context, 14),
          ),
        ),
        items: dropdownItems!.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      );
    }

    return CustomTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
