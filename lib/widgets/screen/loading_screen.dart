import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(child: CircularProgressIndicator()),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
