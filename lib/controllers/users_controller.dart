import 'dart:convert';
import 'package:atareak/controllers/cars_controller.dart';
import 'package:atareak/controllers/utilities/global_variables.dart';
import 'package:atareak/controllers/utilities/pref_keys.dart';
import 'package:atareak/models/user.dart';
import 'package:atareak/views/utilities/server_messages_translator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'network_handler.dart';
import 'user_location_controller.dart';

class UsersController extends GetxController {
  static final NetworkHandler _networkHandler = NetworkHandler();
  final CarsController _carsController = Get.put(CarsController());
  static String errorMessage = '';

  Future<bool> register({
    String id,
    String firstName,
    String lastName,
    String fatherName,
    String description,
    bool smoker,
    String email,
    String phone,
    String password,
    String imagePath,
  }) async {
    final Map<String, dynamic> descriptionMap = {
      'description': description,
      'smoker': smoker
    };
    final Map<String, String> data = {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fatherName': fatherName,
      'description': jsonEncode(descriptionMap),
      'email': email,
      'phone': '+9639$phone',
      'password': password
    };
    final Map<String, dynamic> multi = {
      'img': imagePath,
    };
    final response =
        await _networkHandler.multiPartRequestPost('/user', data, multi);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await _storeLoginResponse(response);
      await _carsController.doesUserHaveCars();
      return true;
    }
    errorMessage = serverMessageTranslator(response.body);
    return false;
  }

  Future<bool> login({String email, String password}) async {
    final Map<String, String> data = {'email': email, 'password': password};
    final response = await _networkHandler.post('/auth/login', data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await _storeLoginResponse(response);
      await _carsController.doesUserHaveCars();
      return true;
    }
    errorMessage = serverMessageTranslator(response.body);
    return false;
  }

  Future<void> _storeLoginResponse(http.Response response) async {
    final Map<String, dynamic> output = jsonDecode(response.body);
    final descriptionOutPut = jsonDecode(output['description']);
    final List<String> roles = [];
    for (final String role in output['roles']) {
      roles.add(role);
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefKeys.userToken, output['token']);
    await prefs.setString(PrefKeys.userID, output['id']);
    await prefs.setString(PrefKeys.userName, output['name']);
    await prefs.setString(PrefKeys.userGender, output['gender']);
    await prefs.setInt(PrefKeys.userAge, int.parse(output['age']));
    // await prefs.setString(PrefKeys.userEmail, output['email']);
    await prefs.setInt(PrefKeys.userPhone, output['phone']);
    await prefs.setStringList(PrefKeys.userRoles, roles);
    await prefs.setString(
        PrefKeys.userDescription, descriptionOutPut['description']);
    await prefs.setBool(PrefKeys.userSmoker, descriptionOutPut['smoker']);
    // output['img'] != null
    //     ? await prefs.setString(PrefKeys.userImage, output['img'])
    //     : await prefs.setString(PrefKeys.userImage, 'No Image Available');

    final UserLocationController userLocationController =
        Get.put(UserLocationController());
    await userLocationController.setInitialLocation();
  }

  Future<User> getAUserProfile({String id}) async {
    final response = await _networkHandler.get('/user/$id');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> output = jsonDecode(response.body);
      return User.fromJson(id, output);
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<bool> rateAUser({String id, double value, String comment}) async {
    final Map<String, dynamic> data = {
      'value': value,
      'comment': comment,
    };
    final response = await _networkHandler.post("/user/$id/rate", data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    errorMessage = serverMessageTranslator(response.body);
    return null;
  }

  Future<dynamic> isBlocked({String id}) async {
    final response = await _networkHandler.get('/auth/locked');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return false;
    }
    errorMessage = serverMessageTranslator(response.body);
    if (errorMessage == 'عزيزي المستخدم حسابك محظور بسبب سوء الاستخدام') {
      return true;
    }
    return null;
  }

  Future<void> logout() async {
    globalNotifications = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userToken')) {
      return true;
    }
    return false;
  }
}
