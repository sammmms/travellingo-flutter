import 'package:travellingo/models/user.dart';

class UserState {
  final User? receivedProfile;
  final bool error;
  final bool loading;
  final String? receivedMessage;

  UserState(
      {this.error = false,
      this.loading = false,
      this.receivedProfile,
      this.receivedMessage});
}
