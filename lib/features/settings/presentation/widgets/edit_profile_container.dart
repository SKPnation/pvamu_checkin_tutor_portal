import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/form_fields.dart';

class EditProfileContainer extends StatefulWidget {
  const EditProfileContainer({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<EditProfileContainer> createState() => _EditProfileContainerState();
}

class _EditProfileContainerState extends State<EditProfileContainer> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Profile", weight: FontWeight.bold),
                  SizedBox(height: 4),
                  CustomText(
                    text:
                    "Edit your profile information. This information is visible to everyone in this workspace",
                  ),
                ],
              ),),

              SizedBox(
                width: 150,
                child: CustomButton(onPressed: (){

                }, text: "Save changes"),
              )
            ],
          ),

          SizedBox(height: 30),

          Row(children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "First Name"),
                SizedBox(height: 8),
                firstNameField(widget.settingsController, (value){}),

                SizedBox(height: 20),

                CustomText(text: "Email"),
                SizedBox(height: 8),
                lastNameField(widget.settingsController, (value){})
              ],
            )),
            SizedBox(width: 20),

            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Last Name"),
                SizedBox(height: 8),
                emailField(widget.settingsController, (value){}),

                SizedBox(height: 20),

                CustomText(text: "Phone number"),
                SizedBox(height: 8),
                phoneField(widget.settingsController, (value){})
              ],
            ))
          ]),
        ],
      ),
    );
  }
}
