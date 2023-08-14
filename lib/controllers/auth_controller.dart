import 'package:gestor_ingresos/models/index.dart';
import 'package:gestor_ingresos/pages/index.dart';
import 'package:gestor_ingresos/providers/index.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  Future<void> _init() async {
    await NotificationProvider.shared.init();
    await FirebaseProvider.shared.init();
    await Future.delayed(const Duration(seconds: 1));
    await checkSesion();
  }

  Future<void> googleLogin() async {
    final UserModel? user = await AuthProvider.shared.googleLogin();
    if (user != null) {
      this.user.value = user;
      await Get.offAllNamed(NavigationPage.routeName);
    }
  }

  Future<void> login(LoginModel login) async {
    final UserModel? user = await AuthProvider.shared.loginWithUserAndPassword(
      login.email,
      login.password,
    );
    if (user != null) {
      this.user.value = user;
      await Get.offAllNamed(NavigationPage.routeName);
    }
  }

  Future<void> register(RegisterModel register) async {
    final UserModel? user = await AuthProvider.shared.registerWithUserAndPassword(register);
    if (user != null) {
      this.user.value = user;
      await Get.offAllNamed(NavigationPage.routeName);
    }
  }

  Future<void> logout() async {
    await AuthProvider.shared.logout();
    await Get.offAllNamed(LoginPage.routeName);
  }

  Future<void> checkSesion() async {
    final UserModel? getUser = AuthProvider.shared.currentUser;
    if (getUser != null) {
      user.value = getUser;
      return await Get.offAllNamed(NavigationPage.routeName);
    }
    await Get.offAllNamed(LoginPage.routeName);
  }
}
