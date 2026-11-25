import 'package:flutter/material.dart';
import 'services/notificacao_services.dart';
 
final notificacaoService = NotificacaoServices();
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await notificacaoService.inicializar();
 
  await notificacaoService.solicitarPermissao();
 
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
 
class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificações')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await notificacaoService.mostrarNotificacao();
          },
          child: const Text('Mostrar notificação'),
        ),
      ),
    );
  }
}