import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(NimGameApp());
}

class NimGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NimGamePage(),
    );
  }
}

class NimGamePage extends StatefulWidget {
  @override
  _NimGamePageState createState() => _NimGamePageState();
}

class _NimGamePageState extends State<NimGamePage> {
  int _vitoriasJogador = 0;
  int _vitoriasCpu = 0;
  int _pedrasRestantes = 20;

  @override
  void initState() {
    super.initState();
    _carregarPlacar();
  }

  Future<void> _carregarPlacar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vitoriasJogador = prefs.getInt('vitoriasJogador') ?? 0;
      _vitoriasCpu = prefs.getInt('vitoriasCpu') ?? 0;
    });
  }

  Future<void> _salvarPlacar() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('vitoriasJogador', _vitoriasJogador);
    prefs.setInt('vitoriasCpu', _vitoriasCpu);
  }

  void _movimentoJogador(int pedrasRemovidas) {
    setState(() {
      _pedrasRestantes -= pedrasRemovidas;
      if (_pedrasRestantes <= 0) {
        _vitoriasJogador++;
        _salvarPlacar(); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Nim'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pedras Restantes: $_pedrasRestantes'),
          ElevatedButton(
            onPressed: () => _movimentoJogador(1),
            child: Text('Remover 1 pedra'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Vitórias do Jogador: $_vitoriasJogador'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Vitórias da CPU: $_vitoriasCpu'),
          ),
        ],
      ),
    );
  }
}
