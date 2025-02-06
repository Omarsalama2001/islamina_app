import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/controllers/quran_reading_controller.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/snack_bar.dart';
import 'package:islamina_app/features/auth/presentation/blocs/cubit/auth_cubit.dart';
import 'package:islamina_app/features/auth/presentation/widgets/google_signin_button.dart';
import 'package:islamina_app/features/on_boarding/presentation/pages/on_boarding_screen.dart';
import 'package:islamina_app/pages/home_page.dart';
import 'package:islamina_app/routes/app_pages.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.sp),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/islamina_logo-removeed.png',
            height: 30.h,
            width: 50.w,
          ),
          Text(
            context.translate('loginPrompt'),
            style: GoogleFonts.rubik().copyWith(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 30.sp),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                SnackBarMessage.showSnackBar(SnackBarTypes.SUCCESS, context.translate('successLoginMessage'), context);
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              } else if (state is AuthError) {
                if (state.message == "No internet connection") {
                  SnackBarMessage.showSnackBar(SnackBarTypes.ERORR, context.translate('noInternetMessage'), context);
                } else {
                  SnackBarMessage.showSnackBar(SnackBarTypes.ERORR, context.translate('errorMessage'), context);
                }
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(
                  child: Lottie.asset(
                    'assets/animations/loading_animation.json',
                  ),
                );
              }

              return Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: GoogleSigninButton(
                      icon: "assets/images/google_icon.png",
                      method: 'Google',
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context).login();
                      }),
                ),
                const Gap(15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: GoogleSigninButton(
                      icon: 'assets/images/twitter.png',
                      method: 'Twitter',
                      onPressed: () {
                        // AuthCubit.removeToken();
                      }),
                ),
                const Gap(15),
                GestureDetector(
                  onTap: () {
                    context.read<AuthCubit>().saveToken(token: 'temp');
                    Get.offAllNamed(Routes.HOME);
                  },
                  child: Text(
                    context.translate('loginLater'),
                    style: GoogleFonts.rubik().copyWith(fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                )
              ]);
            },
          ),
        ],
      ),
    );
  }
}
