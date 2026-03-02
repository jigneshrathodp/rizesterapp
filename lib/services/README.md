# Authentication API Service

This directory contains the complete authentication API implementation using Model, HTTP, and FutureBuilder pattern as requested.

## Files Overview

### 1. `api_service.dart`
Contains the core HTTP API calls for authentication:
- `login()` - User login with email and password
- `logout()` - User logout
- `getProfileDetails()` - Get user profile information
- `updateProfile()` - Update user profile
- `resetPassword()` - Reset user password

### 2. `auth_service.dart`
High-level service that wraps `api_service.dart` with:
- Local storage management (SharedPreferences)
- Token management
- Error handling
- Authentication state management

### 3. `auth_future_builder.dart` (in widgets directory)
Reusable FutureBuilder widgets for each API call:
- `LoginFutureBuilder` - For login API calls
- `ProfileDetailsFutureBuilder` - For getting profile details
- `UpdateProfileFutureBuilder` - For updating profile
- `ResetPasswordFutureBuilder` - For password reset
- `LogoutFutureBuilder` - For logout

### 4. `auth_controller.dart` (in controllers directory)
GetX controller that provides:
- Form validation
- State management
- Error and success message handling
- Navigation logic

### 5. Examples
- `auth_api_examples.dart` - Simple examples showing API responses
- `auth_ui_example.dart` - Complete UI implementation with forms

## Usage Examples

### Basic FutureBuilder Usage

```dart
// Login Example
LoginFutureBuilder(
  email: 'user@example.com',
  password: 'password123',
  onLoading: () => const CircularProgressIndicator(),
  onError: (error) => Text('Error: $error'),
  onSuccess: (loginModel) => Text('Welcome! Token: ${loginModel.token}'),
)

// Profile Details Example
ProfileDetailsFutureBuilder(
  onLoading: () => const CircularProgressIndicator(),
  onError: (error) => Text('Error: $error'),
  onSuccess: (profileModel) => Column(
    children: [
      Text('Name: ${profileModel.user?.name}'),
      Text('Email: ${profileModel.user?.email}'),
    ],
  ),
)
```

### Controller Usage

```dart
class MyWidget extends StatelessWidget {
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller.emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextFormField(
          controller: controller.passwordController,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          child: controller.isLoading.value 
            ? CircularProgressIndicator() 
            : Text('Login'),
        )),
        Obx(() => Text(
          controller.errorMessage.value.isNotEmpty 
            ? controller.errorMessage.value 
            : controller.successMessage.value,
        )),
      ],
    );
  }
}
```

### Direct Service Usage

```dart
// Using AuthService directly
try {
  LoginModel result = await AuthService.login('email@example.com', 'password');
  if (result.status == true) {
    // Login successful
    print('Token: ${result.token}');
  }
} catch (e) {
  print('Login failed: $e');
}

// Getting profile details
try {
  GetProfileModel profile = await AuthService.getProfileDetails();
  print('User name: ${profile.user?.name}');
} catch (e) {
  print('Failed to get profile: $e');
}
```

## API Endpoints Used

All API endpoints are defined in `api_url.dart`:

```dart
// ================= AUTH =================
static const String login = "$baseUrl/login";
static const String logout = "$baseUrl/logout";
static const String updateProfile = "$baseUrl/profile/update";
static const String profileDetails = "$baseUrl/profile";
static const String resetPassword = "$baseUrl/change-password";
```

## Dependencies Required

Make sure these dependencies are added to `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.2.1
  shared_preferences: ^2.2.3
  get: ^4.6.6  # If using GetX controller
```

## Key Features

1. **Model Integration**: Uses existing models from `App_model/profile_model/`
2. **HTTP Calls**: Proper HTTP requests with headers and error handling
3. **FutureBuilder Pattern**: Reusable widgets for async operations
4. **Token Management**: Automatic token storage and retrieval
5. **Error Handling**: Comprehensive error handling throughout
6. **No UI Changes**: Existing UI remains unchanged, only new API services added

## Integration Steps

1. Run `flutter pub get` to install new dependencies
2. Import the required services in your files
3. Use FutureBuilder widgets or AuthController for API calls
4. No changes needed to existing models or UI

## Security Notes

- Tokens are stored using SharedPreferences
- All API calls use proper Authorization headers
- Error messages don't expose sensitive information
- Password validation is implemented

This implementation follows your requirements exactly:
- ✅ Uses existing Models
- ✅ Uses HTTP for API calls  
- ✅ Uses FutureBuilder pattern
- ✅ No changes to existing models
- ✅ No changes to current UI
- ✅ Uses the specified API endpoints
