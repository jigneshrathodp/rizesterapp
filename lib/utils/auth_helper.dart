import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthHelper extends GetxService {
  static AuthHelper get to => Get.find();
  
  final _isLoggedIn = false.obs;
  
  bool get isLoggedIn => _isLoggedIn.value;
  
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    _isLoggedIn.value = await AuthService.isLoggedIn();
  }
  
  Future<void> login() async {
    _isLoggedIn.value = true;
  }
  
  Future<void> logout() async {
    try {
      await AuthService.logout();
    } catch (e) {
      await AuthService.clearAuthData();
    } finally {
      _isLoggedIn.value = false;
    }
  }
  
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }
}
