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
        } else if (_people <= 10) {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Pessoas: $_people",
                style: GoogleFonts.balooBhaina(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
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
                          color: Colors.white,
                          decoration: TextDecoration.underline,
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
                          color: Colors.white,
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
                  Text(
                    _infoText,
                    style: GoogleFonts.balooBhaina(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
