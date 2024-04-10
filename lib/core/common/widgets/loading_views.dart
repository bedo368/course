import 'package:flutter/material.dart';

class LoadingViews extends StatelessWidget {
  const LoadingViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
