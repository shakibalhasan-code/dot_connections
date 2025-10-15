import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppInitialController extends GetxController {
  final emailController = TextEditingController();
  final RxString email = ''.obs;
  final RxBool isMarketingChecked = true.obs;
  final otpController = TextEditingController();
  final RxString otp = ''.obs;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final RxString firstName = ''.obs;
  final RxString lastName = ''.obs;

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxInt age = 0.obs;

  final RxBool notificationsEnabled = false.obs;

  final List<String> heights = [
    "5'3\" (161 cm)",
    "5'4\" (163 cm)",
    "5'5\" (165 cm)",
    "5'6\" (167 cm)",
    "5'7\" (169 cm)",
    "5'8\" (171 cm)",
    "5'9\" (173 cm)",
  ];
  final RxString selectedHeight = "5'6\" (167 cm)".obs;

  // Updated to match API format - lowercase
  final List<String> datingOptions = ['Men', 'Women', 'Everyone'];
  final List<String> datingApiValues = ['male', 'female', 'everyone'];
  final RxString datingPreference = 'Everyone'.obs;

  // Updated to match API format - lowercase
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> genderApiValues = ['male', 'female', 'other'];
  final RxString gender = 'Male'.obs;
  final RxBool showGenderOnProfile = false.obs;

  final locationController = TextEditingController();

  // Updated display values for passions
  final List<String> passions = [
    'Travel',
    'Photography',
    'Fitness',
    'Cooking',
    'Music',
    'Art',
    'Reading',
    'Movies',
    'Hiking',
    'Dancing',
    'Gaming',
    'Fashion',
    'Sports',
    'Yoga',
    'Craft Beer',
    'Tango',
    'Pets',
  ];

  // API format values for passions (lowercase with underscores)
  final List<String> passionsApiValues = [
    'travel',
    'photography',
    'fitness',
    'cooking',
    'music',
    'art',
    'reading',
    'movies',
    'hiking',
    'dancing',
    'gaming',
    'fashion',
    'sports',
    'yoga',
    'craft_beer',
    'tango',
    'pets',
  ];
  final RxList<String> selectedPassions = <String>[].obs;

  final workplaceController = TextEditingController();
  final RxBool showWorkplaceOnProfile = false.obs;

  final hometownController = TextEditingController();
  final RxBool showHometownOnProfile = false.obs;

  final jobTitleController = TextEditingController();
  final RxBool showJobTitleOnProfile = false.obs;

  // Updated lookingFor options and default value
  final List<String> lookingForOptions = [
    'What are you looking for?',
    'Friendship',
    'Dating',
    'Relationship',
    'Networking',
  ];
  final List<String> lookingForApiValues = [
    'dating',
    'friendship',
    'dating',
    'relationship',
    'networking',
  ];

  final RxString lookingFor = 'What are you looking for?'.obs;
  final minAgeController = TextEditingController();
  final maxAgeController = TextEditingController();
  final RxDouble maxDistance = 25.0.obs;

  final List<String> educationOptions = [
    'High school',
    'Under graduation',
    'Post graduation',
    'Prefer Not to Say',
  ];

  final List<String> educationApiValues = [
    'highSchool',
    'underGraduation',
    'postGraduation',
    'preferNotToSay',
  ];
  final RxString selectedEducation = ''.obs;
  final RxBool showEducationOnProfile = false.obs;

  final List<String> religionOptions = [
    'Buddhist',
    'Catholic',
    'Christian',
    'Hindu',
    'Jewish',
    'Muslim',
    'Spiritual',
    'Agnostic',
    'Atheist',
    'Other',
    'Prefer Not to Say',
  ];

  final List<String> religionApiValues = [
    'buddhist',
    'catholic',
    'christian',
    'hindu',
    'jewish',
    'muslim',
    'spiritual',
    'agnostic',
    'atheist',
    'other',
    'prefer_not_to_say',
  ];
  final RxString selectedReligion = ''.obs;
  final RxBool showReligionOnProfile = false.obs;

  final List<String> drinkOptions = [
    'Yes',
    'Occasionally',
    'No',
    'Prefer Not to Say',
  ];

  // No conversion needed as API values match display values
  final RxString selectedDrink = ''.obs;
  final RxBool showDrinkOnProfile = false.obs;

  final List<String> smokeOptions = [
    'Yes',
    'Occasionally',
    'No',
    'Prefer Not to Say',
  ];

  // No conversion needed as API values match display values
  final RxString selectedSmoke = ''.obs;
  final RxBool showSmokeOnProfile = false.obs;

  final bioController = TextEditingController();

  bool get isEmailButtonEnabled =>
      email.value.isNotEmpty && GetUtils.isEmail(email.value);
  bool get isOtpButtonEnabled => otp.value.length == 6;
  bool get isNameButtonEnabled => firstName.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(() {
      email.value = emailController.text;
      update();
    });
    otpController.addListener(() {
      otp.value = otpController.text;
      update();
    });
    firstNameController.addListener(() {
      firstName.value = firstNameController.text;
      update();
    });
    lastNameController.addListener(() {
      lastName.value = lastNameController.text;
      update();
    });
  }

  void toggleMarketing(bool? value) {
    isMarketingChecked.value = value ?? false;
    update();
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    age.value = DateTime.now().year - selectedDate.value.year;
    update();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    update();
  }

  void setHeight(String height) {
    selectedHeight.value = height;
    update();
  }

  void setDatingPreference(String preference) {
    datingPreference.value = preference;
    update();
  }

  void setGender(String newGender) {
    gender.value = newGender;
    update();
  }

  void toggleShowGender(bool value) {
    showGenderOnProfile.value = value;
    update();
  }

  void togglePassion(String passion) {
    if (selectedPassions.contains(passion)) {
      selectedPassions.remove(passion);
    } else {
      selectedPassions.add(passion);
    }
    update();
  }

  void toggleShowWorkplace(bool value) {
    showWorkplaceOnProfile.value = value;
    update();
  }

  void toggleShowHometown(bool value) {
    showHometownOnProfile.value = value;
    update();
  }

  void toggleShowJobTitle(bool value) {
    showJobTitleOnProfile.value = value;
    update();
  }

  void setLookingFor(String value) {
    lookingFor.value = value;
    update();
  }

  void setMaxDistance(double value) {
    maxDistance.value = value;
    update();
  }

  void setEducation(String value) {
    selectedEducation.value = value;
    update();
  }

  void toggleShowEducation(bool value) {
    showEducationOnProfile.value = value;
    update();
  }

  void setReligion(String value) {
    selectedReligion.value = value;
    update();
  }

  void toggleShowReligion(bool value) {
    showReligionOnProfile.value = value;
    update();
  }

  void setDrink(String value) {
    selectedDrink.value = value;
    update();
  }

  void toggleShowDrink(bool value) {
    showDrinkOnProfile.value = value;
    update();
  }

  void setSmoke(String value) {
    selectedSmoke.value = value;
    update();
  }

  void toggleShowSmoke(bool value) {
    showSmokeOnProfile.value = value;
    update();
  }
}
