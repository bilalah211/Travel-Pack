import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:travel_pack/utils/constants/app_assets.dart';
import 'package:travel_pack/utils/constants/app_sizes.dart';
import 'package:travel_pack/view/authentication/login_view.dart';
import 'package:travel_pack/view_models/auth_view_model.dart';
import 'package:travel_pack/widgets/custom_button.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_textStyle.dart';
import '../../widgets/custome_outlinebutton.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ConfirmPasswordController = TextEditingController();
  bool isObscureText = false;

  @override
  Widget build(BuildContext context) {
    final _authVM = Provider.of<AuthViewModel>(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: width,
          decoration: BoxDecoration(gradient: AppColors.blueSkyGradient),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Signup Header
                _buildSignupHeader(),
                SizedBox(height: AppSizes.paddingLarge),
                //Full name
                _buildTextFormField(
                  title: 'Full Name',
                  controller: _fullNameController,
                  prefixIcon: Icons.person_2_outlined,
                ),
                SizedBox(height: AppSizes.paddingMedium),
                //Email
                _buildTextFormField(
                  title: 'Email',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: AppSizes.paddingMedium),
                //Password
                _buildTextFormField(
                  title: 'Password',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: Icons.visibility_off,
                ),
                SizedBox(height: AppSizes.paddingMedium),
                //Confirm Password
                _buildTextFormField(
                  title: 'Confirm Password',
                  controller: _ConfirmPasswordController,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: Icons.visibility_off,
                ),

                SizedBox(height: AppSizes.paddingMedium),

                _buildSignupLowerPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Signup Lower Part
  Widget _buildSignupLowerPart() {
    final _authVM = Provider.of<AuthViewModel>(context);

    return Column(
      children: [
        SizedBox(height: AppSizes.paddingMedium + 5),

        CustomButton(
          backgroundColor: AppColors.primary,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: AppSizes.radiusMedium + 1,
            fontWeight: FontWeight.w600,
          ),
          title: _authVM.isLoading ? 'Signing up...' : 'Create Account',
          onTap: _authVM.isLoading
              ? null
              : () async {
                  await _authVM.signUp(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    displayName: _fullNameController.text.trim(),
                    photoUrl: '',
                    createdAt: DateTime.now().toIso8601String(),
                    confirmPassword: _ConfirmPasswordController.text.trim(),
                  );
                  if (_authVM.errorMessage != null) {
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
                            Text(_authVM.errorMessage.toString()),
                          ],
                        ),
                      ),
                    );
                    return;
                  }
                  if (_authVM.user != null) {
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
                            Text('Welcome ${_fullNameController.text.trim()}'),
                          ],
                        ),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  }
                },
        ),
        SizedBox(height: AppSizes.paddingMedium),

        _buildContinueWithRow(),
        SizedBox(height: AppSizes.paddingMedium + 5),

        _buildOutlineButton(),
        SizedBox(height: AppSizes.paddingMedium + 5),

        _buildLogin(),
      ],
    );
  }

  //Signup Header
  Widget _buildSignupHeader() {
    return Column(
      children: [
        SizedBox(height: AppSizes.paddingMedium + 10),

        Image.asset(AppAssets.signup, height: 200),
        Text(
          'Create Account',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 25,
            color: Colors.grey[900],
          ),
        ),
        Text(
          'Join TripPack and make packing easy.',
          style: AppTextStyles.heading4.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  //TextFormField
  Widget _buildTextFormField({
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

  //Login Page Navigation
  Widget _buildLogin() {
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
              MaterialPageRoute(builder: (context) => LoginView()),
            );
          },
          child: Text(
            'Login',
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
  Widget _buildOutlineButton() {
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

  Widget _buildContinueWithRow() {
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
}
