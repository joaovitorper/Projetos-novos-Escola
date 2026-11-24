import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
 
void main() {
  runApp(const MyApp());
}
 
int calcular(int numero) {
  int resultado = 0;
 
  for (int i = 0; i < numero; i++) {
    resultado += i;
  }
 
  return resultado;
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TelaCalculo(),
    );
  }
}
 
class TelaCalculo extends StatefulWidget {
  const TelaCalculo({super.key});
 
  @override
  State<TelaCalculo> createState() => _TelaCalculoState();
}
 
class _TelaCalculoState extends State<TelaCalculo> {
  String resultado = 'Nenhum cálculo realizado';
 
  Future<void> executarCalculo() async {
    setState(() {
      resultado = 'Calculando...';
    });
 
    final valor = await compute(calcular, 1000000);
 
    setState(() {
      resultado = 'Resultado: $valor';
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              resultado,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: executarCalculo,
              child: const Text('Executar cálculo'),
            ),
          ],
        ),
      ),
    );
  }
}
 