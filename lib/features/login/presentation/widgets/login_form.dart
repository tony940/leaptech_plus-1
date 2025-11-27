import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/core/widgets/app_text_form_field.dart';
import 'package:leaptech_plus/features/login/presentation/cubits/cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var loginCubit = context.read<LoginCubit>();
    return Form(
      key: loginCubit.formKey,
      child: Column(
        children: [
          AppTextFormField(
            controller: loginCubit.emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }

              // Simple email regex
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }

              return null; // valid
            },
            hintText: 'Email',
          )
              .animate()
              .fade(duration: 600.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuad),

          verticalSpace(10),

          /// Password Field
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return AppTextFormField(
                controller: loginCubit.passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null; // valid
                },
                hintText: 'Password',
                obscureText: loginCubit.isObsecure,
                suffixIcon: IconButton(
                  onPressed: () {
                    loginCubit.toggleObsecureText();
                  },
                  icon: Icon(
                    size: 20.sp,
                    loginCubit.isObsecure
                        ? Icons.visibility_off
                        : Icons.remove_red_eye,
                    color: loginCubit.isObsecure
                        ? Colors.grey
                        : AppColors.primaryColor,
                  ),
                ),
              );
            },
          )
              .animate()
              .fade(duration: 600.ms, delay: 150.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuad),
        ],
      ),
    );
  }
}
