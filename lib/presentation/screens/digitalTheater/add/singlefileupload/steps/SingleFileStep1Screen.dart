import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_main_provider.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/add/singlefileuploadmain/single_file_upload_step_1_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SingleFileUploadStep1Screen extends StatefulWidget {
  const SingleFileUploadStep1Screen({super.key});

  @override
  _SingleFileUploadStep1ScreenState createState() =>
      _SingleFileUploadStep1ScreenState();
}

class _SingleFileUploadStep1ScreenState
    extends State<SingleFileUploadStep1Screen> {
  String dtID = '';

  int _genreID = 0;
  String? _dropDownCategory;
  String? _dropDownGenre;

  String? _dropdownLanguage;
  int _langID = 0;

  int _catID = 0;

  String showYear = 'Select Year';
  int selectedYear = 0;
  DateTime _selectedYear = DateTime.now();

  FocusNode focusNodeone = FocusNode();
  FocusNode focusNodetwo = FocusNode();
  FocusNode focusNodethree = FocusNode();
  FocusNode focusNodefour = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleFileUploadStep1Provider>(
      builder: (context, fileUploadProvider, child) {
        final dtProvider =
            Provider.of<SingleFileUploadMainProvider>(context, listen: false);

        final categories = dtProvider.dtInfoFormEntity?.categories ?? [];
        List<String> categoriesList =
            categories.map((i) => i.title).whereType<String>().toList();

        final genres = dtProvider.dtInfoFormEntity?.genres ?? [];
        List<String> genresList = genres
            .map((i) => i.title)
            .whereType<String>()
            .toList(); // Use genres here

        final languages = dtProvider.dtInfoFormEntity?.languages ?? [];
        List<String> languagesList = languages
            .map((i) => i.title)
            .whereType<String>()
            .toList(); // Use languages here

        variablePrint('''
    Languages : $languagesList
    Genres : $genresList
    Categories : $categoriesList
    ''');

        return Padding(
          padding: EdgeInsets.all(8.dg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeading("Enter your title for the movie"),
              SizedBox(height: 10.h),
              _buildDescription(
                  "This poster will be used as the thumbnail for the uploa ded movie"),
              SizedBox(height: 10.h),
              _buildTextField(fileUploadProvider.title, 'Title'),
              SizedBox(height: 20.h),
              _buildHeading("Description"),
              SizedBox(height: 10.h),
              _buildDescription(
                  "This poster will be used as the thumbnail for the uploaded movie"),
              SizedBox(height: 10.h),
              _buildTextField(fileUploadProvider.storyLine, 'Description',
                  maxLines: 4),
              SizedBox(height: 20.h),
              _buildHeading("Pick year"),
              SizedBox(height: 10.h),
              _buildDescription("Select the year in which movie was made"),
              SizedBox(height: 20.h),
              _buildYearSelector(
                onChanged: (DateTime dateTime) {
                  setState(() {
                    _selectedYear = dateTime;
                    showYear = "${dateTime.year}";
                  });
                  fileUploadProvider.setyear = showYear;
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20.h),
              _buildDropdown(
                title: "Choose Category",
                description: "Select the category which movie belongs to.",
                items: categoriesList,
                hintText: "Category",
                selectedItem: _dropDownCategory,
                onChanged: (value) {
                  setState(() {
                    _dropDownCategory = value;
                  });
                  _catID = categories
                      .firstWhere((category) => category.title == value)
                      .id;
                  fileUploadProvider.setcategory = _catID;
                },
              ),
              _buildDropdown(
                title: "Choose Genre",
                description: "Select the genre of your movie",
                items: genresList,
                hintText: 'Genre',
                selectedItem: _dropDownGenre,
                onChanged: (value) {
                  setState(() {
                    _dropDownGenre = value;
                  });
                  _genreID =
                      genres.firstWhere((genre) => genre.title == value).id;
                  fileUploadProvider.setgenre = _genreID;
                },
              ),
              _buildDropdown(
                title: 'Choose Language',
                description: "Select the language for the movie.",
                items: languagesList,
                hintText: 'Language',
                selectedItem: _dropdownLanguage,
                onChanged: (value) {
                  setState(() {
                    _dropdownLanguage = value;
                  });
                  _langID = languages
                      .firstWhere((language) => language.title == value)
                      .id;
                  fileUploadProvider.setlanguage = _langID;
                },
              ),
              _buildHeading("Select the Duration of the movie"),
              SizedBox(height: 20.h),
              _buildDurationSelector(
                onChangedHour: (value) => fileUploadProvider.sethours = value,
                onChangedMinute: (value) =>
                    fileUploadProvider.setminutes = value,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeading(String heading) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: TextStyle(fontSize: 14.sp),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {int maxLines = 1}) {
    return CommonWidgets.CustomTextField(
      hintText: hintText,
      obscureText: false,
      controller: controller,
      borderRadius: BorderRadius.circular(12.r),
      maxLines: maxLines,
    );
  }

  Widget _buildYearSelector({required void Function(DateTime) onChanged}) {
    return InkWell(
      onTap: () => _selectYear(context: context, onChanged: onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(showYear),
            Icon(
              Icons.calendar_month_outlined,
              color: Theme.of(context).colorScheme.surface,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectYear(
      {required BuildContext context,
      required void Function(DateTime) onChanged}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300.w,
            height: 300.h,
            child: YearPicker(
                firstDate: DateTime(DateTime.now().year - 10, 1),
                lastDate: DateTime(2025),
                currentDate: DateTime.now(),
                selectedDate: _selectedYear,
                onChanged: onChanged),
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String title,
    required String description,
    required String hintText,
    required List<String> items,
    required void Function(dynamic value) onChanged,
    String? selectedItem,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 10.h),
        Text(
          description,
          style: TextStyle(fontSize: 14.sp),
        ),
        SizedBox(height: 20.h),
        CommonWidgets.CustomDropDown(
          context: context,
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.surface),
          hintText: hintText,
          items: items,
          onChanged: onChanged,
          selectedValue: selectedItem,
          buttonWidth: 160.w,
          buttonHeight: 60.h,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildDurationSelector({
    required void Function(int) onChangedHour,
    required void Function(int) onChangedMinute,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDurationColumn(
            initialItem: 5,
            itemCount: 13,
            label: "Hour",
            onChanged: onChangedHour),
        _buildDurationColumn(
            initialItem: 31,
            itemCount: 59,
            label: "Minute",
            onChanged: onChangedMinute),
      ],
    );
  }

  Widget _buildDurationColumn({
    required int initialItem,
    required int itemCount,
    required String label,
    required void Function(int value) onChanged,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 140.h,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50.0,
            perspective: 0.001,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Center(
                  child: Text('$index',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 40.sp)),
                );
              },
              childCount: itemCount,
            ),
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Text(label, style: TextStyle(fontSize: 18.sp)),
      ],
    );
  }
}
