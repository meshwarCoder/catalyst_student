import 'package:catalyst/core/utils/assets.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/utils/vlidation.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/features/auth/presentation/cubit/login%20cubit/login_cubit.dart';
import 'package:catalyst/features/auth/presentation/widgets/auth_background.dart';
import 'package:catalyst/features/auth/presentation/widgets/custom_button.dart';
import 'package:catalyst/features/auth/presentation/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: BlocConsumer<LoginCubit, LoginCubitState>(
        listener: (context, state) {
          if (state is LoginCubitError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is LoginCubitSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            GoRouter.of(context).go(Routs.root);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Opacity(
                opacity: state is LoginCubitLoading ? 0.5 : 1,
                child: AuthBackground(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SvgPicture.asset(Assets.catalyst, fit: BoxFit.cover),
                      const SizedBox(height: 60),
                      CustomTextformfield(
                        controller: context.read<LoginCubit>().emailController,
                        label: 'Email',
                        icon: CupertinoIcons.mail,
                        validator: Validation.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      CustomTextformfield(
                        controller: context
                            .read<LoginCubit>()
                            .passwordController,
                        label: 'Password',
                        icon: CupertinoIcons.lock,
                        validator: Validation.validatePassword,
                        isPassword: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            GoRouter.of(context).push(Routs.forgetPassword);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Color(0xffFC5185)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 55),
                      CustomButton(
                        text: 'Login',
                        onPressed: () {
                          context.read<LoginCubit>().login();
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).push(Routs.register);
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Color(0xffFC5185)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (state is LoginCubitLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}
