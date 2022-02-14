import 'package:provider_update/models/cliente.dart';
import 'package:provider_update/models/transferencias.dart';
import 'package:provider_update/screens/autenticacao/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/saldo.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Saldo(0),
        ),
        ChangeNotifierProvider(create: (context) => Transferencias(),
        ),
        ChangeNotifierProvider(create: (context) => Cliente(),
        ),

      ],
      child: const BytebankApp(),
    ));

class BytebankApp extends StatelessWidget {
  const BytebankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[600],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.greenAccent[700]),
      ),
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
