
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SelecionarImagem(),
  ));
}

class SelecionarImagem extends StatefulWidget {
  const SelecionarImagem({super.key});

  @override
  State<SelecionarImagem> createState() =>
      _SelecionarImagemState();
}

class _SelecionarImagemState extends State<SelecionarImagem> {
  File? imagem;

  // Selecionar imagem da galeria
  Future<void> selecionarImagem() async {
    final ImagePicker picker = ImagePicker();

    final XFile? arquivo = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (arquivo == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma imagem foi selecionada.'),
        ),
      );
      return;
    }

    setState(() {
      imagem = File(arquivo.path);
    });
  }

  // Limpar imagem selecionada
  void limparImagem() {
    setState(() {
      imagem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E1DD),

      appBar: AppBar(
        title: const Text('Meu Aplicativo de Imagens'),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Exibição da imagem
            if (imagem != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  imagem!,
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  color: const Color(0xFF778DA9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 70,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nenhuma imagem selecionada',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Botão selecionar imagem
            ElevatedButton.icon(
              onPressed: selecionarImagem,
              icon: const Icon(Icons.photo_library),
              label: const Text('Selecionar imagem'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF415A77),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Botão limpar imagem
            ElevatedButton.icon(
              onPressed: imagem != null ? limparImagem : null,
              icon: const Icon(Icons.delete),
              label: const Text('Limpar imagem'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B263B),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
