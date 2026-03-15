import 'package:flutter/material.dart';
import 'package:travel_pack/data/models/trip_model.dart';
import 'package:travel_pack/widgets/custom_button.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_sizes.dart';
import '../utils/constants/app_textStyle.dart';

class GeneratedListView extends StatefulWidget {
  final TripModel tripData;
  const GeneratedListView({super.key, required this.tripData});

  @override
  State<GeneratedListView> createState() => _GeneratedListViewState();
}

class _GeneratedListViewState extends State<GeneratedListView> {
  late List<bool> _isPacked;

  @override
  void initState() {
    super.initState();
    _isPacked = List<bool>.filled(_getIndividualItems().length, false);
  }

  // Method to split comma-separated items into individual items
  List<String> _getIndividualItems() {
    List<String> allItems = [];
    for (String category in widget.tripData.packingList) {
      // Split by comma and trim each item
      List<String> itemsInCategory = category
          .split(',')
          .map((item) => item.trim())
          .toList();
      allItems.addAll(itemsInCategory);
    }
    // Remove any empty strings
    allItems.removeWhere((item) => item.isEmpty);
    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final individualItems = _getIndividualItems();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppbar(),
                SizedBox(height: AppSizes.paddingLarge),

                Text('Packing List', style: AppTextStyles.heading3),
                SizedBox(height: AppSizes.paddingSmall),

                // ListView with each item on its own line
                Expanded(
                  flex: 1,
                  child: ListView.separated(
                    itemCount: individualItems.length,
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black12,
                      thickness: 0.3,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      return _buildListTile(
                        title: individualItems[index],
                        value: _isPacked[index],
                        onChanged: (val) {
                          setState(() => _isPacked[index] = val!);
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: AppSizes.paddingLarge + 5),

                CustomButton(
                  backgroundColor: AppColors.primary,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.radiusMedium + 1,
                    fontWeight: FontWeight.w600,
                  ),
                  title: 'Mark all as packed',
                  onTap: () {
                    setState(() {
                      _isPacked = List<bool>.filled(_isPacked.length, true);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      width: double.infinity,

      child: Row(
        children: [
          Checkbox(
            fillColor: WidgetStateProperty.all(AppColors.primary),
            side: BorderSide.none,
            value: value,
            onChanged: onChanged,
          ),
          Expanded(
            child: Text(
              _capitalizeFirstLetter(title),
              style: AppTextStyles.heading4.copyWith(
                decoration: value ? TextDecoration.lineThrough : null,
                color: value ? Colors.grey : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Appbar
  Row _buildAppbar() => Row(
    children: [
      InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios_new),
      ),
      SizedBox(width: AppSizes.paddingLarge),
      Text(widget.tripData.tripType, style: AppTextStyles.appbar),
    ],
  );
}
