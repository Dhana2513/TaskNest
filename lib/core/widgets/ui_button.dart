import 'package:flutter/material.dart';
import 'package:task_nest/core/extensions/box_padding.dart';

import '../constants/text_style.dart';

class UIButton extends StatelessWidget {
  const UIButton({super.key, required this.onPressed, required this.title});

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BoxPadding.medium),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: UITextStyle.subtitle1.copyWith(color: Colors.white),
      ),
    );
  }
}
