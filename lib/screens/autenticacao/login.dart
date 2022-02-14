import 'package:provider_update/components/mensagem.dart';
import 'package:provider_update/screens/autenticacao/registrar.dart';
import 'package:provider_update/screens/dashboard/dashboard.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatelessWidget {
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/bytebank_logo.png',
                  width: 200,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  height: 430,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _construirFormulario(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* bool _validaCampos() {
    if (_cpfController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }*/
  Widget _construirFormulario(context) {
    return Form(
      child: Column(
        children: [
          const Text(
            'Faça o seu Login:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'CPF',
            ),
            maxLength: 14,
            keyboardType: TextInputType.number,
            controller: _cpfController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return 'Informe o CPF';
              }
              if (value.length < 14) {
                return 'CPF inválido';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Senha',
            ),
            maxLength: 16,
            controller: _passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Informe uma Senha';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if(_cpfController.text == '123.456.789-01' && _passwordController.text =='abc123'){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(),
                        ),
                            (route) => false);
                  } else {
                    exibirAlerta(
                      context: context,
                      titulo: 'ATENÇÃO',
                      content : 'CPF ou Senha Incorretos!',
                    );
                  }
                }
              },
              child: const Text('Continuar'),
              style: OutlinedButton.styleFrom(
                primary: Colors.green[900],
                side:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Esqueci minha senha',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.green[900],
              side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Registrar())
              );
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
      key: _formKey,
    );
  }
}
