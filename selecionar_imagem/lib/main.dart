
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

  Future<void> selecionarImagem() async {
    final ImagePicker picker = ImagePicker();

    final XFile? arquivo = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (arquivo == null) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Aplicativo de Imagens'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagem != null)
              Image.file(
                imagem!,
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              )
            else
              const Text('Nenhuma imagem selecionada'),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: selecionarImagem,
              child: const Text('Selecionar imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
