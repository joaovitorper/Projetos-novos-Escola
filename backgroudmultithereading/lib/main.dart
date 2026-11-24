import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TelaPrincipal(),
    );
  }
}


class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});


  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}


class _TelaPrincipalState extends State<TelaPrincipal> {
  String mensagem = 'Clique no botão para iniciar';


  Future<void> processar() async {
    setState(() {
      mensagem = 'Processando...';
    });


    await Future.delayed(const Duration(seconds: 3));


    setState(() {
      mensagem = 'Processamento concluído!';
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background e Multithreading')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensagem, style: const TextStyle(fontSize: 20)),


            const SizedBox(height: 20),


            ElevatedButton(
              onPressed: processar,
              child: const Text('Processar'),
              
            ),
            const SizedBox(height: 10),
 
            ElevatedButton(
            onPressed: () {
                print('Outro botão pressionado');
            },
            child: const Text('Outro botão'),
            ),
          ],
        ),
      ),
    );
  }
}