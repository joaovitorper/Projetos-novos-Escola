
import 'package:flutter/material.dart';

void main() {
  runApp(const MeuAplicativo());
}

// CLASSE PRINCIPAL
class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Aplicativo',
      home: const TelaInicial(),
    );
  }
}

// TELA INICIAL
class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  // Variáveis de controle
  String mensagem = 'Clique no botão para carregar.';
  bool carregando = false;

  // FUNÇÃO ASSÍNCRONA DE CARREGAMENTO
  Future<void> carregarInformacao() async {

    // Altera a mensagem para carregando
    setState(() {
      mensagem = 'Carregando...';
      carregando = true;
    });

    // Aguarda 3 segundos
    await Future.delayed(
      const Duration(seconds: 3),
    );

    // Verifica se a tela continua ativa
    if (!mounted) return;

    // Exibe a mensagem de sucesso
    setState(() {
      mensagem = 'Informação carregada com sucesso!';
      carregando = false;
    });
  }

  // FUNÇÃO PARA LIMPAR A MENSAGEM
  void limparMensagem() {
    setState(() {
      mensagem = 'Clique no botão para carregar.';
      carregando = false;
    });
  }

  // CONSTRUÇÃO DA INTERFACE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // FUNDO AZUL OCEANO
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF102A43),
              Color(0xFF1D4E89),
              Color(0xFF247BA0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              // TÍTULO
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'Meu Aplicativo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),

              // ÍCONE
              Icon(
                carregando
                    ? Icons.hourglass_top
                    : Icons.cloud_download,
                color: const Color(0xFFD9EAF2),
                size: 85,
              ),

              const SizedBox(height: 30),

              // MENSAGEM
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Text(
                  mensagem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // BOTÃO CARREGAR INFORMAÇÃO
              ElevatedButton(
                onPressed: carregando
                    ? null
                    : carregarInformacao,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF247BA0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: const Text(
                  'Carregar informação',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // BOTÃO LIMPAR MENSAGEM
              ElevatedButton(
                onPressed: limparMensagem,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9EAF2),
                  foregroundColor: const Color(0xFF102A43),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: const Text(
                  'Limpar mensagem',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),

              // RODAPÉ
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Simulador de carregamento Flutter',
                  style: TextStyle(
                    color: Color(0xFFD9EAF2),
                    fontSize: 13,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
