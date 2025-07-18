import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/auth/bloc/gender_selection_cubit.dart';
import 'package:projectflutter/presentation/auth/pages/sent_email.dart';
import 'package:projectflutter/presentation/auth/pages/signin.dart';
import 'package:projectflutter/presentation/auth/widgets/dob_field.dart';
import 'package:projectflutter/presentation/auth/widgets/email_field.dart';
import 'package:projectflutter/presentation/auth/widgets/gender_item.dart';
import 'package:projectflutter/presentation/auth/widgets/password_field.dart';
import 'package:projectflutter/presentation/auth/widgets/signup_button.dart';
import 'package:projectflutter/presentation/auth/widgets/switch_page_button.dart';
import 'package:projectflutter/presentation/auth/widgets/text_field_custom.dart';
import 'package:projectflutter/secure_storage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameCon = TextEditingController();
  final TextEditingController _firstnameCon = TextEditingController();
  final TextEditingController _lastnameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _dobCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _addressCon = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _dobCon.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameCon.dispose();
    _firstnameCon.dispose();
    _lastnameCon.dispose();
    _emailCon.dispose();
    _passwordCon.dispose();
    _dobCon.dispose();
    _phoneCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundAuth,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => GenderSelectionCubit(),
              ),
              BlocProvider(
                create: (context) => ButtonStateCubit(),
              ),
            ],
            child: BlocListener<ButtonStateCubit, ButtonState>(
              listener: (context, state) {
                if (state is ButtonFailureState) {
                  var snackbar = SnackBar(
                    content: Text(state.errorMessage),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
                if (state is ButtonSuccessState) {
                  const snackbar = SnackBar(
                    content: Text("Sign up Successfully"),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  AppNavigator.pushAndRemoveUntil(
                      context, const SentEmailPage());
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: SwitchImageType.buildImage(
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
                                            'Create Account',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  AppFontSize.heading1(context),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Join FitMate and start your fitness',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  AppFontSize.body(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    TextFieldCustom(
                                      controller: _usernameCon,
                                      hintText: 'Username',
                                      icon: Icons.account_box,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Username is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldCustom(
                                      controller: _firstnameCon,
                                      hintText: 'First Name',
                                      icon: Icons.person,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'First name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldCustom(
                                      controller: _lastnameCon,
                                      hintText: 'Last Name',
                                      icon: Icons.person,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Last name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    EmailField(controller: _emailCon),
                                    const SizedBox(height: 20),
                                    PasswordField(controller: _passwordCon),
                                    const SizedBox(height: 20),
                                    _genders(),
                                    const SizedBox(height: 20),
                                    DobField(
                                      controller: _dobCon,
                                      onTap: () {
                                        _selectDate(context);
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldCustom(
                                      controller: _addressCon,
                                      hintText: "Address",
                                      icon: Icons.location_city,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Address is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldCustom(
                                      controller: _phoneCon,
                                      hintText: "Phone",
                                      inputType: TextInputType.number,
                                      icon: Icons.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Phone is required';
                                        } else if (value.length < 10 ||
                                            value.length > 15) {
                                          return 'Phone number must be valid and contain 10 to 15 digits!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    SignupButton(
                                      formKey: _formKey,
                                      usernameController: _usernameCon,
                                      firstnameController: _firstnameCon,
                                      lastnameController: _lastnameCon,
                                      emailController: _emailCon,
                                      passwordController: _passwordCon,
                                      dobController: _dobCon,
                                      phoneController: _phoneCon,
                                      addressController: _addressCon,
                                      secureStorage: secureStorage,
                                    ),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SwitchPageButton(
                                        questionText:
                                            "Already have an account?",
                                        buttonText: "Sign in",
                                        onTap: () {
                                          AppNavigator.pushReplacement(
                                              context, const SigninPage());
                                        },
                                      ),
                                    )
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

  Widget _genders() {
    return BlocBuilder<GenderSelectionCubit, int>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GenderItem(
              genderIndex: 1,
              label: 'Male',
              selectedIndex: state,
            ),
            const SizedBox(width: 20),
            GenderItem(
              genderIndex: 2,
              label: 'Female',
              selectedIndex: state,
            ),
          ],
        );
      },
    );
  }
}
