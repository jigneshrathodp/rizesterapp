import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../App_model/profile_model/LoginModel.dart';
import '../App_model/profile_model/GetProfileModel.dart';
import '../App_model/profile_model/UpdateProfileModel.dart';
import '../App_model/profile_model/ResetPasswordModel.dart';
import '../App_model/profile_model/LogoutModel.dart';

// Login Future Builder Widget
class LoginFutureBuilder extends StatelessWidget {
  final String email;
  final String password;
  final Widget Function(LoginModel) onSuccess;
  final Widget Function(String) onError;
  final Widget Function() onLoading;

  const LoginFutureBuilder({
    Key? key,
    required this.email,
    required this.password,
    required this.onSuccess,
    required this.onError,
    required this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginModel>(
      future: AuthService.login(email, password),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return onLoading();
        } else if (snapshot.hasError) {
          return onError(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return onSuccess(snapshot.data!);
        } else {
          return onError('Unknown error occurred');
        }
      },
    );
  }
}

// Profile Details Future Builder Widget
class ProfileDetailsFutureBuilder extends StatelessWidget {
  final Widget Function(GetProfileModel) onSuccess;
  final Widget Function(String) onError;
  final Widget Function() onLoading;

  const ProfileDetailsFutureBuilder({
    Key? key,
    required this.onSuccess,
    required this.onError,
    required this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetProfileModel>(
      future: AuthService.getProfileDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return onLoading();
        } else if (snapshot.hasError) {
          return onError(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return onSuccess(snapshot.data!);
        } else {
          return onError('Unknown error occurred');
        }
      },
    );
  }
}

// Update Profile Future Builder Widget
class UpdateProfileFutureBuilder extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final Widget Function(UpdateProfileModel) onSuccess;
  final Widget Function(String) onError;
  final Widget Function() onLoading;

  const UpdateProfileFutureBuilder({
    Key? key,
    required this.profileData,
    required this.onSuccess,
    required this.onError,
    required this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UpdateProfileModel>(
      future: AuthService.updateProfile(profileData),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return onLoading();
        } else if (snapshot.hasError) {
          return onError(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return onSuccess(snapshot.data!);
        } else {
          return onError('Unknown error occurred');
        }
      },
    );
  }
}

// Reset Password Future Builder Widget
class ResetPasswordFutureBuilder extends StatelessWidget {
  final String currentPassword;
  final String newPassword;
  final Widget Function(ResetPasswordModel) onSuccess;
  final Widget Function(String) onError;
  final Widget Function() onLoading;

  const ResetPasswordFutureBuilder({
    Key? key,
    required this.currentPassword,
    required this.newPassword,
    required this.onSuccess,
    required this.onError,
    required this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResetPasswordModel>(
      future: AuthService.resetPassword(currentPassword, newPassword),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return onLoading();
        } else if (snapshot.hasError) {
          return onError(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return onSuccess(snapshot.data!);
        } else {
          return onError('Unknown error occurred');
        }
      },
    );
  }
}

// Logout Future Builder Widget
class LogoutFutureBuilder extends StatelessWidget {
  final Widget Function(LogoutModel) onSuccess;
  final Widget Function(String) onError;
  final Widget Function() onLoading;

  const LogoutFutureBuilder({
    Key? key,
    required this.onSuccess,
    required this.onError,
    required this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LogoutModel>(
      future: AuthService.logout(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return onLoading();
        } else if (snapshot.hasError) {
          return onError(snapshot.error.toString());
        } else if (snapshot.hasData) {
          return onSuccess(snapshot.data!);
        } else {
          return onError('Unknown error occurred');
        }
      },
    );
  }
}
