import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:biometrics_app/presentation/providers/local_auth_providers.dart';

class BiometricScreen extends ConsumerWidget {
  const BiometricScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canCheckBiometrics = ref.watch(canCheckBiometricsProvider);
    final localAuthState = ref.watch(localAuthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
              onPressed: () {
                ref.read(localAuthProvider.notifier).authenticateUser();
              },
              child: const Text('Authenticate'),
            ),

            canCheckBiometrics.when(
              data: (canCheck) => Text('Can check biometrics: $canCheck'),
              error: (error, _) => Text('Error: $error'),
              loading: () => Center(child: const CircularProgressIndicator()),
            ),

            const Text('Biometric state', style: TextStyle(fontSize: 30.0)),
            Text('$localAuthState', style: TextStyle(fontSize: 20.0)),
          ],
        ),
      ),
    );
  }
}
