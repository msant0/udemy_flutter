import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
//importação para utilizar o json decode
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

class Borderside {}

Future<Map> _getData() async {
  var request = "https://api.hgbrasil.com/finance?format=json&key=de2493b3";
  http.Response response = await http.get(request);
  //json.decode vai converter de uma string para um map JSON
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Text Editing Controllers
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAllCoins() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAllCoins();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAllCoins();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAllCoins();
      return;
    }

    double euro = double.parse(text);
    dolarController.text = (euro * this.euro).toStringAsFixed(2);
    realController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: AutoSizeText(
          "\$ Conversor de Moedas \$",
          style: GoogleFonts.balooBhaina(
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: _getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Center(
                  child: AutoSizeText(
                    "Erro no servidor de conversão..",
                    style: GoogleFonts.balooBhaina(
                      color: Colors.amber,
                    ),
                    presetFontSizes: [22.0, 24.0],
                  ),
                ),
              );
            case ConnectionState.waiting:
              return Center(
                child: AutoSizeText(
                  "Carregando Dados...",
                  style: GoogleFonts.balooBhaina(
                    color: Colors.amber,
                  ),
                  presetFontSizes: [22.0, 24.0],
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: AutoSizeText("Erro ao carregar dados.."),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: MediaQuery.of(context).size.height * 0.2,
                        color: Colors.amber,
                      ),
                      BuildTextField(
                        label: "Reais",
                        prefix: "R\$",
                        coinController: realController,
                        changedCoin: _realChanged,
                      ),
                      Divider(),
                      BuildTextField(
                        label: "Doláres",
                        prefix: "US\$",
                        coinController: dolarController,
                        changedCoin: _dolarChanged,
                      ),
                      Divider(),
                      BuildTextField(
                        label: "Euros",
                        prefix: "€",
                        coinController: euroController,
                        changedCoin: _euroChanged,
                      ),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

class BuildTextField extends StatelessWidget {
  final String label;
  final String prefix;
  TextEditingController coinController = new TextEditingController();
  Function changedCoin;

  BuildTextField({
    Key key,
    @required this.label,
    @required this.prefix,
    @required this.coinController,
    @required this.changedCoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: coinController,
      onChanged: changedCoin,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.balooBhaina(
          color: Colors.amber,
        ),
        prefixText: prefix,
      ),
      style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0,
      ),
    );
  }
}
