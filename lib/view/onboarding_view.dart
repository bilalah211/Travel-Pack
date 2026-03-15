import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_pack/data/models/onboarding_model.dart';
import 'package:travel_pack/utils/constants/app_assets.dart';
import 'package:travel_pack/widgets/custom_button.dart';

import '../utils/constants/app_colors.dart';
import '../utils/constants/app_sizes.dart';
import '../utils/constants/app_textStyle.dart';
import 'authentication/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

PageController _pageController = PageController();
int _currentPage = 0;

class _OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.blueSkyGradient),
        child: Column(
          children: [
            Expanded(child: buildSkipButton()),
            Expanded(flex: 6, child: buildPageViewOnboarding()),
          ],
        ),
      ),
    );
  }

  //Onboarding Page View
  PageView buildPageViewOnboarding() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _onboardingPage.length,
      itemBuilder: (context, index) => _buildOnboardingWidgets(index),
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
    );
  }

  //Skip Button
  Padding buildSkipButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSizes.paddingMedium,
        right: AppSizes.paddingSmall,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            _pageController.jumpToPage(_onboardingPage.length - 1);
          },
          child: Text(
            _currentPage == 2 ? '' : 'Skip',
            style: TextStyle(color: AppColors.primary, fontSize: 16),
          ),
        ),
      ),
    );
  }

  //Onboarding image,title and subtitle
  Column _buildOnboardingWidgets(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          _onboardingPage[index].image,
          fit: BoxFit.cover,
          height: 300,
        ),
        Text(
          _onboardingPage[index].title,
          style: AppTextStyles.heading1.copyWith(
            color: Colors.grey[800],
            fontSize: 30,
          ),
        ),
        SizedBox(height: AppSizes.marginSmall),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.paddingLarge,
            right: AppSizes.paddingLarge,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              _onboardingPage[index].subTitle,
              style: AppTextStyles.heading4.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.marginLarge + 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _onboardingPage.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 30 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary
                    : Colors.grey[500],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.marginLarge + 20),

        Padding(
          padding: const EdgeInsets.only(
            left: AppSizes.paddingLarge,
            right: AppSizes.paddingLarge,
          ),
          child: CustomButton(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: AppSizes.radiusMedium + 1,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: AppColors.primary,
            title: _currentPage == _onboardingPage.length - 1
                ? 'Get Started'
                : 'Next',
            onTap: () {
              if (_currentPage == _onboardingPage.length - 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  //Onboarding Page [image,title,subtitle]
  final List<OnboardingModel> _onboardingPage = [
    OnboardingModel(
      title: 'Explore the world',
      subTitle:
          'Find the best places to visit, from hidden gems to popular hotspots',
      image: AppAssets.onboarding1,
      colors: AppColors.primary,
    ),
    OnboardingModel(
      title: 'Your AI Travel Assistant',
      subTitle:
          'Track trips, manage reminders, and explore smarter with your all-in-one travel companion.',
      image: AppAssets.onboarding2,
    ),
    OnboardingModel(
      title: 'Pack Like a Pro',
      subTitle:
          'Get personalized packing lists based on weather, trip type, and location — never forget an essential again.',
      image: AppAssets.onboarding3,
    ),
  ];
}
