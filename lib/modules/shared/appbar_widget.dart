import 'package:fluffy/modules/shared/app_theme/app_colors.dart';
import 'package:fluffy/modules/shared/constant.dart';
import 'package:fluffy/modules/shared/text_widget.dart';
import 'package:flutter/material.dart';

AppBar appBarWithBackButton(BuildContext context, String label) {
  Icon actionIcon = Icon(Icons.search, color: AppColors.primary);
  return AppBar(
    title: TextWidget(
      text: label,
      fontWeight: FontWeight.w500,
      fontSize: textSizeNormal,
      color: AppColors.whiteColor,
    ),
    backgroundColor: AppColors.primary,
    elevation: 1,
    leading: IconButton(
      onPressed:
          () => {
            if (Navigator.canPop(context))
              {Navigator.pop(context)}
            else
              {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                ), // fallback route
              },
          },
      icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
    ),
    actions: [IconButton(onPressed: () {}, icon: actionIcon)],
  );
}
