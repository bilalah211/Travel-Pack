import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_pack/utils/constants/app_assets.dart';
import 'package:travel_pack/view/authentication/login_view.dart';
import 'package:travel_pack/view/your_trip_view.dart';
import 'package:travel_pack/view_models/auth_view_model.dart';
import 'package:travel_pack/view_models/cloudinary_view_model.dart';
import 'package:travel_pack/widgets/custom_button.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_sizes.dart';
import '../utils/constants/app_textStyle.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
    final _cloudinaryVM = Provider.of<CloudinaryViewModel>(context);
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(gradient: AppColors.blueSkyGradient),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingLarge,
            vertical: AppSizes.paddingLarge,
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppbar(),
                SizedBox(height: AppSizes.paddingLarge),

                _buildProfileUpperPart(),
                SizedBox(height: AppSizes.paddingLarge),
                InkWell(
                  onTap: () {
                    _showEditProfileDialog();
                  },
                  child: _buildCardTiles(
                    isEnable: true,

                    title: _cloudinaryVM.userName,
                    icon: Icons.note,
                    iconColor: Colors.blue,
                  ),
                ),

                _buildCardTiles(
                  isEnable: true,
                  title: 'Notifications',
                  icon: Icons.notifications,
                  iconColor: Colors.green,
                ),
                SizedBox(height: AppSizes.paddingLarge + 10),

                CustomButton(
                  title: 'Update',
                  backgroundColor: AppColors.primary,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.radiusMedium + 1,
                    fontWeight: FontWeight.w600,
                  ),
                  onTap: () async {
                    if (_cloudinaryVM.pickedImage != null) {
                      await _cloudinaryVM.uploadImage();
                    } else {
                      await _cloudinaryVM.updateProfile(
                        _cloudinaryVM.userName,
                        _cloudinaryVM.uploadedImageUrl ?? '',
                      );
                    }
                  },
                ),
                SizedBox(height: AppSizes.paddingSmall),
                SizedBox(
                  height: height * 0.055,
                  width: width * 0.45,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    onPressed: () async {
                      SharedPreferences _sp =
                          await SharedPreferences.getInstance();
                      await AuthViewModel().signOut();
                      await _sp.setBool('isLoggedIn', false);
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );
                    },
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          SharedPreferences _sp =
                              await SharedPreferences.getInstance();
                          await AuthViewModel().signOut();
                          await _sp.setBool('isLoggedIn', false);
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.red, size: 22),
                            SizedBox(width: AppSizes.paddingSmall),

                            Text(
                              'Logout',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardTiles({
    required String title,
    Color? iconColor,
    IconData? icon,
    bool? isEnable,
    Color? textColor,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: contentPadding,
        leading: isEnable == null ? null : Icon(icon, color: iconColor),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  //Profile Image And Name

  Widget _buildProfileUpperPart() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final _cloudinaryVM = Provider.of<CloudinaryViewModel>(context);

    return Container(
      width: width,

      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                backgroundImage: _cloudinaryVM.pickedImage != null
                    ? FileImage(_cloudinaryVM.pickedImage!)
                    : (_cloudinaryVM.uploadedImageUrl != null
                          ? NetworkImage(_cloudinaryVM.uploadedImageUrl!)
                          : AssetImage(AppAssets.profile)),
              ),

              // _cloudinaryVM.pickedImage != null
              //     ? Positioned(
              //         top: 0,
              //         left: 110,
              //         right: 0,
              //         bottom: 100,
              //         child: InkWell(
              //           onTap: () async {
              //             _cloudinaryVM.uploadedImageUrl = null;
              //             _cloudinaryVM.pickedImage = null;
              //             setState(() {});
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //               color: AppColors.primary,
              //               shape: BoxShape.circle,
              //             ),
              //
              //             child: Icon(
              //               Icons.close,
              //               color: Colors.white,
              //               size: 22,
              //             ),
              //           ),
              //         ),
              //       )
              //     : Positioned(
              //         top: 0,
              //         left: 107,
              //         right: 0,
              //         bottom: -90,
              //         child: InkWell(
              //           onTap: () async {
              //             Future? url = context
              //                 .read<CloudinaryViewModel>()
              //                 .pickImage();
              //             if (url != null) {
              //               print("Selected Image URL in UI: $url");
              //             }
              //             setState(() {
              //               url = null;
              //             });
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //               color: AppColors.primary.withValues(alpha: 0.9),
              //               shape: BoxShape.circle,
              //             ),
              //
              //             child: Icon(
              //               Icons.camera_alt_outlined,
              //               color: Colors.white,
              //               size: 20,
              //             ),
              //           ),
              //         ),
              //       ),
            ],
          ),

          TextButton(
            onPressed: _showImagePickerBottomSheet,
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  //Appbar
  Widget _buildAppbar() => Row(
    children: [
      InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => YourTripView()),
          );
        },
        child: Icon(Icons.arrow_back_ios_new),
      ),
      SizedBox(width: AppSizes.paddingMedium),
      Text('Profile', style: AppTextStyles.appbar),
    ],
  );

  void _showEditProfileDialog() {
    final vm = context.read<CloudinaryViewModel>();
    final nameController = TextEditingController(text: vm.userName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change your name:'),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium + 2),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Enter your name',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => _saveProfile(vm, nameController.text),
            child: Text('Save', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showImagePickerBottomSheet() {
    final _cloudinaryVM = Provider.of<CloudinaryViewModel>(
      context,
      listen: false,
    );

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Container(
              margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xfff5f6fb),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choose from Gallery'),
                    onTap: () async {
                      final url = _cloudinaryVM.pickImage();
                      if (url != null) {
                        setState(() {});
                      }
                      Navigator.pop(context);
                    },
                  ),
                  Divider(color: Colors.black12, endIndent: 10, indent: 10),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Take Photo'),
                    onTap: () {
                      _cloudinaryVM.pickImageFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                  Divider(color: Colors.black12, endIndent: 10, indent: 10),

                  ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text(
                      'Remove Photo',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      _deleteProfileImageAlert();
                      // final success = await _cloudinaryVM.deleteImage();
                      // if (success) {
                      //
                      //   Navigator.pop(context);
                      // }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile(CloudinaryViewModel vm, String newName) async {
    if (newName.trim().isEmpty) return;

    // Upload image if new one selected
    String? imageUrl = vm.uploadedImageUrl;
    if (vm.pickedImage != null) {
      imageUrl = await vm.uploadImage();
    }

    // Update profile
    final success = await vm.updateProfile(newName.trim(), imageUrl ?? '');

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,

          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.paddingMedium),
          ),
          content: Row(
            children: [
              Icon(Icons.update, color: Colors.white),
              SizedBox(width: AppSizes.paddingSmall),
              Text('Profile Updated!!'),
            ],
          ),
        ),
      );
    }
  }

  void _deleteProfileImageAlert() {
    final _cloudinaryVM = Provider.of<CloudinaryViewModel>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Image!!'),
        content: Text('This action will permanently delete your image.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              final success = await _cloudinaryVM.deleteImage();
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,

                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.paddingMedium,
                      ),
                    ),
                    content: Row(
                      children: [
                        Icon(Icons.remove_circle, color: Colors.white),
                        SizedBox(width: AppSizes.paddingSmall),
                        Text('Image Deleted'),
                      ],
                    ),
                  ),
                );
              }
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
