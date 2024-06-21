import 'package:get/get.dart';

class CaptionController extends GetxController {
  RxBool isExpanded = false.obs;

  void expand() {
    isExpanded.value = true;
  }

  void collapse() {
    isExpanded.value = false;
  }
}
