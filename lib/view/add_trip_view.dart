import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:travel_pack/utils/constants/app_textStyle.dart';
import 'package:travel_pack/view/generated_list_view.dart';
import 'package:travel_pack/view_models/trip_view_model.dart';
import 'package:travel_pack/widgets/custom_button.dart';

import '../utils/constants/app_colors.dart';
import '../utils/constants/app_sizes.dart';

class AddTripView extends StatefulWidget {
  const AddTripView({super.key});

  @override
  State<AddTripView> createState() => _AddTripViewState();
}

final _destinationController = TextEditingController();
final _startDateController = TextEditingController();
final _endDateController = TextEditingController();
final _notesController = TextEditingController();
String? selectedTripType;

class _AddTripViewState extends State<AddTripView> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final _tripVM = Provider.of<TripViewModel>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(gradient: AppColors.blueSkyGradient),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSizes.paddingLarge + 45,
              horizontal: AppSizes.paddingLarge,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppbar(),
                SizedBox(height: AppSizes.paddingMedium),
                _buildTextFormField(
                  contentPadding: EdgeInsets.only(
                    top: AppSizes.paddingMedium + 10,

                    left: AppSizes.paddingMedium + 5,
                    right: AppSizes.paddingMedium + 5,
                  ),
                  title: 'Destination',
                  controller: _destinationController,
                  prefixIcon: Iconsax.global,
                ),
                _buildDatePickerField(
                  contentPadding: EdgeInsets.only(
                    left: AppSizes.paddingMedium + 5,
                    right: AppSizes.paddingMedium + 5,
                  ),
                  title: 'Start Date',
                  controller: _startDateController,
                  prefixIcon: Iconsax.calendar,
                  selectedDate: _startDate,
                  onTap: () => _selectStartDate(context),
                ),

                // End Date Picker
                _buildDatePickerField(
                  contentPadding: EdgeInsets.only(
                    left: AppSizes.paddingMedium + 5,
                    right: AppSizes.paddingMedium + 5,
                  ),
                  title: 'End Date',
                  prefixIcon: Iconsax.calendar,
                  controller: _endDateController,
                  selectedDate: _endDate,
                  onTap: () => _selectEndDate(context),
                ),
                SizedBox(height: AppSizes.paddingMedium - 7),

                //Drop Down Menu
                _buildDropdownTextFormField(),
                _buildTextFormField(
                  contentPadding: EdgeInsets.only(
                    top: AppSizes.paddingMedium + 10,
                    left: AppSizes.paddingMedium + 5,
                    right: AppSizes.paddingMedium + 5,
                  ),
                  title: 'Notes',
                  controller: _notesController,
                  prefixIcon: Iconsax.note,
                  maxLines: 3,
                ),
                SizedBox(height: AppSizes.paddingLarge + 20),

                SizedBox(
                  child: CustomButton(
                    backgroundColor: AppColors.primary,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.radiusMedium + 1,
                      fontWeight: FontWeight.w600,
                    ),
                    title: 'Generate Packing List',
                    onTap: () async {
                      // Validate required fields
                      if (_destinationController.text.isEmpty) {
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
                                Icon(Iconsax.global, color: Colors.white),
                                SizedBox(width: AppSizes.paddingSmall),
                                Text('Please Enter your Destination'),
                              ],
                            ),
                          ),
                        );
                        return;
                      }

                      if (selectedTripType == null) {
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
                                Icon(Iconsax.briefcase, color: Colors.white),
                                SizedBox(width: AppSizes.paddingSmall),
                                Text('Please select trip type'),
                              ],
                            ),
                          ),
                        );
                        return;
                      }

                      if (_startDate == null || _endDate == null) {
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
                                Icon(Iconsax.clock, color: Colors.white),
                                SizedBox(width: AppSizes.paddingSmall),
                                Text('Please select both end&start Time'),
                              ],
                            ),
                          ),
                        );
                        return;
                      }
                      if (_notesController.text.isEmpty) {
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
                                Icon(Iconsax.note_square, color: Colors.white),
                                SizedBox(width: AppSizes.paddingSmall),
                                Text('Please Write Short Note'),
                              ],
                            ),
                          ),
                        );
                        return;
                      }

                      if (_endDate!.isBefore(_startDate!)) {
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
                                Icon(Iconsax.clock, color: Colors.white),
                                SizedBox(width: AppSizes.paddingSmall),
                                Text('Please select correct date'),
                              ],
                            ),
                          ),
                        );
                        return;
                      }

                      try {
                        // Show loading
                        setState(() {});

                        // Call view model with correct parameters
                        await _tripVM.generateAndSaveTripData(
                          _destinationController.text.trim(),
                          _startDate!,
                          _endDate!,
                          selectedTripType!,
                          _notesController.text.trim(),
                        );

                        // Check if successful
                        if (_tripVM.error == null && _tripVM.tripData != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GeneratedListView(
                                tripData: _tripVM.tripData!,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red.shade600,

                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.paddingMedium,
                                ),
                              ),
                              content: Row(
                                children: [
                                  Icon(
                                    Iconsax.info_circle,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: AppSizes.paddingSmall),
                                  Text(
                                    _tripVM.error ?? 'Failed to create trip',
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red.shade600,

                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.paddingMedium,
                              ),
                            ),
                            content: Row(
                              children: [
                                Icon(Iconsax.info_circle, color: Colors.white),
                                SizedBox(width: AppSizes.paddingSmall),
                                Text('Error: $e'),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Drop Down Menu Field
  Widget _buildDropdownTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- Icon + Label Above Field ----
        Row(
          children: [
            Icon(Iconsax.briefcase, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              'Trip Type',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // ---- Dropdown Field ----
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall + 5),
            border: Border.all(color: Colors.black12),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium - 5),
          child: DropdownButtonFormField<String>(
            value: selectedTripType,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: AppSizes.paddingMedium - 5),
              border: InputBorder.none,
            ),
            hint: Text(
              'Select Trip Type',
              style: TextStyle(color: Colors.grey),
            ),
            items: tripTypes
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(
                      type,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedTripType = value;
              });
            },
          ),
        ),
      ],
    );
  }

  //Appbar
  Widget _buildAppbar() => Row(
    children: [
      InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_new),
      ),
      SizedBox(width: AppSizes.paddingMedium),
      Text('Add Trip', style: AppTextStyles.appbar),
    ],
  );

  //textFormField
  Widget _buildTextFormField({
    double? height,
    required String title,
    required TextEditingController controller,
    IconData? suffixIcon,
    IconData? prefixIcon,
    bool isPassword = false,
    EdgeInsets? contentPadding,
    TextAlignVertical? textAlignment,
    int? maxLines,
  }) {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Label Row (Icon + Title) ----
          Row(
            children: [
              if (prefixIcon != null)
                Icon(prefixIcon, size: 20, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          SizedBox(height: 6),

          // ---- Text Field ----
          Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall + 5),
              border: Border.all(color: Colors.black12),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPassword,
              textAlignVertical: textAlignment,
              maxLines: maxLines,
              decoration: InputDecoration(
                filled: true,
                contentPadding: contentPadding,
                fillColor: Colors.white.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall + 5),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter $title...',
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, color: Colors.grey)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Date And Time Field
  Widget _buildDatePickerField({
    required String title,
    double? height,
    required TextEditingController controller,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    IconData? prefixIcon,
    EdgeInsets? contentPadding,
  }) {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Label Row (Icon + Title) ----
          Row(
            children: [
              if (prefixIcon != null)
                Icon(prefixIcon, size: 20, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          SizedBox(height: 6),

          // ---- Text Field ----
          InkWell(
            onTap: onTap,
            child: AbsorbPointer(
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall + 5),
                  border: Border.all(color: Colors.black12),
                ),
                child: TextFormField(
                  controller: controller,

                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: contentPadding,
                    fillColor: Colors.white.withValues(alpha: 0.4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusSmall + 5,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter $title...',
                    hintStyle: TextStyle(color: Colors.grey),

                    // suffixIcon: suffixIcon != null
                    //     ? Icon(suffixIcon, color: Colors.grey)
                    //     : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> tripTypes = [
    'Vacations Trip',
    'Business Trip',
    'Family Trip',
    'Friends Trip',
    'Solo Trip',
    'Adventure Trip',
    'Romantic Trip',
    'Weekend Getaway',
    'Road Trip',
    'Cruise Trip',
    'Camping Trip',
  ];

  // Date Picker Methods
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateController.text = _formatDate(picked);

        // If end date is before new start date, clear end date
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
          _endDateController.clear();
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _endDate ?? (_startDate ?? DateTime.now()).add(Duration(days: 1)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endDateController.text = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
