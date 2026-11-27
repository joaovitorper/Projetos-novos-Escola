
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificacoes =
    FlutterLocalNotificationsPlugin();

final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
  );

  await notificacoes.initialize(
    settings: settings,
  );

  await notificacoes
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  runApp(const MyApp());
}

class Lembrete {
  final int id;
  final String descricao;

  Lembrete({
    required this.id,
    required this.descricao,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }

  factory Lembrete.fromJson(Map<String, dynamic> json) {
    return Lembrete(
      id: json['id'],
      descricao: json['descricao'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meus Lembretes',
      scaffoldMessengerKey: messengerKey,
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController descricaoController =
      TextEditingController();

  final TextEditingController intervaloController =
      TextEditingController(text: '1');

  List<Lembrete> lembretes = [];

  @override
  void initState() {
    super.initState();
    carregarLembretes();
  }

  Future<void> carregarLembretes() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString('lembretes');

    if (dados != null) {
      final List lista = jsonDecode(dados);

      if (!mounted) return;

      setState(() {
        lembretes = lista
            .map((item) => Lembrete.fromJson(item))
            .toList();
      });
    }
  }

  Future<void> salvarLembretes() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = jsonEncode(
      lembretes.map((item) => item.toJson()).toList(),
    );

    await prefs.setString('lembretes', dados);
  }

  Future<void> programarLembrete() async {
    final descricao = descricaoController.text.trim();

    final intervalo =
        int.tryParse(intervaloController.text.trim());

    if (descricao.isEmpty || intervalo == null || intervalo <= 0) {
      messengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(
            'Digite um lembrete e um intervalo válido!',
          ),
        ),
      );
      return;
    }

    final id = DateTime.now()
        .microsecondsSinceEpoch
        .remainder(2147483647);

    final novoLembrete = Lembrete(
      id: id,
      descricao: descricao,
    );

    final horario = tz.TZDateTime.now(tz.local).add(
      Duration(minutes: intervalo),
    );

    const detalhes = NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_lembretes',
        'Meus Lembretes',
        channelDescription: 'Notificações dos lembretes',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    try {
      await notificacoes.zonedSchedule(
        id: id,
        title: 'Você tem um lembrete!',
        body: descricao,
        scheduledDate: horario,
        notificationDetails: detalhes,
        androidScheduleMode:
            AndroidScheduleMode.inexactAllowWhileIdle,
        payload: id.toString(),
      );

      setState(() {
        lembretes.add(novoLembrete);
      });

      await salvarLembretes();

      descricaoController.clear();

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            'Notificação programada para daqui a $intervalo minuto(s)!',
          ),
        ),
      );
    } catch (e) {
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Erro ao programar notificação: $e'),
        ),
      );
    }
  }

  Future<void> cancelarLembretes() async {
    await notificacoes.cancelAll();

    setState(() {
      lembretes.clear();
    });

    await salvarLembretes();

    messengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('Todos os lembretes foram cancelados!'),
      ),
    );
  }

  @override
  void dispose() {
    descricaoController.dispose();
    intervaloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Lembretes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Criar novo lembrete',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: 'Digite seu lembrete',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: intervaloController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Intervalo em minutos',
                hintText: 'Exemplo: 5',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: programarLembrete,
                child: const Text('Programar lembrete'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cancelarLembretes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancelar lembretes'),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Meus lembretes cadastrados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: lembretes.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum lembrete cadastrado.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: lembretes.length,
                      itemBuilder: (context, index) {
                        final lembrete = lembretes[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.notifications_active,
                              color: Colors.blue,
                            ),
                            title: Text(lembrete.descricao),
                            subtitle: const Text(
                              'Lembrete programado',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
