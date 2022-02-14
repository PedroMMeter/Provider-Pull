import 'package:provider_update/models/cliente.dart';
import 'package:provider_update/screens/dashboard/saldo.dart';
//import 'package:provider_update/models/saldo.dart';
import 'package:provider_update/screens/deposito/formulario.dart';
import 'package:provider_update/screens/transferencia/formulario.dart';
//import 'package:provider_update/screens/transferencia/lista.dart';
import 'package:provider_update/screens/transferencia/ultimas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ByteBank'),
      ),
      body: Column(
        children: [
          Consumer<Cliente>(builder: (context, cliente, child){
            if(cliente.nome.isNotEmpty){
              return Text(
                'Olá ${cliente.nome.split(' ')[0]}, seu saldo de hoje é: ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              );
            }
            return const Text(
              'Olá, seu saldo de hoje é: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            );
          }),
          Align(
            alignment: Alignment.topCenter,
            child: SaldoCard(),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Receber depósito'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return FormularioDeposito();
                      },
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Nova Transferência'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return FormularioTransferencia();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          UltimasTransferencias(),
        ],
      ),
    );
  }
}
