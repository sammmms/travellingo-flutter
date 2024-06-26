import 'package:travellingo/models/user.dart';

class UserState {
  final User? receivedProfile;
  final bool hasError;
  final bool loading;
  final String? receivedMessage;

  UserState(
      {this.hasError = false,
      this.loading = false,
      this.receivedProfile,
      this.receivedMessage});

  UserState copyWith(
      {User? receivedProfile,
      bool? hasError,
      bool? loading,
      String? receivedMessage}) {
    return UserState(
        receivedProfile: receivedProfile ?? this.receivedProfile,
        hasError: hasError ?? this.hasError,
        loading: loading ?? this.loading,
        receivedMessage: receivedMessage ?? this.receivedMessage);
  }
}
