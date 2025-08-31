import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_form_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/change_pwd_button.dart';

class ChangePwdContainer extends StatefulWidget {
  const ChangePwdContainer({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<ChangePwdContainer> createState() => _ChangePwdContainerState();
}

class _ChangePwdContainerState extends State<ChangePwdContainer> {
  bool sent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1,
          color: AppColors.grey[300]!.withOpacity(.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "Password", weight: FontWeight.bold),
          CustomText(text: "Reset your password here"),
          SizedBox(height: 24),
          ChangePwdButton(
            settingsController: widget.settingsController,
            onPressed: () async {
              sent = await widget.settingsController.resetPwd();
              setState(() {});
            },
          ),

          SizedBox(height: 8),
          if (sent)
            CustomText(text: "Check your email inbox, spam, or junk mail", color: AppColors.purple,),
        ],
      ),
    );
  }
}
