import 'package:travellingo/models/user.dart';
import 'package:travellingo/utils/app_error.dart';

class UserState {
  final User? receivedProfile;
  final bool hasError;
  final bool isLoading;
  final String? receivedMessage;
  final AppError? error;

  UserState(
      {this.hasError = false,
      this.isLoading = false,
      this.receivedProfile,
      this.receivedMessage,
      this.error});

  UserState copyWith(
      {User? receivedProfile,
      bool? hasError,
      bool? loading,
      String? receivedMessage,
      AppError? error}) {
    return UserState(
        receivedProfile: receivedProfile ?? this.receivedProfile,
        hasError: hasError ?? this.hasError,
        isLoading: loading ?? isLoading,
        receivedMessage: receivedMessage ?? this.receivedMessage,
        error: error ?? this.error);
  }

  factory UserState.initial() {
    return UserState();
  }

  factory UserState.hasError({required AppError error}) {
    return UserState(hasError: true, error: error);
  }

  factory UserState.isLoading() {
    return UserState(isLoading: true);
  }

  factory UserState.updateProfile({required User user}) {
    return UserState(receivedProfile: user);
  }
}
