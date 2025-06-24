import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/bloc/field/field_state.dart';
import 'package:projectflutter/common/bloc/field/field_state_cubit.dart';
import 'package:projectflutter/common/components/fields/my_text_field.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';
import 'package:projectflutter/data/auth/request/register_request.dart';
import 'package:projectflutter/domain/auth/usecase/signup_usecase.dart';
import 'package:projectflutter/presentation/auth/bloc/gender_selection_cubit.dart';
import 'package:projectflutter/presentation/auth/pages/sent_email.dart';
import 'package:projectflutter/presentation/auth/pages/signin.dart';
import 'package:projectflutter/secure_storage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstnameCon = TextEditingController();
  final TextEditingController _lastnameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _dobCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
      body: GestureDetector(
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
              )
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 300,
                          decoration: BoxDecoration(
                              gradient:
                                  LinearGradient(colors: AppColors.primaryG)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 50, bottom: 30, left: 15, right: 15),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    AppImages.signinLogo,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Please sign up to continue',
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _firstnameField(),
                                const SizedBox(
                                  height: 20,
                                ),
                                _lastnameField(),
                                const SizedBox(
                                  height: 20,
                                ),
                                _emailField(),
                                const SizedBox(
                                  height: 20,
                                ),
                                _passwordField(),
                                const SizedBox(
                                  height: 20,
                                ),
                                _genders(),
                                const SizedBox(
                                  height: 20,
                                ),
                                _dobField(context),
                                const SizedBox(
                                  height: 20,
                                ),
                                _phoneField(),
                                const SizedBox(
                                  height: 20,
                                ),
                                _signupButton(),
                                const SizedBox(
                                  height: 20,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: _alreadyAccount(context),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _firstnameField() {
    return MyTextField(
        controller: _firstnameCon,
        hintText: "First Name",
        obSecureText: false,
        prefixIcon: const IconCustom(icon: Icons.person),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'First name is required';
          }
          return null;
        },
        keyboardType: TextInputType.text);
  }

  Widget _lastnameField() {
    return MyTextField(
        controller: _lastnameCon,
        hintText: "Last Name",
        obSecureText: false,
        prefixIcon: const IconCustom(icon: Icons.account_circle),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Last name is required';
          }
          return null;
        },
        keyboardType: TextInputType.text);
  }

  Widget _dobField(BuildContext context) {
    return MyTextField(
        controller: _dobCon,
        hintText: "Date of Birth",
        onTap: () => _selectDate(context),
        obSecureText: false,
        prefixIcon: const IconCustom(icon: Icons.calendar_today),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'DoB is required';
          }
          return null;
        },
        keyboardType: TextInputType.datetime);
  }

  Widget _phoneField() {
    return MyTextField(
        controller: _phoneCon,
        hintText: "Phone",
        obSecureText: false,
        prefixIcon: const IconCustom(icon: Icons.phone),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Phone is required';
          }
          return null;
        },
        keyboardType: TextInputType.number);
  }

  Widget _emailField() {
    return MyTextField(
        controller: _emailCon,
        hintText: "Email",
        obSecureText: false,
        prefixIcon: const IconCustom(icon: Icons.email),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
            return 'Invalid email format';
          }
          return null;
        },
        keyboardType: TextInputType.text);
  }

  Widget _passwordField() {
    return BlocProvider(
      create: (context) => FieldStateCubit(),
      child: BlocBuilder<FieldStateCubit, FieldState>(
        builder: (context, state) {
          final obSecure = state is HideTextState;
          return MyTextField(
              controller: _passwordCon,
              hintText: 'Password',
              prefixIcon: const IconCustom(icon: Icons.lock),
              suffixIcon: IconButton(
                  onPressed: () {
                    context.read<FieldStateCubit>().toggleVisibility();
                  },
                  icon:
                      Icon(obSecure ? Icons.visibility_off : Icons.visibility)),
              obSecureText: obSecure,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              keyboardType: TextInputType.text);
        },
      ),
    );
  }

  Widget _genders() {
    return BlocBuilder<GenderSelectionCubit, int>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _genderTile(context, 1, 'Male', state),
            const SizedBox(
              width: 20,
            ),
            _genderTile(context, 2, 'Female', state)
          ],
        );
      },
    );
  }

  Widget _genderTile(
      BuildContext context, int genderIndex, String gender, int selectedIndex) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          context.read<GenderSelectionCubit>().selectGender(genderIndex);
        },
        child: Container(
          height: 30,
          decoration: BoxDecoration(
              color: selectedIndex == genderIndex
                  ? AppColors.primaryColor1
                  : AppColors.secondDarkBackground,
              border: Border.all(
                  color:
                      selectedIndex == genderIndex ? Colors.white : Colors.grey,
                  width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                  fontWeight: selectedIndex == genderIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signupButton() {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
            title: "Sign up",
            onPressed: () async {
              setState(() {
                _autovalidateMode = AutovalidateMode.always;
              });
              await secureStorage.writeSecureData('email', _emailCon.text);
              await secureStorage.writeSecureData(
                  'password', _passwordCon.text);
              if (_formKey.currentState!.validate()) {
                final genderIndex = context.read<GenderSelectionCubit>().state;
                context.read<ButtonStateCubit>().execute(
                    usecase: SignupUsecase(),
                    params: RegisterRequest(
                        firstname: _firstnameCon.text,
                        lastname: _lastnameCon.text,
                        email: _emailCon.text,
                        password: _passwordCon.text,
                        dob: DateFormat('yyyy-MM-dd').parse(_dobCon.text),
                        gender: genderIndex,
                        phone: _phoneCon.text));
              }
            });
      },
    );
  }

  Widget _alreadyAccount(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: "Already have an account?",
            style: Theme.of(context).textTheme.labelSmall),
        const WidgetSpan(child: SizedBox(width: 8)),
        TextSpan(
          text: "Sign in",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              AppNavigator.pushReplacement(context, SigninPage());
            },
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}
