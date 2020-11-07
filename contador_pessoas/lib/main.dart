import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Contador de Pessoas",
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Home> {
  int _people = 0;
  String _infoText = "Pode entrar!";

  _changePeople({int contPeople}) {
    setState(
      () {
        if (_people < 10 || contPeople == -1) {
          _people += contPeople;
        }

        if (_people < 0) {
          _infoText = "Mundo Invertido?!";
        } else if (_people < 10) {
          _infoText = "Pode Entrar!";
        } else {
          _infoText = "O restaurante está com lotação!";
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/restaurant.jpg',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              color: Colors.orangeAccent[700],
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "Pessoas: $_people",
                      style: GoogleFonts.balooBhaina(
                        fontWeight: FontWeight.w400,
                        fontSize: MediaQuery.of(context).size.width * 0.09,
                        color: Colors.orangeAccent[700],
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: Text(
                              "+1",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w200,
                                color: Colors.orangeAccent[700],
                                decoration: TextDecoration.none,
                              ),
                            ),
                            onPressed: () {
                              _changePeople(contPeople: 1);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: Text(
                              "-1",
                              style: GoogleFonts.balooBhaina(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w200,
                                decoration: null,
                                color: Colors.orangeAccent[700],
                              ),
                            ),
                            onPressed: () {
                              _changePeople(contPeople: -1);
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          _infoText,
                          style: GoogleFonts.balooBhaina(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent[700],
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
