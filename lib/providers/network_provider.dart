import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkProvider {
  Future<bool> isUserConnectedToNetwork() async {
    // holder for results
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    // check if user is connected to any network
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    } else {
      return false;
    }
  }
}
