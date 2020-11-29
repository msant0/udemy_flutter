import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = new TextEditingController();
  TextEditingController heightController = new TextEditingController();
  String _infoText = "Informe seus dados!";
  bool refresh = false;

  //GLOBAL KEYS
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _reload() {
    setState(
      () {
        refresh = true;
        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            setState(
              () {
                refresh = false;
              },
            );
          },
        );
        weightController.text = "";
        heightController.text = "";
        _infoText = "Informe seus dados!";
        _formKey = GlobalKey<FormState>();
      },
    );
  }

  void _calculateIMC({double weight, double height}) {
    double imc = weight / (height * height);

    if (imc < 18.6) {
      _infoText = "Abaixo do peso (${imc.toStringAsPrecision(3)})";
    } else if (imc >= 18.6 && imc < 24.9) {
      _infoText = "Peso Ideal (${imc.toStringAsPrecision(3)})";
    } else if (imc >= 24.9 && imc < 29.0) {
      _infoText = "Levemente acima do peso (${imc.toStringAsPrecision(3)})";
    } else if (imc >= 29.9 && imc < 34.9) {
      _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(3)})";
    } else if (imc >= 34.9 && imc < 39.9) {
      _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(3)})";
    } else {
      _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(3)})";
    }

    setState(
      () {
        _infoText = _infoText;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Calculadora de IMC"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _reload();
            },
          ),
        ],
        backgroundColor: Colors.green[400],
      ),
      body: refresh
          ? null
          : Container(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.person_outlined,
                      color: Colors.green[500],
                      size: MediaQuery.of(context).size.height * 0.2,
                    ),
                    TextFormField(
                      controller: weightController,
                      validator: (value) {
                        if (value.isEmpty) return 'Campo peso é obrigatório!';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Peso (kg)",
                        labelStyle: TextStyle(
                          color: Colors.green[400],
                          fontSize: 27.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: heightController,
                      validator: (value) {
                        if (value.isEmpty) return 'Campo altura é obrigatório!';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Altura (M)",
                        labelStyle: TextStyle(
                          color: Colors.green[400],
                          fontSize: 27.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              var weight = double.parse(weightController.text);
                              var height = double.parse(heightController.text);
                              _calculateIMC(weight: weight, height: height);
                            }
                          },
                          child: AutoSizeText(
                            "Calcular",
                            presetFontSizes: [23.0, 26.0],
                          ),
                          color: Colors.green[400],
                          textColor: Colors.white),
                    ),
                    AutoSizeText(
                      _infoText,
                      style: TextStyle(
                        color: Colors.green[400],
                      ),
                      textAlign: TextAlign.center,
                      presetFontSizes: [23.0, 26.0],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
