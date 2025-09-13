import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileContorller extends GetxController {
  ///text controller
  final editFirstNameController = TextEditingController();

  ///list of photo_gallery
  final photoGllery = RxList<String>([

    'https://plus.unsplash.com/premium_photo-1688740375397-34605b6abe48?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmVtYWxlJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
    'https://www.shutterstock.com/image-photo/close-head-shot-portrait-preppy-600nw-1433809418.jpg',
    'https://c.pxhere.com/photos/42/e1/blond_female_girl_model_person_portrait_woman-911371.jpg!d',

  ]);











  /// PHOTO-GALLERY LOGIC <========================

  //update the
  void updatePhoto({required int newIndex, required int oldIndex}) {
    ///get the current index and remove that from our gallery list
    final myPhoto = photoGllery.removeAt(oldIndex);

    ///Place THE new item in the list
    photoGllery.insert(newIndex, myPhoto);
  }
}
