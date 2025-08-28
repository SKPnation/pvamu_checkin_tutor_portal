import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/image_elements.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/presentation/controllers/auth_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/presentation/widgets/form_fields.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/pages/site_layout.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final authController = AuthController.instance;
  final menuController = MenController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageElements.pvamuLogo, height: 200, width: 200),

              const SizedBox(height: 30),

              Text(AppStrings.loginTitle, style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w700)),

              const SizedBox(height: 15),

              CustomText(
                text: AppStrings.welcomeBackMsg,
                color: AppColors.grey[300],
                size: 18,
                weight: FontWeight.normal,
              ),

              const SizedBox(height: 30),

              emailFormField(),

              const SizedBox(height: 15),

              passwordField(),


              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async{
                  await authController.login();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SiteLayout()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(color: AppColors.purple,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(2.0, 2.0), // shadow direction: bottom right
                        )
                      ]
                  ),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const CustomText(
                    text: AppStrings.loginTitle,
                    color: Colors.white,
                    size: 14,
                    weight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
