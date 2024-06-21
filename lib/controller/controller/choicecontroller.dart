import 'package:get/get.dart';

class ChoiceController extends GetxController {
  var isHomeOwnerSelected = false.obs;
  var isServiceProviderSelected = false.obs;

  void selectHomeOwner() {
    isHomeOwnerSelected.value = true;
    isServiceProviderSelected.value = false;
  }

  void selectServiceProvider() {
    isHomeOwnerSelected.value = false;
    isServiceProviderSelected.value = true;
  }
}
