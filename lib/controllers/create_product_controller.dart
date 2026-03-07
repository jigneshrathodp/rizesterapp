import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../App_model/product_model/CreateProductModel.dart';
import '../App_model/Category_model/GetCatgoryModel.dart';
import '../App_model/category_helper.dart';
import '../services/snackbar_service.dart';

class CreateProductController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();
  
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
  final jewelleryCategories = ['Rings', 'Necklaces', 'Earrings', 'Bracelets', 'Pendants', 'Chains', 'Bangles', 'Anklets'].obs;
  final selectedStatus = 'Active'.obs;
  final selectedSoldStatus = 'Unsold'.obs;
  final forSale = true.obs;
  final selectedImage = Rx<XFile?>(null);
  final isLoading = false.obs;
  final isCategoriesLoading = false.obs;
  final selectedCategory = Rx<CategoryHelper?>(null);
  
  final ImagePicker picker = ImagePicker();
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
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
  
  void toggleForSale(bool? value) {
    forSale.value = value ?? false;
  }
  
  void updateSoldStatus(String? value) {
    if (value != null) {
      selectedSoldStatus.value = value;
    }
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
        CreateProductModel result = await AuthService.createProduct(
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
          SnackbarService.showSuccess(result.message ?? 'Product created successfully');
          clearForm();
          Get.back();
        } else {
          SnackbarService.showError(result.message ?? 'Failed to create product');
        }
      } catch (e) {
        SnackbarService.showException(Exception(e.toString()));
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  void clearForm() {
    nameController.clear();
    categoryController.clear();
    skuController.clear();
    quantityController.clear();
    weightGmController.clear();
    costPerGmController.clear();
    totalCostController.clear();
    sellingPriceController.clear();
    selectedCategory.value = null;
    selectedImage.value = null;
    selectedStatus.value = 'Active';
    forSale.value = true;
  }
}
