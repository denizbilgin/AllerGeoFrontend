import 'package:flutter/material.dart';

class TravelCreationScreen extends StatelessWidget {
  const TravelCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayfa 2'),
      ),
      body: const Center(
        child: Text('Sayfa 2 İçeriği'),
      ),
    );
  }
}
