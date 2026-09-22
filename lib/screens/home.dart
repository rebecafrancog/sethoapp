import 'package:flutter/material.dart';
import '../models/model_user.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  final UserRole userRole;

  const HomeScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final isOng = userRole == UserRole.ong;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOng ? 'Painel da Instituição' : 'Oportunidades de Apoio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: isOng
          ? FloatingActionButton.extended(
              onPressed: () {
                // Abre modal/tela de criação de vaga solidária
              },
              backgroundColor: Colors.teal,
              icon: const Icon(Icons.add),
              label: const Text('Publicar Causa'),
            )
          : null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        isOng ? Icons.apartment : Icons.volunteer_activism,
                        size: 40,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perfil: ${userRole.label}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isOng
                                ? 'Gerencie candidaturas e publique novas ações.'
                                : 'Explore projetos e conecte-se a causas sociais.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ações em Destaque',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.pets, color: Colors.white),
                ),
                title: const Text('Resgate e Acolhimento Animal'),
                subtitle: const Text('Ajuda necessária aos sábados | 4 vagas abertas'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: Text(isOng ? 'Editar' : 'Candidatar-se'),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.school, color: Colors.white),
                ),
                title: const Text('Reforço Escolar Comunitário'),
                subtitle: const Text('Aulas remotas de leitura | 2 vagas abertas'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: Text(isOng ? 'Editar' : 'Candidatar-se'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}