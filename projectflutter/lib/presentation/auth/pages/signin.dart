import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/data/auth/request/signin_request.dart';
import 'package:projectflutter/domain/auth/usecase/signin_usecase.dart';
import 'package:projectflutter/presentation/auth/pages/forget_password.dart';
import 'package:projectflutter/presentation/auth/pages/signup.dart';
import 'package:projectflutter/presentation/auth/widgets/email_field.dart';
import 'package:projectflutter/presentation/auth/widgets/forgot_password.dart';
import 'package:projectflutter/presentation/auth/widgets/password_field.dart';
import 'package:projectflutter/presentation/auth/widgets/show_alert_custom.dart';
import 'package:projectflutter/presentation/auth/widgets/singin_button.dart';
import 'package:projectflutter/presentation/auth/widgets/switch_page_button.dart';
import 'package:projectflutter/presentation/splash/pages/welcome.dart';
import 'package:projectflutter/secure_storage.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  final SecureStorage secureStorage = SecureStorage();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    String? savedEmail = await secureStorage.readSecureData('email');
    String? savedPassword = await secureStorage.readSecureData('password');
    if (savedEmail != null) {
      _emailCon.text = savedEmail;
    }
    if (savedPassword != null) {
      _passwordCon.text = savedPassword;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _emailCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundAuth,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BlocProvider(
            create: (context) => ButtonStateCubit(),
            child: BlocListener<ButtonStateCubit, ButtonState>(
              listener: (context, state) async {
                if (state is ButtonFailureState) {
                  showDialog(
                    context: context,
                    builder: (context) => ShowAlertCustom(
                      status: state.errorMessage,
                      content: 'Login Failed',
                      color: Colors.red,
                      icon: Icons.close,
                    ),
                  );
                }
                if (state is ButtonSuccessState) {
                  await secureStorage.writeSecureData('email', _emailCon.text);
                  await secureStorage.writeSecureData('password', _passwordCon.text);

                  showDialog(
                    context: context,
                    builder: (context) => const ShowAlertCustom(
                      status: 'Successful',
                      content: 'Login Successfully',
                      color: Colors.green,
                      icon: Icons.check,
                    ),
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  AppNavigator.pushReplacement(context, const WelcomePage());
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: Image.asset(
                            AppImages.signinLogo,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 30),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKey,
                                autovalidateMode: _autovalidateMode,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Welcome Back!',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: AppFontSize.heading1(context),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Log in to continue your FitMate',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: AppFontSize.body(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    EmailField(controller: _emailCon),
                                    const SizedBox(height: 20),
                                    PasswordField(controller: _passwordCon),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ForgotPassword(
                                        onTap: () {
                                          AppNavigator.push(context, ForgetPasswordPage());
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SinginButton(
                                      formKey: _formKey,
                                      emailController: _emailCon,
                                      passwordController: _passwordCon,
                                    ),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SwitchPageButton(
                                        questionText: "Do you have an account?",
                                        buttonText: "Sign up",
                                        onTap: () {
                                          AppNavigator.pushReplacement(context, const SignupPage());
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
