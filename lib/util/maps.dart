import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapsController extends GetxController {
  static MapsController get to => Get.find<MapsController>();

  Future<Position> posicaoAtual() async {
    LocationPermission permissao;
    bool ativado = await Geolocator.isLocationServiceEnabled();

    if (!ativado) {
      return Future.error('Por favor, habilite a localização');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso a localização');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso a localização nas configurações');
    }

    return await Geolocator.getCurrentPosition();
  }
}
