import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

class InternetConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  Future<bool> checkInternetConnection() async =>
      await _connectivity.checkConnectivity() != ConnectivityResult.none;
}
