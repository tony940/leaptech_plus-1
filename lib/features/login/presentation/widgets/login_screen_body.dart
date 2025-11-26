import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/my_toast.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/core/widgets/app_button.dart';
import 'package:leaptech_plus/features/login/presentation/cubits/cubit/login_cubit.dart';
import 'package:leaptech_plus/features/login/presentation/widgets/login_animated_logo.dart';
import 'package:leaptech_plus/features/login/presentation/widgets/login_form.dart';
import 'package:lottie/lottie.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    var loginCubit = context.read<LoginCubit>();
    return Container(
      padding: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryColor,
      child: Stack(
        children: [
          /// -------------------------
          ///   LOGO ANIMATION
          /// -------------------------
          LoginAnimatedLogo(),

          /// -------------------------
          ///   FORM ANIMATION
          /// -------------------------
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 250.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: AppTextStyles.font20BlackBold
                      .copyWith(color: Colors.white, fontSize: 30.sp),
                ),
                verticalSpace(10),

                /// login from
                LoginForm(),

                ///

                verticalSpace(10),
                Text(
                  'Forgot Password?',
                  style: AppTextStyles.font14WhiteMedium
                      .copyWith(color: Colors.white, fontSize: 16.sp),
                )
                    .animate()
                    .fade(duration: 700.ms, delay: 300.ms)
                    .slideY(begin: 0.4, end: 0, curve: Curves.easeOutQuad),

                verticalSpace(20),

                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailureState) {
                      // Show error message
                      MyToast.error(context, state.errorMessage);
                    } else if (state is LoginSuccessState) {
                      // Navigate on success
                      context.pushReplacement('/mainScaffold');
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoadingState) {
                      return _loginLoadingButton(loginCubit);
                    }
                    return loginSuccessButton(loginCubit);
                  },
                )
                    .animate()
                    .fade(duration: 700.ms, delay: 450.ms)
                    .slideY(begin: 0.4, end: 0, curve: Curves.easeOutQuad),
              ],
            ),
          )
              .animate()
              .fade(duration: 1200.ms, delay: 500.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
        ],
      ),
    );
  }

  AppButton loginSuccessButton(LoginCubit loginCubit) {
    return AppButton(
      backgroundColor: AppColors.white,
      textColor: AppColors.primaryColor,
      buttonText: 'Login',
      onPressed: () {
        // Validate form before calling login
        if (loginCubit.formKey.currentState!.validate()) {
          // Call Cubit login method
          loginCubit.login();
        }
      },
    );
  }

  AppButton _loginLoadingButton(LoginCubit loginCubit) {
    return AppButton(
      backgroundColor: AppColors.white,
      textColor: AppColors.primaryColor,
      buttonText: 'Login',
      child: LottieBuilder.asset(
        'assets/animations/loading.json',
      ),
      onPressed: () {
        // Validate form before calling login
        if (loginCubit.formKey.currentState!.validate()) {
          // Call Cubit login method
          loginCubit.login();
        }
      },
    );
  }
}
