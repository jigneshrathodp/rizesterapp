import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../App_model/product_model/UpdateProductModel.dart';
import '../App_model/Category_model/GetCatgoryModel.dart';
import '../App_model/category_helper.dart';
import '../services/snackbar_service.dart';

class UpdateProductController extends GetxController {
  final int productId;
  
  // Form key
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Text controllers
  final categoryController = TextEditingController();
  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final quantityController = TextEditingController();
  final weightGmController = TextEditingController();
  final costPerGmController = TextEditingController();
  final totalCostController = TextEditingController();
  final sellingPriceController = TextEditingController();
  
  // Reactive variables
  final categories = <CategoryHelper>[].obs;
  final selectedStatus = 'Active'.obs;
  final selectedSoldStatus = 'Unsold'.obs;
  final forSale = true.obs;
  final selectedImage = Rx<XFile?>(null);
  final isLoading = false.obs;
  final isCategoriesLoading = false.obs;
  final isProductLoading = false.obs;
  final selectedCategory = Rx<CategoryHelper?>(null);
  
  final ImagePicker picker = ImagePicker();
  
  UpdateProductController({required this.productId});
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProductDetails();
  }
  
  @override
  void onClose() {
    categoryController.dispose();
    nameController.dispose();
    skuController.dispose();
    quantityController.dispose();
    weightGmController.dispose();
    costPerGmController.dispose();
    totalCostController.dispose();
    sellingPriceController.dispose();
    super.onClose();
  }
  
  // Fetch categories from API
  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      GetCatgoryModel categoryModel = await AuthService.getCategoryList();
      if (categoryModel.data != null) {
        categories.value = categoryModel.data!.map((category) => 
          CategoryHelper.fromJson(category.toJson())
        ).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories: $e');
    } finally {
      isCategoriesLoading.value = false;
    }
  }
  
  // Fetch product details from API
  Future<void> fetchProductDetails() async {
    try {
      isProductLoading.value = true;
      UpdateProductModel productModel = await AuthService.getProductById(productId);
      if (productModel.data != null) {
        final product = productModel.data!;
        
        // Set text controllers
        nameController.text = product.name ?? '';
        skuController.text = product.sku ?? '';
        quantityController.text = product.quantity ?? '';
        weightGmController.text = product.weightInGram ?? '';
        costPerGmController.text = product.costPerGram ?? '';
        totalCostController.text = product.totalCost?.toString() ?? '';
        sellingPriceController.text = product.sellPrice ?? '';
        
        // Set status
        selectedStatus.value = product.active == 1 ? 'Active' : 'Inactive';
        
        // Set for sale
        forSale.value = product.forSale == 1;
        
        // Set category
        if (product.categoryId != null) {
          // Set initial category controller text to show loading state
          categoryController.text = 'Loading...';
          
          // Update category name when categories are loaded
          ever(categories, (_) {
            final category = categories.firstWhereOrNull(
              (cat) => cat.id.toString() == product.categoryId,
            );
            if (category != null) {
              selectedCategory.value = category;
              categoryController.text = category.name;
            } else {
              categoryController.text = '';
            }
          });
          
          // Also try to set immediately if categories are already loaded
          if (categories.isNotEmpty) {
            final category = categories.firstWhereOrNull(
              (cat) => cat.id.toString() == product.categoryId,
            );
            if (category != null) {
              selectedCategory.value = category;
              categoryController.text = category.name;
            } else {
              categoryController.text = '';
            }
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details: $e');
    } finally {
      isProductLoading.value = false;
    }
  }
  
  void updateCategory(CategoryHelper? category) {
    if (category != null) {
      selectedCategory.value = category;
      categoryController.text = category.name;
    }
  }
  
  void updateCategoryString(String? value) {
    if (value != null) {
      categoryController.text = value;
      // Find the category object
      selectedCategory.value = categories.firstWhereOrNull(
        (cat) => cat.name == value,
      );
    }
  }
  
  void updateStatus(String? value) {
    if (value != null) {
      selectedStatus.value = value;
    }
  }
  
  void updateSoldStatus(String? value) {
    if (value != null) {
      selectedSoldStatus.value = value;
    }
  }
  
  void toggleForSale(bool? value) {
    forSale.value = value ?? false;
  }
  
  Future<void> pickImage() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  selectedImage.value = image;
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  selectedImage.value = image;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void removeImage() {
    selectedImage.value = null;
  }
  
  Future<void> handleSubmit() async {
    if (formKey.currentState!.validate()) {
      if (selectedCategory.value == null) {
        Get.snackbar('Error', 'Please select a category');
        return;
      }
      
      isLoading.value = true;
      
      try {
        UpdateProductModel result = await AuthService.updateProduct(
          id: productId,
          name: nameController.text,
          category: selectedCategory.value!.categoryId,
          qnty: quantityController.text,
          weightInGram: weightGmController.text,
          costPerGram: costPerGmController.text,
          image: selectedImage.value,
          sts: selectedStatus.value == 'Active' ? '1' : '0',
          forSale: forSale.value ? '1' : '0',
        );
        
        if (result.status == true) {
          SnackbarService.showSuccess(result.message ?? 'Product updated successfully');
          Navigator.of(Get.context!).pop();
        } else {
          SnackbarService.showError(result.message ?? 'Failed to update product');
        }
      } catch (e) {
        SnackbarService.showException(Exception(e));
      } finally {
        isLoading.value = false;
      }
    }
  }
}
