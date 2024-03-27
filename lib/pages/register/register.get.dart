import 'package:chatify/cacheManager/user.cache.dart';
import 'package:chatify/constants/config.dart';
import 'package:chatify/services/register.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterGet extends GetxController {
  var fullname = ''.obs;
  var username = ''.obs;
  var password = ''.obs;

  var loading = false.obs;
  TextEditingController controller = TextEditingController();
  void createNewAccount() async {
    if (fullname.value.isEmpty ||
        username.value.isEmpty ||
        password.value.isEmpty) {
      Config.errorHandler(
        title: 'Empty fields',
        message: 'Please enter all the fields!',
      );
      controller.clear();
      return;
    }

    if (!loading.value) {
      loading.value = true;

      try {
        final service = RegisterService();
        final result = await service.call({
          'fullname': fullname.value,
          'username': username.value,
          'password': password.value
        });
        loading.value = false;
        if (result) {
          Config.me = UserCacheManager.getUserData();
          Get.offAllNamed(PageRoutes.splash);
        }
      } catch (er) {
        Config.errorHandler(title: 'Error', message: er.toString());
        loading.value = false;
      }
    }
  }
}
