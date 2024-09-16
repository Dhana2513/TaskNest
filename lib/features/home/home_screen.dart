import 'package:flutter/material.dart';
import 'package:task_nest/core/widgets/main_scaffold.dart';

import '../../core/constants/asset_images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Image(
        image: AssetImages.shared.appLogo,
      ),
    );
  }
}
