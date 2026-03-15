import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_pack/utils/constants/app_assets.dart';
import 'package:travel_pack/utils/constants/app_colors.dart';
import 'package:travel_pack/utils/constants/app_sizes.dart';
import 'package:travel_pack/utils/constants/app_textStyle.dart';
import 'package:travel_pack/view/authentication/login_view.dart';
import 'package:travel_pack/view/onboarding_view.dart';
import 'package:travel_pack/view/your_trip_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    _navigateUser();
    super.initState();
  }

  void _navigateUser() async {
    SharedPreferences _sp = await SharedPreferences.getInstance();

    final isFirstTime = _sp.getBool('isFirstTime') ?? true;
    final isLoggedIn = _sp.getBool('isLoggedIn') ?? false;

    await Future.delayed(Duration(seconds: 2));

    if (isFirstTime) {
      await _sp.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingView()),
      );
    } else if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => YourTripView()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.blueSkyGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.logo),
            Text(
              'TripPack Ai',
              style: AppTextStyles.heading1.copyWith(
                color: Colors.grey[800],
                fontSize: 45,
              ),
            ),
            SizedBox(height: AppSizes.marginSmall),
            Text(
              'Pack Smart. Travel Light',
              style: AppTextStyles.heading4.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: AppSizes.marginLarge),

            Container(
              height: 100,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Lottie.asset(AppAssets.loading),
            ),
          ],
        ),
      ),
    );
  }
}
