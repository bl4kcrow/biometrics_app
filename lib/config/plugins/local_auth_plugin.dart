import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class Localauthplugin {
  static final LocalAuthentication auth = LocalAuthentication();

  static availableBiometrics() async {
    final List<BiometricType> availableBiometrics = await auth
        .getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
    }

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!
    }
  }

  static Future<bool> canCheckBiometrics() async {
    return await auth.canCheckBiometrics;
  }

  static Future<(bool, String)> authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(),
      );

      return (
        didAuthenticate,
        didAuthenticate
            ? 'Authentication successful'
            : 'Authentication canceled by user',
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        return (false, 'Biometric authentication is not available.');
      } else if (e.code == auth_error.notEnrolled) {
        return (false, 'No biometrics are enrolled on this device.');
      } else if (e.code == auth_error.lockedOut) {
        return (false, 'Many failed attempts');
      } else if (e.code == auth_error.passcodeNotSet) {
        return (false, 'Passcode is not set on the device.');
      } else if (e.code == auth_error.permanentlyLockedOut) {
        return (false, 'It is required to unlock the device manually.');
      } else {
        return (false, 'An unknown error occurred: ${e.message}');
      }
    }
  }
}
