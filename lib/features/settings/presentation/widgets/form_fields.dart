import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_form_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/validators.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';

CustomFormField firstNameField(
  SettingsController settingsController,
  void Function(String)? onChanged,
) {
  return CustomFormField(
    textEditingController: settingsController.firstNameTEC,
    verticalPadding: 12,
    onChanged: onChanged,
    validator: (val) {
      if (val!.isEmpty) {
        return 'Please input your first name';
      }

      return null;
    },
    inputBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.grey[300]!.withOpacity(.3)),
    ),
  );
}

CustomFormField lastNameField(
  SettingsController settingsController,
  void Function(String)? onChanged,
) {
  return CustomFormField(
    textEditingController: settingsController.lastNameTEC,
    verticalPadding: 12,
    onChanged: onChanged,
    validator: (val) {
      if (val!.isEmpty) {
        return 'Please input your last name';
      }

      return null;
    },
    inputBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.grey[300]!.withOpacity(.3)),
    ),
  );
}

CustomFormField emailField(
  SettingsController settingsController,
  void Function(String)? onChanged,
) {
  return CustomFormField(
    textEditingController: settingsController.emailAddressTEC,
    verticalPadding: 12,
    textInputType: TextInputType.emailAddress,
    onChanged: onChanged,
    validator: (val) {
      if (val!.isEmpty) {
        return 'Please input your email';
      }
      if (!Validator.isEmail(val)) {
        return 'Please input a valid email address';
      }
      return null;
    },
    inputBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.grey[300]!.withOpacity(.3)),
    ),
  );
}

CustomFormField phoneField(
    SettingsController settingsController,
    void Function(String)? onChanged,
    ) {
  return CustomFormField(
    textEditingController: settingsController.phoneTEC,
    verticalPadding: 12,
    textInputType: TextInputType.number,
    onChanged: onChanged,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
    ],
    validator: (val) {
      if (val!.isEmpty) {
        return 'Please input your phone number';
      }
      return null;
    },

    inputBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.grey[300]!.withOpacity(.3)),
    ),
  );
}
