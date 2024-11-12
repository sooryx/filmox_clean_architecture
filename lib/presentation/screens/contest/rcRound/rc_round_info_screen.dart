import 'package:flutter/material.dart';

class RcRoundInfoScreen extends StatelessWidget {
  const RcRoundInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context)
    );
  }

  AppBar _buildAppBar(context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.surface),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Hero(
          tag: 'round',
          child: Text("Round 3",style: Theme.of(context).textTheme.headlineLarge)),
    );
  }
}
