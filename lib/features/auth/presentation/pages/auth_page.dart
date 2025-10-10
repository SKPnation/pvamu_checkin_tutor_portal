import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/image_elements.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/presentation/controllers/auth_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/presentation/widgets/form_fields.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/repos/user_data_store.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/pages/site_layout.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final authController = Get.put(AuthController());
  final menuController = MenController.instance;

  var emailErrorText = "";

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

              const SizedBox(height: 15),

              CustomText(
                text: AppStrings.slogan,
                color: AppColors.grey[300],
                size: 22,
                fontStyle: FontStyle.italic,
                weight: FontWeight.bold,
              ),

              const SizedBox(height: 20),

              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [
                        AppColors.gold, // Gold
                        AppColors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                child: CustomText(
                  text: AppStrings.appTitle,
                  color: Colors.white,
                  // Important: must be set, even if overridden
                  size: 28,
                  weight: FontWeight.w600,
                ),
              ),

              // CustomText(
              //   text: AppStrings.appTitle,
              //   size: 28,
              //   weight: FontWeight.bold,
              // ),
              const SizedBox(height: 60),

              // Text(
              //   AppStrings.loginTitle,
              //   style: GoogleFonts.roboto(fontSize: 24),
              // ),

              // Text(AppStrings.loginTitle, style: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w700)),

              // const SizedBox(height: 15),
              //
              // CustomText(
              //   text: AppStrings.welcomeBackMsg,
              //   color: AppColors.grey[300],
              //   size: 18,
              //   weight: FontWeight.normal,
              // ),
              // const SizedBox(height: 30),

              emailFormField(
                onChanged: (value) {
                  if (!authController.isPvamuEmail(value)) {
                    emailErrorText = AppStrings.mustBePvamuEmail;
                  } else {
                    emailErrorText = "";
                  }

                  setState(() {});
                },
              ),
              if (emailErrorText.isNotEmpty)
                Text(emailErrorText, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 15),

              passwordField(),

              const SizedBox(height: 15),
              InkWell(
                onTap: () async {
                  var success = await authController.login();

                  if (success) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SiteLayout()),
                          (Route<dynamic> route) => false, // remove all previous routes
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                          2.0,
                          2.0,
                        ), // shadow direction: bottom right
                      ),
                    ],
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
