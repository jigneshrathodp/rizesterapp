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
  
  // Existing image URLs
  final existingProfilePhoto = Rx<String?>(null);
  final existingFavIcon = Rx<String?>(null);
  final existingLogoLight = Rx<String?>(null);
  final existingLogoDark = Rx<String?>(null);
  
  // Image loading states
  final profilePhotoLoading = false.obs;
  final favIconLoading = false.obs;
  final logoLightLoading = false.obs;
  final logoDarkLoading = false.obs;
  
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
        
        // Load existing profile photo if available
        if (profileData.value!.user!.image != null && profileData.value!.user!.image!.isNotEmpty) {
          existingProfilePhoto.value = profileData.value!.user!.image;
        }
      }
      
      if (profileData.value?.details != null) {
        siteNameController.text = profileData.value!.details!.siteName ?? '';
        addressController.text = profileData.value!.details!.address ?? '';
        footerController.text = profileData.value!.details!.footer ?? '';
        
        // Load existing site images if available
        if (profileData.value!.details!.favIcon != null && profileData.value!.details!.favIcon!.isNotEmpty) {
          existingFavIcon.value = profileData.value!.details!.favIcon;
        }
        if (profileData.value!.details!.logoLight != null && profileData.value!.details!.logoLight!.isNotEmpty) {
          existingLogoLight.value = profileData.value!.details!.logoLight;
        }
        if (profileData.value!.details!.logoDark != null && profileData.value!.details!.logoDark!.isNotEmpty) {
          existingLogoDark.value = profileData.value!.details!.logoDark;
        }
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
          'site_name': siteNameController.text.trim(),
          'address': addressController.text.trim(),
          'footer': footerController.text.trim(),
        };
        
        // Add image data if new images are selected
        if (profilePhoto.value != null && profilePhoto.value!.path.isNotEmpty) {
          profileDataMap['profile_photo'] = profilePhoto.value!.path;
        }
        if (favIcon.value != null && favIcon.value!.path.isNotEmpty) {
          profileDataMap['fav_icon'] = favIcon.value!.path;
        }
        if (logoLight.value != null && logoLight.value!.path.isNotEmpty) {
          profileDataMap['logo_light'] = logoLight.value!.path;
        }
        if (logoDark.value != null && logoDark.value!.path.isNotEmpty) {
          profileDataMap['logo_dark'] = logoDark.value!.path;
        }
        
        UpdateProfileModel result = await AuthService.updateProfile(profileDataMap);
        
        if (result.status == true) {
          successMessage.value = result.message ?? 'Profile updated successfully';
          // Reload profile data to reflect changes
          await loadProfileData();
          // Clear newly selected images after successful update
          clearNewImages();
          // Show success message
          Get.snackbar(
            'Success',
            successMessage.value,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          // Navigate back to profile screen
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
          });
        } else {
          errorMessage.value = result.message ?? 'Failed to update profile';
          Get.snackbar(
            'Error',
            errorMessage.value,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        errorMessage.value = 'Update failed: $e';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void clearNewImages() {
    profilePhoto.value = null;
    favIcon.value = null;
    logoLight.value = null;
    logoDark.value = null;
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

  bool getImageLoadingState(String imageType) {
    switch (imageType) {
      case 'profile':
        return profilePhotoLoading.value;
      case 'favIcon':
        return favIconLoading.value;
      case 'logoLight':
        return logoLightLoading.value;
      case 'logoDark':
        return logoDarkLoading.value;
      default:
        return false;
    }
  }

  void setImageLoadingState(String imageType, bool loading) {
    switch (imageType) {
      case 'profile':
        profilePhotoLoading.value = loading;
        break;
      case 'favIcon':
        favIconLoading.value = loading;
        break;
      case 'logoLight':
        logoLightLoading.value = loading;
        break;
      case 'logoDark':
        logoDarkLoading.value = loading;
        break;
    }
  }

  String? getExistingImageByType(String imageType) {
    switch (imageType) {
      case 'profile':
        return existingProfilePhoto.value;
      case 'favIcon':
        return existingFavIcon.value;
      case 'logoLight':
        return existingLogoLight.value;
      case 'logoDark':
        return existingLogoDark.value;
      default:
        return null;
    }
  }

  String? getDisplayImageByType(String imageType) {
    // First check if there's a newly selected image
    XFile? newImage = getImageByType(imageType);
    if (newImage != null && newImage.path.isNotEmpty) {
      return newImage.path;
    }
    // Otherwise return existing image URL
    return getExistingImageByType(imageType);
  }

  void handleSubmit() {
    updateProfile();
  }
}
