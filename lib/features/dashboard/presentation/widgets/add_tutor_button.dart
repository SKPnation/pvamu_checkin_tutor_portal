import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_form_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class AddTutorButton extends StatelessWidget {
  const AddTutorButton({super.key, required this.tutorsController, this.from});

  final TutorsController tutorsController;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Get.dialog(
          StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: AppColors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add a tutor"),

                    IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.close), tooltip: "return to $from page",)
                  ],
                ),
                content: Column(
                  children: [
                    CustomFormField(
                      hint: "First name",
                      textEditingController: tutorsController.fNameTEC,
                    ),
                    CustomFormField(
                      hint: "Last name",
                      textEditingController: tutorsController.lNameTEC,
                    ),
                    CustomFormField(
                      hint: "Email address",
                      textInputType: TextInputType.emailAddress,
                      textEditingController: tutorsController.emailAddressTEC,
                    ),

                    CustomButton(
                      onPressed: () async {
                        await tutorsController.addTutor();
                      },
                      text: "Add tutor",
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      child: Row(
        children: [
          Icon(Icons.add, color: AppColors.white),
          SizedBox(width: 8),
          CustomText(
            text: "Add Tutor",
            weight: FontWeight.w600,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
