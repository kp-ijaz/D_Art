import 'package:d_art/view/modules/chatscreen/models/messages_model.dart';
import 'package:d_art/view/modules/chatscreen/services/api_services.dart';
import 'package:get/get.dart';

class UserMessagesController extends GetxController {
  var isLoading = false.obs;
  var chatData = MessagesModel().data.obs;

  getData({required String userID}) async {
    isLoading.value = true;
    final data = await ApiServices().getUserMessages(userID: userID);
    chatData.value = data!.data;
    isLoading.value = false;
    update();
    chatData.refresh();
  }
}
