import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../services/snackbar_service.dart';
import '../App_model/product_model/GetproductModel.dart';

class OrderNowController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final products = <ProductItem>[].obs;
  final hasReachedMax = false.obs;
  final currentPage = 1.obs;
  final pageSize = 20;
  final searchQuery = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
  
  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasReachedMax.value = false;
      products.clear();
    }
    
    if (isLoading.value || hasReachedMax.value) return;
    
    try {
      isLoading.value = true;
      
      String? token = await AuthService.getToken();
      
      if (token == null) {
        SnackbarService.showError('No authentication token found');
        return;
      }
      
      GetproductModel result = await ProductService.getProductList(
        token, 
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (result.status == true && result.data != null) {
        if (refresh) {
          products.clear();
        }
        
        for (var productData in result.data!) {
          products.add(ProductItem.fromApiData(productData));
        }
        
        // Check if we've reached the end
        if (result.data!.length < pageSize) {
          hasReachedMax.value = true;
        } else {
          currentPage.value++;
        }
      }
      
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadMoreProducts() async {
    if (isLoadingMore.value || hasReachedMax.value) return;
    
    try {
      isLoadingMore.value = true;
      
      String? token = await AuthService.getToken();
      
      if (token == null) {
        SnackbarService.showError('No authentication token found');
        return;
      }
      
      GetproductModel result = await ProductService.getProductList(
        token, 
        page: currentPage.value,
        limit: pageSize,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (result.status == true && result.data != null) {
        for (var productData in result.data!) {
          products.add(ProductItem.fromApiData(productData));
        }
        
        if (result.data!.length < pageSize) {
          hasReachedMax.value = true;
        } else {
          currentPage.value++;
        }
      }
      
    } catch (e) {
      SnackbarService.showException(Exception(e.toString()));
    } finally {
      isLoadingMore.value = false;
    }
  }
  
  void searchProducts(String query) {
    searchQuery.value = query;
    fetchProducts(refresh: true);
  }
  
  void refreshProducts() {
    fetchProducts(refresh: true);
  }
}

class ProductItem {
  final int id;
  final String name;
  final double costPerGram;
  final int weight;
  final String imageUrl;
  final String category;
  final String quantity;
  final String sellPrice;
  final int active;
  final int forSale;

  ProductItem({
    required this.id,
    required this.name,
    required this.costPerGram,
    required this.weight,
    required this.imageUrl,
    required this.category,
    required this.quantity,
    required this.sellPrice,
    required this.active,
    required this.forSale,
  });
  
  // Factory method to create ProductItem from API data
  factory ProductItem.fromApiData(Data data) {
    return ProductItem(
      id: data.id ?? 0,
      name: data.name ?? 'Unknown Product',
      costPerGram: double.tryParse(data.costPerGram?.toString() ?? '0') ?? 0.0,
      weight: int.tryParse(data.weightInGram?.toString() ?? '0') ?? 0,
      imageUrl: data.image ?? 'assets/default_product.jpg',
      category: data.categoryId?.toString() ?? 'Unknown',
      quantity: data.quantity?.toString() ?? '0',
      sellPrice: data.sellPrice?.toString() ?? '0',
      active: data.active ?? 0,
      forSale: data.forSale ?? 0,
    );
  }
}
