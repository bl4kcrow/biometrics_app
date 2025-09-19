import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biometrics_app/config/plugins/local_auth_plugin.dart';

final canCheckBiometricsProvider = FutureProvider<bool>((ref) async {
  return await Localauthplugin.canCheckBiometrics();
});

enum LocalAuthStatus { authenticated, notAuthenticated, authenticating }

class LocalAuthState {
  LocalAuthState({
    this.didAuthenticate = false,
    this.status = LocalAuthStatus.notAuthenticated,
    this.message = '',
  });

  final bool didAuthenticate;
  final LocalAuthStatus status;
  final String message;

  LocalAuthState copyWith({
    bool? didAuthenticate,
    LocalAuthStatus? status,
    String? message,
  }) {
    return LocalAuthState(
      didAuthenticate: didAuthenticate ?? this.didAuthenticate,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 
    '''
    didAuthenticate: $didAuthenticate
    status: $status
    message: $message
    ''';
  }
}

class LocalAuthNotifier extends Notifier<LocalAuthState> {
  @override
  build() {
    return LocalAuthState();
  }

  Future<(bool, String)> authenticateUser() async {
    state = state.copyWith(status: LocalAuthStatus.authenticating);

    final (didAuthenticate, message) = await Localauthplugin.authenticate();
    state = state.copyWith(
      didAuthenticate: didAuthenticate,
      status: didAuthenticate
          ? LocalAuthStatus.authenticated
          : LocalAuthStatus.notAuthenticated,
      message: message,
    );

    return (didAuthenticate, message);
  }
}

final localAuthProvider = NotifierProvider<LocalAuthNotifier, LocalAuthState>(
  LocalAuthNotifier.new,
);
