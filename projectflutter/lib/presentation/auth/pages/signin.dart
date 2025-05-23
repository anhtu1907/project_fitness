import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/bloc/field/field_state.dart';
import 'package:projectflutter/common/bloc/field/field_state_cubit.dart';
import 'package:projectflutter/common/components/fields/my_text_field.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';
import 'package:projectflutter/data/auth/request/signin_request.dart';
import 'package:projectflutter/domain/auth/usecase/signin_usecase.dart';
import 'package:projectflutter/presentation/auth/pages/forget_password.dart';
import 'package:projectflutter/presentation/auth/pages/signup.dart';
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
    print("Saved email: $savedEmail");
    print("Saved password: $savedPassword");
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
      appBar: const BasicAppBar(hideBack: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) async {
              if (state is ButtonFailureState) {
                final snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              if (state is ButtonSuccessState) {
                await secureStorage.writeSecureData('email', _emailCon.text);
                await secureStorage.writeSecureData(
                    'password', _passwordCon.text);

                const snackbar = SnackBar(
                  content: Text("Login Successfully"),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                AppNavigator.pushReplacement(context, const WelcomePage());
              }
            },
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateMode,
                    child: Column(
                      children: [
                        Text(
                          'Hey there,',
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppColors.black
                                  : AppColors.white,
                              fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppColors.black
                                  : AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        const SizedBox(height: 20),
                        _emailField(),
                        const SizedBox(height: 20),
                        _passwordField(),
                        const SizedBox(height: 20),
                        Align(
                            alignment: Alignment.centerRight,
                            child: _forgetPassword(context)),
                        const SizedBox(height: 20),
                        _signinButton(),
                        const SizedBox(height: 20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: _createAccount(context)),
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

  Widget _emailField() {
    return MyTextField(
      controller: _emailCon,
      hintText: "Email",
      obSecureText: false,
      keyboardType: TextInputType.text,
      prefixIcon: const IconCustom(icon: Icons.email),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required';
        return null;
      },
    );
  }

  Widget _passwordField() {
    return BlocProvider(
      create: (context) => FieldStateCubit(),
      child: BlocBuilder<FieldStateCubit, FieldState>(
        builder: (context, state) {
          bool obSecureText = state is HideTextState;
          return MyTextField(
            controller: _passwordCon,
            hintText: "Password",
            obSecureText: obSecureText,
            keyboardType: TextInputType.text,
            prefixIcon: const IconCustom(icon: Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                context.read<FieldStateCubit>().toggleVisibility();
              },
              icon: Icon(
                obSecureText ? Icons.visibility_off : Icons.visibility,
                size: 25,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Password is required';
              return null;
            },
          );
        },
      ),
    );
  }

  Widget _signinButton() {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          title: "Sign in",
          onPressed: () {
            setState(() {
              _autovalidateMode = AutovalidateMode.always;
            });
            if (_formKey.currentState!.validate()) {
              context.read<ButtonStateCubit>().execute(
                    usecase: SigninUseCase(),
                    params: SigninRequest(
                        email: _emailCon.text, password: _passwordCon.text),
                  );
            }
          },
        );
      },
    );
  }

  Widget _forgetPassword(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Forgot Password?",
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            AppNavigator.push(context, ForgetPasswordPage());
          },
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _createAccount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: "Do you have an account?",
              style: Theme.of(context).textTheme.labelSmall),
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(
            text: "Register",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.pushReplacement(context, const SignupPage());
              },
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
