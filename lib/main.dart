import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

void main() {
  runApp(const MyApp());
}

final LocalAuthentication auth = LocalAuthentication();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool didAuthenticate = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text("Did Authenticated : $didAuthenticate"),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  try {
                    didAuthenticate = await auth.authenticate(
                      localizedReason: 'Please authenticate',
                      options: const AuthenticationOptions(
                        useErrorDialogs: false,
                        biometricOnly: true,
                      ),
                    );
                  } on PlatformException catch (e) {
                    if (e.code == auth_error.notEnrolled) {
                      print("device not suppoprted");
                    } else if (e.code == auth_error.lockedOut ||
                        e.code == auth_error.permanentlyLockedOut) {}
                  }

                  setState(() {});
                },
                child: Text(Platform.isIOS == true
                    ? "Authenticate with FaceID"
                    : "Authenticate"),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
