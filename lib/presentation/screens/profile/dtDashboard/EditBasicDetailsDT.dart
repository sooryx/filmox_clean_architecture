// ignore_for_file: unused_field

import 'dart:io';


import 'package:filmox_clean_architecture/core/utils/urls.dart';
import 'package:filmox_clean_architecture/presentation/providers/digitalTheater/dt_dashboard_provider/dt_dashboard_provider.dart';
import 'package:filmox_clean_architecture/widgets/common_widgets.dart';
import 'package:filmox_clean_architecture/widgets/custom_popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Editbasicdetailsdt extends StatefulWidget {
  const Editbasicdetailsdt({
    super.key,
  });

  @override
  State<Editbasicdetailsdt> createState() => _EditbasicdetailsdtState();
}

class _EditbasicdetailsdtState extends State<Editbasicdetailsdt> {
  String? posterImage;

  TextEditingController _titlleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedYear = DateTime.now();

  int selectedHour = 0;
  int selectedMinutes = 0;

  String? showYear;

  String? _dropDownCertificate;

  String? _dropDownCategory;
  int? _catID;

  String? _dropdownLanguage;
  int? _langID;

  String? _dropDownGenre;
  int? _genreID;

  @override
  void initState() {
    super.initState();
    final dashboardprovider =
        Provider.of<DTDashboardProvider>(context, listen: false);
    final dtData = dashboardprovider.digitalTheaterDashBoardEntity;

    _titlleController = TextEditingController(text: dtData?.title ?? "NA");
    _descriptionController =
        TextEditingController(text: dtData?.storyLine ?? "NA");
    posterImage = dtData?.poster;
    showYear = dtData?.year.toString() ?? "Select Year";
    _catID = dtData?.categoryId ?? 0;
    _langID = dtData?.languageId ?? 0;
    _genreID = dtData?.genreId ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.surface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
            color: Colors.green,
            onPressed: () async {
              final dtProvider = Provider.of<DTDashboardProvider>(
                  context,
                  listen: false);
              try {
                await dtProvider.editDigitalTheaterDetails(
                  context: context,
                  id: dtProvider.digitalTheaterDashBoardEntity?.id ?? 0,
                  category: _catID.toString(),
                  title: _titlleController.text,
                  poster: poster,
                  year: showYear ?? "2018",
                  certificate: dtProvider.digitalTheaterDashBoardEntity?.certificate ??
                      "U/A",
                  genre: _genreID.toString(),
                  language: _langID.toString(),
                  storyLine: _descriptionController.text,
                  uploadType:
                  dtProvider.digitalTheaterDashBoardEntity?.uploadType ??
                          1,
                  hours: dtProvider.digitalTheaterDashBoardEntity?.hours,
                  minutes:
                  dtProvider.digitalTheaterDashBoardEntity?.minutes,
                );
                Navigator.pop(context,dtProvider);
              } catch(e) {
                customErrorToast(context, e.toString());
              }
            },
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: Consumer<DTDashboardProvider>(
        builder: (context, dtProvider, child) {
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
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            children: [
              Text(
                "Upload poster for the movie",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10.h),
              Text(
                  "This poster will be used as the thumbnail for the uploaded movie",
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 20.h),
              uploadPhoto(posterImage: posterImage),
              SizedBox(height: 20.h),
              Text(
                "Title",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10.h),
              Text(
                "Edit the title of your movie.",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              CommonWidgets.CustomTextField(
                controller: _titlleController,
                hintText: "Title",
                obscureText: false,
              ),
              SizedBox(height: 20.h),
              Text(
                "Description",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10.h),
              Text(
                "Edit the story line of your movie.",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              CommonWidgets.CustomTextField(
                controller: _descriptionController,
                hintText: "Description",
                obscureText: false,
              ),
              SizedBox(height: 20.h),
              Text(
                "Select Year",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10.h),
              Text(
                "Select the year in which movie was made.",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  selectYear(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(showYear ?? "NA"),
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              dropdownItems(
                  title: "Choose Category",
                  description: "Select the category which movie belongs to.",
                  items: categoriesList,
                  hintText: "Category",
                  selectedItem: _dropDownCategory,
                  onChanged: (value) {
                    setState(() {
                      _dropDownCategory = value;
                      _catID = dtProvider.dtInfoFormEntity!.categories
                          .firstWhere((category) => category.title == value)
                          .id;
                    });
                  }),
              dropdownItems(
                title: "Choose Genre",
                description: "Select the genre of your movie",
                hintText: 'Genre',
                items: genresList,
                onChanged: (value) {
                  setState(() {
                    _dropDownGenre = value;
                    _genreID = dtProvider.dtInfoFormEntity!.genres
                        .firstWhere((genres) => genres.title == value)
                        .id;
                  });
                },
                selectedItem: _dropDownGenre,
              ),
              dropdownItems(
                title: 'Choose Language',
                description: "Select the language for the movie.",
                hintText: 'Language',
                items: languagesList,
                onChanged: (value) {
                  setState(() {
                    _dropdownLanguage = value;
                    _langID = dtProvider.dtInfoFormEntity!.languages
                        .firstWhere((genres) => genres.title == value)
                        .id;
                  });
                },
                selectedItem: _dropdownLanguage,
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickPoster() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        poster = File(pickedFile.path);
      }
    });
  }

  File? poster;

  Widget uploadPhoto({String? posterImage}) {
    return InkWell(
      onTap: () {
        _pickPoster().then((_) {}).catchError((error) {});
      },
      child: Column(
        children: [
          Container(
            height: 160.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: poster != null ? BoxFit.cover : BoxFit.contain,
                  image: poster != null
                      ? FileImage(
                          poster!,
                        ) as ImageProvider<Object>
                      : NetworkImage("${UrlStrings.imageUrl}${posterImage!}"),
                ),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                    width: 2,
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withOpacity(0.8))),
          )
        ],
      ),
    );
  }

  selectYear(context) async {
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
              onChanged: (DateTime dateTime) {
                setState(() {
                  _selectedYear = dateTime;
                  showYear = "${dateTime.year}";
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget dropdownItems(
      {required String title,
      required String description,
      required List<String> items,
      required String hintText,
      required void Function(String?) onChanged,
      required String? selectedItem}) {
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
          hintText: 'Category',
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
}
