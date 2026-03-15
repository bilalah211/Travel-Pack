import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_pack/utils/constants/app_assets.dart';
import 'package:travel_pack/utils/constants/app_sizes.dart';
import 'package:travel_pack/utils/constants/app_textStyle.dart';
import 'package:travel_pack/view/authentication/signup_view.dart';
import 'package:travel_pack/view/your_trip_view.dart';
import 'package:travel_pack/view_models/auth_view_model.dart';
import 'package:travel_pack/widgets/custom_button.dart';

import '../../utils/constants/app_colors.dart';
import '../../widgets/custome_outlinebutton.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isObscureText = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Container(
        width: width,
        decoration: BoxDecoration(gradient: AppColors.blueSkyGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: AppSizes.radiusLarge),
            buildLoginHeader(),

            Padding(
              padding: const EdgeInsets.all(AppSizes.marginLarge + 5),
              child: Column(
                children: [
                  //email textField
                  buildTextFormField(
                    title: 'Email',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: AppSizes.paddingMedium),

                  //password textField
                  buildTextFormField(
                    title: 'Password',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: Icons.visibility_off,
                  ),
                  SizedBox(height: AppSizes.paddingLarge),

                  //forgot password
                  buildForgotPassword(),
                  SizedBox(height: AppSizes.paddingLarge),

                  //login button
                  buildCustomButton(),
                  SizedBox(height: AppSizes.paddingLarge),

                  //Continue with
                  buildContinueWithRow(),
                  SizedBox(height: AppSizes.paddingLarge),

                  //google and apple logo
                  buildOutlineButton(),
                  SizedBox(height: AppSizes.radiusLarge),

                  // Sign Up
                  buildSignup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Signup Button
  Widget buildSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupView()),
            );
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  //apple and google button
  Widget buildOutlineButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Apple Button
        CustomOutlineButton(
          borderRadius: AppSizes.radiusLarge + 5,
          borderColor: Colors.black26,
          title: 'Apple',
          onTap: () {},
          image: AppAssets.apple,
          textColor: Colors.black45,
        ),
        SizedBox(width: AppSizes.radiusSmall),

        //Google Button
        CustomOutlineButton(
          borderRadius: AppSizes.radiusLarge + 5,
          borderColor: Colors.black26,
          title: 'Google',
          textColor: Colors.black45,
          onTap: () {},
          image: AppAssets.google,
        ),
      ],
    );
  }

  Widget buildContinueWithRow() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[600], thickness: 1.1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[600], thickness: 1.1)),
      ],
    );
  }

  Widget buildCustomButton() {
    final _authVM = Provider.of<AuthViewModel>(context);
    return CustomButton(
      backgroundColor: AppColors.primary,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: AppSizes.radiusMedium + 1,
        fontWeight: FontWeight.w600,
      ),
      title: _authVM.isLoading ? 'Logging In...' : 'Login',
      onTap: _authVM.isLoading
          ? null
          : () async {
              SharedPreferences _sp = await SharedPreferences.getInstance();
              await _authVM.logIn(
                _emailController.text.trim(),
                _passwordController.text.trim(),
              );
              _sp.setBool('isLoggedIn', true);
              if (_authVM.errorMessage != null &&
                  _authVM.errorMessage!.isNotEmpty) {
                print('Error found: ${_authVM.errorMessage}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.orange.shade600,

                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.paddingMedium,
                      ),
                    ),
                    content: Row(
                      children: [
                        Icon(Iconsax.warning_2, color: Colors.white),
                        SizedBox(width: AppSizes.paddingSmall),
                        Text(_authVM.errorMessage!),
                      ],
                    ),
                  ),
                );
                return;
              } else if (_authVM.user != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,

                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.paddingMedium,
                      ),
                    ),
                    content: Row(
                      children: [
                        Icon(Iconsax.tick_circle, color: Colors.white),
                        SizedBox(width: AppSizes.paddingSmall),
                        Text('Login Successfully'),
                      ],
                    ),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YourTripView()),
                );
              }
            },
    );
  }

  //forgot password
  Widget buildForgotPassword() {
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  //textFormField
  Widget buildTextFormField({
    required String title,
    required TextEditingController controller,
    IconData? suffixIcon,
    IconData? prefixIcon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall + 5),
        border: BoxBorder.all(color: Colors.black12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall + 5),
            borderSide: BorderSide.none,
          ),
          hintText: title,
          suffixIcon: Icon(suffixIcon),
          prefixIcon: Icon(prefixIcon, color: Colors.black54),
        ),
      ),
    );
  }

  //Login Header
  Widget buildLoginHeader() {
    return Column(
      children: [
        Image.asset(AppAssets.login, height: 200),
        Text(
          'Welcome Back!!',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 25,
            color: Colors.grey[900],
          ),
        ),
        Text(
          'Plan your trips faster with TripPack.',
          style: AppTextStyles.heading4.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
