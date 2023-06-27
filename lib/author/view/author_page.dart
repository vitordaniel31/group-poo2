import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Author {
  Author({
    required this.name,
    required this.description,
    required this.github,
    required this.photoPath,
  });

  final String name;
  final String description;
  final String github;
  final String photoPath;
}

List<Author> authors = [
  Author(
    name: 'José Pereira de Araujo Marques',
    description:
        'Desenvolvedor, Técnico em Informática, Caicoense e Brasileiro.',
    github: 'https://github.com/joseP1432',
    photoPath: 'https://avatars.githubusercontent.com/u/74608458?v=4',
  ),
  Author(
    name: 'Ketlly Azevedo de Medeiros',
    description:
        'Desenvolvedora, Técnica em Informática, Caicoense e Brasileira.',
    github: 'https://github.com/ketwy',
    photoPath:
        'https://media.licdn.com/dms/image/D4D03AQFF-cUfG5olOA/profile-displayphoto-shrink_800_800/0/1669578824399?e=1693440000&v=beta&t=1w_LctYRKQ_uPUvz0fesOv2WxOpLji-n3CR3jgyxjY0',
  ),
  Author(
    name: 'Vitor Daniel Lócio Medeiros',
    description:
        'Desenvolvedor, Técnico em Informática, Paraibano e Brasileiro',
    github: 'https://github.com/vitordaniel31',
    photoPath: 'https://avatars.githubusercontent.com/u/51799954?v=4',
  ),
];

class AuthorPage extends StatelessWidget {
  const AuthorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autores do Projeto'),
      ),
      body: ListView.builder(
        itemCount: authors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: AuthorCard(author: authors[index]),
          );
        },
      ),
    );
  }
}

class AuthorCard extends StatelessWidget {
  const AuthorCard({required this.author, super.key});

  final Author author;

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                author.photoPath,
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              author.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              author.description,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _launchUrl(author.github),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text('GitHub'),
            ),
          ],
        ),
      ),
    );
  }
}
