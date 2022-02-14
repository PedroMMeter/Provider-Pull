import 'dart:io';
import 'package:provider_update/components/biometria.dart';
import 'package:provider_update/components/form_inputs.dart';
import 'package:provider_update/models/cliente.dart';
import 'package:provider_update/screens/dashboard/dashboard.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Registrar extends StatelessWidget {
  //step 1
  final _formUserData = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _celularController = TextEditingController();
  final _nascimentoController = TextEditingController();

  //step 2
  final _formUserAdress = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _bairroController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();

  //step 3
  final _formUserAuth = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _picker = ImagePicker();

  Registrar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Cliente'),
        ),
        body: Consumer<Cliente>(
          builder: (context, cliente, child) {
            return Stepper(
              currentStep: cliente.stepAtual,
              onStepContinue: () {
                final functions = [
                  _salvarStep1,
                  _salvarStep2,
                  _salvarStep3,
                ];
                return functions[cliente.stepAtual](context);
              },
              onStepCancel: () {
                cliente.stepAtual =
                    cliente.stepAtual > 0 ? cliente.stepAtual - 1 : 0;
              },
              steps: _construirSteps(context, cliente),
              controlsBuilder: (context, ControlsDetails controls) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text(
                          'Salvar',
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 20)),
                      ElevatedButton(
                        onPressed: controls.onStepCancel,
                        child: const Text('Voltar'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }

  void _salvarStep1(context) {
    if (_formUserData.currentState!.validate()) {
      Cliente cliente = Provider.of<Cliente>(
        context,
        listen: false,
      );
      cliente.nome = _nomeController.text;
      _proximoStep(context);
    }
  }

  void _salvarStep2(context) {
    if (_formUserAdress.currentState!.validate()) {
      _proximoStep(context);
    }
  }

  void _salvarStep3(context) {
    if (_formUserAuth.currentState!.validate() &&
        Provider.of<Cliente>(context, listen: false).imageRG != null) {
      FocusScope.of(context).unfocus();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
          (route) => false);
    }
  }

  List<Step> _construirSteps(context, cliente) {
    List<Step> step = [
      Step(
        title: const Text('Dados Pessoais'),
        isActive: cliente.stepAtual >= 0,
        content: Form(
          key: _formUserData,
          child: Column(
            children: [
              Field(
                'Nome',
                255,
                controller: _nomeController,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Insira o seu nome';
                  }
                  if (value.length < 2) {
                    return 'Nome inválido';
                  }
                  if (!value.contains(' ')) {
                    return 'Informe ao menos o sobrenome';
                  }
                  return null;
                },
              ),
              Field(
                'E-mail',
                255,
                controller: _emailController,
                type: TextInputType.emailAddress,
                validation: (value) =>
                    Validator.email(value) ? 'Email inválido' : null,
              ),
              Field(
                'CPF',
                14,
                controller: _cpfController,
                type: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter()
                ],
                validation: (value) =>
                    Validator.cpf(value) ? "CPF inválido" : null,
              ),
              Field(
                'Celular',
                15,
                controller: _celularController,
                type: TextInputType.phone,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                validation: (value) => Validator.phone(value)
                    ? 'Número telefonico inválido'
                    : null,
              ),
              Field(
                'Data de Nascimento',
                10,
                controller: _nascimentoController,
                type: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter(),
                ],
                validation: ((value) =>
                    Validator.date(value) ? 'Insira uma data válida' : null),
                /*Padding(
                padding: const EdgeInsets.all(20),
                child: DateTimePicker(
                  controller: _nascimentoController,
                  type: DateTimePickerType.date,
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Nascimento',
                  dateMask: 'dd/MM/yyyy',
                  validator: (value) =>
                      Validator.date(value) ? 'Insira uma data válida' : null,
                ),
              ),*/
              )
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Endereço'),
        isActive: cliente.stepAtual >= 1,
        content: Form(
          key: _formUserAdress,
          child: Column(
            children: [
              Field(
                'CEP',
                9,
                controller: _cepController,
                type: TextInputType.number,
                validation: (value) =>
                    Validator.cep(value) ? 'CEP inválido' : null,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: DropdownButtonFormField<String>(
                  hint: const Text('Estado'),
                  onChanged: (String? estadoSelecionado) {
                    _estadoController.text = estadoSelecionado!;
                  },
                  items: Estados.listaEstados.map((String estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Text(estado),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione um estado';
                    }
                    return null;
                  },
                ),
              ),
              Field(
                'Cidade',
                255,
                controller: _cidadeController,
                validation: (value) {
                  if (value!.length < 3) {
                    return 'Informe sua cidade';
                  }
                  return null;
                },
              ),
              Field(
                'Bairro',
                255,
                controller: _bairroController,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o bairro';
                  }
                  return null;
                },
              ),
              Field(
                'Logradouro',
                255,
                controller: _logradouroController,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o logradouro';
                  }
                  return null;
                },
              ),
              Field(
                'Número do edifício',
                10,
                controller: _numeroController,
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o número';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Senha'),
        isActive: cliente.stepAtual >= 1,
        content: Form(
          key: _formUserAuth,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                controller: _senhaController,
                maxLength: 16,
                obscureText: true,
                validator: (value) {
                  if (value!.length < 8) {
                    return 'Senha muito curta';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                ),
                controller: _confirmarSenhaController,
                maxLength: 16,
                obscureText: true,
                validator: (value) {
                  if (value != _senhaController.text) {
                    return 'As senhas estão diferentes';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  const Text('Para prosseguir com o seu cadastro é necessario que tenhamos uma foto do seu RG'),
                  ElevatedButton(
                    onPressed: () => _capturarRg(cliente),
                    child: const Text(
                      'Tirar Foto do RG',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              _jaEnviouRg(context) ? _imagemRg(context) : _pedidoRg(context),
              Biometria(),
            ],
          ),
        ),
      ),
    ];
    return step;
  }

  _proximoStep(context) {
    Cliente cliente = Provider.of<Cliente>(
      context,
      listen: false,
    );
    irPara(cliente.stepAtual + 1, cliente);
  }

  irPara(int step, cliente) {
    cliente.stepAtual = step;
  }

  _capturarRg(cliente) async {
    final pickerImage = await _picker.pickImage(source: ImageSource.camera);
    cliente.imageRG = File(pickerImage!.path);
  }

  bool _jaEnviouRg(context) {
    if (Provider.of<Cliente>(context).imageRG != null) {
      return true;
    }
    return false;
  }

  Image _imagemRg(context) {
    return Image.file(Provider.of<Cliente>(context).imageRG as File);
  }

  Column _pedidoRg(context) {
    return Column(children: const [
      Text(
        'Foto do RG pendente',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}
