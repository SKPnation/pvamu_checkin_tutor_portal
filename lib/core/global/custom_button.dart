import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? bgColor;
  final Color? textColor;
  final bool? showBorder;
  final double? fontSize;
  final Function()? onPressed;

  const CustomButton(
      {super.key,
        this.text,
        required this.onPressed,
        this.child,
        this.bgColor,
        this.showBorder = false,
        this.textColor, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? AppColors.purple,
        minimumSize: Size(displayWidth(context), 44),
        shadowColor: AppColors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(width: showBorder! ? 1 : 0)),
      ),
      onPressed: onPressed,
      child: child ??
          Text(text!,
              style: TextStyle(
                  fontSize: fontSize,
                  color: textColor ?? AppColors.white)),
    );
  }
}
