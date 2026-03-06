import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../App_model/profile_model/GetProfileModel.dart';

class GlobalProfileController extends GetxController {
  static GlobalProfileController get to => Get.find();
  
  // Observable profile data
  var profileModel = Rxn<GetProfileModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // Profile image URL for easy access
  String get profileImageUrl => profileModel.value?.user?.image ?? '';
  
  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }
  
  // Load profile data
  Future<void> loadProfileData() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      profileModel.value = await AuthService.getProfileDetails();
    } catch (e) {
      errorMessage.value = 'Failed to load profile: $e';
    } finally {
      isLoading.value = false;
    }
  }
  
  // Refresh profile data
  Future<void> refreshProfileData() async {
    await loadProfileData();
  }
  
  // Check if user has profile image
  bool get hasProfileImage => profileImageUrl.isNotEmpty;
  
  // Get user name
  String get userName => profileModel.value?.user?.name ?? 'User';
  
  // Get user email
  String get userEmail => profileModel.value?.user?.email ?? 'user@example.com';
  
  // Get user contact
  String get userContact => profileModel.value?.user?.contact ?? '';
}
