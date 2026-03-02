import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../App_model/profile_model/GetProfileModel.dart';
import '../App_model/profile_model/UpdateProfileModel.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final siteNameController = TextEditingController();
  final addressController = TextEditingController();
  final footerController = TextEditingController();

  final profilePhoto = Rx<XFile?>(null);
  final favIcon = Rx<XFile?>(null);
  final logoLight = Rx<XFile?>(null);
  final logoDark = Rx<XFile?>(null);
  final isLoading = false.obs;
  final isLoadingProfile = false.obs;
  
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var profileData = Rxn<GetProfileModel>();
  
  final ImagePicker picker = ImagePicker();
  
  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }
  
  Future<void> loadProfileData() async {
    isLoadingProfile.value = true;
    try {
      profileData.value = await AuthService.getProfileDetails();
      
      if (profileData.value?.user != null) {
        nameController.text = profileData.value!.user!.name ?? '';
        emailController.text = profileData.value!.user!.email ?? '';
        contactController.text = profileData.value!.user!.contact ?? '';
      }
      
      if (profileData.value?.details != null) {
        siteNameController.text = profileData.value!.details!.siteName ?? '';
        addressController.text = profileData.value!.details!.address ?? '';
        footerController.text = profileData.value!.details!.footer ?? '';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load profile: $e';
    } finally {
      isLoadingProfile.value = false;
    }
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    siteNameController.dispose();
    addressController.dispose();
    footerController.dispose();
    super.onClose();
  }
  
  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
  
  Future<void> updateProfile() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      clearMessages();
      
      try {
        Map<String, dynamic> profileDataMap = {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'contact': contactController.text.trim(),
        };
        
        UpdateProfileModel result = await AuthService.updateProfile(profileDataMap);
        
        if (result.status == true) {
          successMessage.value = result.message ?? 'Profile updated successfully';
          // Reload profile data
          await loadProfileData();
        } else {
          errorMessage.value = result.message ?? 'Failed to update profile';
        }
      } catch (e) {
        errorMessage.value = 'Update failed: $e';
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  Future<void> pickImage(String imageType) async {
    Get.dialog(
      AlertDialog(
        title: Text('Choose ${getImageTitle(imageType)}'),
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
                  setImageByType(imageType, image);
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
                  setImageByType(imageType, image);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  String getImageTitle(String imageType) {
    switch (imageType) {
      case 'profile':
        return 'Profile Photo';
      case 'favIcon':
        return 'Fav Icon';
      case 'logoLight':
        return 'Logo Light';
      case 'logoDark':
        return 'Logo Dark';
      default:
        return 'Image';
    }
  }

  void setImageByType(String imageType, XFile image) {
    switch (imageType) {
      case 'profile':
        profilePhoto.value = image;
        break;
      case 'favIcon':
        favIcon.value = image;
        break;
      case 'logoLight':
        logoLight.value = image;
        break;
      case 'logoDark':
        logoDark.value = image;
        break;
    }
  }

  XFile? getImageByType(String imageType) {
    switch (imageType) {
      case 'profile':
        return profilePhoto.value;
      case 'favIcon':
        return favIcon.value;
      case 'logoLight':
        return logoLight.value;
      case 'logoDark':
        return logoDark.value;
      default:
        return null;
    }
  }

  void removeImage(String imageType) {
    setImageByType(imageType, XFile(''));
  }

  void handleSubmit() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        showSuccessDialog();
      });
    }
  }
  
  void showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Success'),
        content: const Text('Profile updated successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
