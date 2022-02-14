import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider_update/models/cliente.dart';

class Biometria extends StatelessWidget {
  final _autenticacaoLocal = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _biometriaDiaponivel(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Column(
                children: [
                  const Text(
                      'Detectamos um sensor de biometria no seu dispositivo, deseja cadastrar o seu acesso?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await _autenticarCliente(context);
                      },
                      child: const Text('Habilitar impressão digital'))
                ],
              ),
            );
          }
          return Container();
        });
  }

  Future<bool?> _biometriaDiaponivel() async {
    try {
      return await _autenticacaoLocal.canCheckBiometrics;
    } on PlatformException catch (erro) {
      debugPrint(erro as String);
    }
    return null;
  }
  Future<void> _autenticarCliente(context) async {
    bool autenticado = false;
    autenticado = await _autenticacaoLocal.authenticate(
      localizedReason: 'Autenticar por biometria',
      biometricOnly: true,
      useErrorDialogs: true,
    );
    Provider.of<Cliente>(context).biometria = autenticado;
  }
}
