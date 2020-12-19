import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //TEXT EDITING CONTROLLERS
  TextEditingController novaTarefaController = new TextEditingController();

  // final itemsList = List<String>.generate(10, (n) => "List item");
  List _listaTarefas = [];
  Map<String, dynamic> _ultimaTarefaRemovida;
  int _posicaoUltimaTarefaRemovida;

  @override
  void initState() {
    super.initState();

    _populaListaTarefas();
  }

  _populaListaTarefas() async {
    try {
      var response = await _lerDadosListaTarefas();
      setState(
        () {
          _listaTarefas = json.decode(response);
        },
      );
    } catch (error) {
      return null;
    }
  }

  Future<Null> _refresh() async {
    Future.delayed(const Duration(milliseconds: 1000));

    setState(
      () {
        _listaTarefas.sort(
          (a, b) {
            if (a["tarefaRealizada"] && !b["tarefaRealizada"])
              return 1;
            else if (!a["tarefaRealizada"] && b["tarefaRealizada"])
              return -1;
            else
              return 0;
          },
        );
      },
    );
  }

  Future<File> _buscarArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/data.json");
  }

  Future<String> _lerDadosListaTarefas() async {
    try {
      final file = await _buscarArquivo();
      return file.readAsString();
    } catch (error) {
      return null;
    }
  }

  Future<File> _salvarListaTarefas() async {
    String data = json.encode(_listaTarefas);

    final file = await _buscarArquivo();
    return file.writeAsString(data);
  }

  @override
  Widget build(BuildContext context) {
    //deixar o título do App Bar centralizado
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text(
          "Lista de Tarefas",
          style: GoogleFonts.balooBhaina(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: new Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  //Exemplo de criação de um TextField para inserção de uma nova tarefa
                  child: TextField(
                    controller: novaTarefaController,
                    decoration: new InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: GoogleFonts.balooBhaina(),
                    ),
                  ),
                  // ------------------- //
                ),
                RaisedButton(
                  onPressed: () => {
                    if (novaTarefaController.text == "")
                      {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(
                              const Duration(milliseconds: 1000),
                              () {
                                Navigator.of(context).pop(true);
                              },
                            );

                            return new AlertDialog(
                              title: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                                child: Image.asset("assets/confused.png"),
                              ),
                              content: Text(
                                "Preencha o campo de nova tarefa!",
                                style: GoogleFonts.balooBhaina(),
                              ),
                            );
                          },
                        )
                      }
                    else
                      {
                        setState(
                          () {
                            Map<String, dynamic> novaTarefa = Map();
                            novaTarefa["titulo"] = novaTarefaController.text;
                            novaTarefa["tarefaRealizada"] = false;
                            _listaTarefas.add(novaTarefa);
                            _salvarListaTarefas();

                            // apagar os dados para uma nova inserção
                            novaTarefaController.clear();
                          },
                        ),
                      }
                  },
                  color: Colors.blueAccent,
                  child: Text(
                    "ADD",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Expanded(
              // Exemplo de criação de um listView builder
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: _listaTarefas.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key:
                          Key(DateTime.now().millisecondsSinceEpoch.toString()),
                      background: new Container(
                        color: Colors.redAccent,
                        child: Align(
                          alignment: Alignment(-0.9, 0.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      direction: DismissDirection.startToEnd,
                      child: CheckboxListTile(
                        title: Text(
                          _listaTarefas[index]["titulo"],
                          style: GoogleFonts.balooBhaina(),
                        ),
                        value: _listaTarefas[index]["tarefaRealizada"],
                        secondary: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                          height: MediaQuery.of(context).size.width * 0.07,
                          child: Image.asset(
                            !_listaTarefas[index]["tarefaRealizada"]
                                ? "assets/attention.png"
                                : "assets/awesome.png",
                          ),
                        ),
                        onChanged: (valorSelecionado) => {
                          setState(
                            () {
                              _listaTarefas[index]["tarefaRealizada"] =
                                  valorSelecionado;
                            },
                          ),
                        },
                      ),
                      onDismissed: (direction) {
                        _ultimaTarefaRemovida = Map.from(_listaTarefas[index]);
                        _posicaoUltimaTarefaRemovida = index;
                        _listaTarefas.removeAt(index);
                        _salvarListaTarefas();

                        setState(
                          () {
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              new SnackBar(
                                content: Text(
                                    "Tarefa ${_ultimaTarefaRemovida["titulo"]} removida"),
                                duration: Duration(milliseconds: 1000),
                                action: SnackBarAction(
                                  label: "Desfazer",
                                  onPressed: () => {
                                    _listaTarefas.insert(
                                        _posicaoUltimaTarefaRemovida,
                                        _ultimaTarefaRemovida),
                                    _salvarListaTarefas()
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // ------------------ //
            )
          ],
        ),
      ),
    );
  }
}
