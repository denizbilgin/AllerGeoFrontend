import 'package:flutter/material.dart';

class TravelScreen extends StatelessWidget {
  const TravelScreen({super.key});

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
