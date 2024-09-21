import 'package:get/get.dart';

class ServiceHomeController extends GetxController {
  var selectedChipIndex = 0.obs;

  void selectChip(int index) {
    selectedChipIndex.value = index;
  }
}
