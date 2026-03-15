import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_pack/data/models/trip_model.dart';
import 'package:travel_pack/utils/constants/app_assets.dart';
import 'package:travel_pack/utils/constants/app_sizes.dart';
import 'package:travel_pack/view/add_trip_view.dart';
import 'package:travel_pack/view/generated_list_view.dart';
import 'package:travel_pack/view/profile_view.dart';
import 'package:travel_pack/view_models/cloudinary_view_model.dart';
import 'package:travel_pack/view_models/trip_view_model.dart';
import '../data/services/nottification_services.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_textStyle.dart';

class YourTripView extends StatefulWidget {
  final TripModel? tripModel;

  YourTripView({super.key, this.tripModel});

  @override
  State<YourTripView> createState() => _YourTripViewState();
}

class _YourTripViewState extends State<YourTripView> {
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CloudinaryViewModel>().loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final _tripVM = Provider.of<TripViewModel>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          decoration: BoxDecoration(gradient: AppColors.blueSkyGradient),
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppSizes.paddingLarge,
              left: AppSizes.paddingLarge,
              right: AppSizes.paddingLarge,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Appbar
                  _buildAppbar(),
                  SizedBox(height: AppSizes.paddingLarge),

                  //Add Trip button
                  _buildButtonContainer(height),
                  SizedBox(height: AppSizes.paddingLarge + 10),

                  //Trips ListView
                  _buildGetAllTripListView(_tripVM),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //------Trip ListView Widget-----//
  FutureBuilder<List<TripModel>?> _buildGetAllTripListView(
    TripViewModel _tripVM,
  ) {
    return FutureBuilder<List<TripModel>?>(
      future: _tripVM.fetchAllTripsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(height: AppSizes.paddingMedium - 5),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(
                      AppSizes.radiusMedium,
                    ),
                    color: Colors.white70.withValues(alpha: 0.4),
                    border: BoxBorder.all(color: Colors.black),
                  ),
                  child: Row(
                    children: [
                      // Image placeholder
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(
                          AppSizes.radiusMedium,
                        ),
                        child: Container(
                          height: 130,
                          width: 90,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(width: AppSizes.paddingMedium),
                      // Text placeholders
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 20,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 8),

                          Container(
                            width: 120,
                            height: 16,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(width: AppSizes.paddingSmall + 95),

                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 33,
                                height: 33,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(width: AppSizes.paddingSmall),
                              Container(
                                width: 40,
                                height: 16,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(height: AppSizes.paddingMedium - 5),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final trip = snapshot.data![index];
              String getWeatherIconUrl(String? code) {
                if (code == null || code.isEmpty) {
                  return 'https://openweathermap.org/img/wn/01d@2x.png';
                }
                if (code.startsWith('http')) {
                  return code;
                }
                return 'https://openweathermap.org/img/wn/${code.trim()}@2x.png';
              }

              final DateFormat formatter = DateFormat('MMM d'); // e.g., Nov 17

              String formattedDateRange =
                  '${formatter.format(trip.startDate)} - ${formatter.format(trip.endDate)}';

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GeneratedListView(tripData: snapshot.data![index]),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white70.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    border: BoxBorder.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),

                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                        child: Image.network(
                          trip.imageUrl,
                          height: 130,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: AppSizes.paddingMedium),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.destination,
                            style: AppTextStyles.heading4.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.grey[900],
                            ),
                          ),

                          SizedBox(height: AppSizes.paddingSmall - 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDateRange,
                                style: AppTextStyles.heading4.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: AppSizes.paddingSmall + 95),

                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GeneratedListView(
                                        tripData: snapshot.data![index],
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.paddingSmall - 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 33,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMedium,
                                  ),
                                ),
                                child: Image.network(
                                  getWeatherIconUrl(trip.weatherIcon),
                                ),
                              ),

                              SizedBox(width: AppSizes.paddingSmall - 2),
                              Text(
                                trip.temperature.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No Trip Planed Yet!'));
        }
      },
    );
  }

  //------Add trip Button-----//
  Widget _buildButtonContainer(double height) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTripView()),
        );
      },
      child: Container(
        height: height * 0.058,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium - 5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 26, color: Colors.grey[900]),
            SizedBox(width: AppSizes.radiusSmall - 5),
            Text(
              'Add New Trip',
              style: AppTextStyles.heading4.copyWith(color: Colors.grey[900]),
            ),
          ],
        ),
      ),
    );
  }

  //------Appbar Widget-----//
  Widget _buildAppbar() {
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text('Your Trips', style: AppTextStyles.appbar),
        ),
        Spacer(),
        IconButton(
          onPressed: () async {
            await NotificationService.showInstantNotification(
              title: 'Trip Reminder',
              body: 'Your trip to Dubai starts tomorrow!',
            );
          },
          icon: Icon(Icons.notifications, size: 30),
        ),

        SizedBox(width: AppSizes.paddingSmall - 5),
        InkWell(
          onTap: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileView()),
            );
          },
          child: Consumer<CloudinaryViewModel>(
            builder: (context, cloudVM, _) {
              final imageUrl = cloudVM.uploadedImageUrl;
              final localImage = cloudVM.pickedImage;

              ImageProvider avatarImage;

              if (localImage != null) {
                avatarImage = FileImage(localImage);
              } else if (imageUrl != null && imageUrl.isNotEmpty) {
                avatarImage = NetworkImage(imageUrl);
              } else {
                avatarImage = const AssetImage(AppAssets.profile);
              }

              return CircleAvatar(radius: 22, backgroundImage: avatarImage);
            },
          ),
        ),
      ],
    );
  }
}
