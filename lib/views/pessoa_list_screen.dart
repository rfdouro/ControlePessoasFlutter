import 'package:cadposts/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pessoa.dart';
import '../services/api_service.dart';
import 'add_pessoa_screen.dart';

class PessoaListScreen extends StatefulWidget {
  const PessoaListScreen({Key? key}) : super(key: key);

  @override
  _PessoaListScreenState createState() => _PessoaListScreenState();
}

class _PessoaListScreenState extends State<PessoaListScreen> {
  late Future<List<Pessoa>> futurePessoas;

  @override
  void initState() {
    super.initState();
    futurePessoas = ApiService.getPessoas();
  }

  void _refreshPessoas() {
    setState(() {
      futurePessoas = ApiService.getPessoas();
    });
  }

  Future<void> _deletePessoa(int id) async {
    try {
      await ApiService.deletePessoa(id);
      _refreshPessoas();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pessoa excluída com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: ${e.toString()}')),
      );
    }
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir esta pessoa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePessoa(id);
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pessoas'),
        actions: [
          // Botão para alternar tema
          Consumer<ThemeManager>(
            builder: (context, themeManager, child) {
              return IconButton(
                icon: Icon(
                  themeManager.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  themeManager.toggleTheme(
                    themeManager.themeMode != ThemeMode.dark,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPessoas,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPessoaScreen()),
          );
          _refreshPessoas();
        },
      ),
      body: FutureBuilder<List<Pessoa>>(
        future: futurePessoas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma pessoa encontrada'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Pessoa pessoa = snapshot.data![index];
              return ListTile(
                title: Text(pessoa.id.toString()),
                subtitle: Text(pessoa.nome),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(pessoa.id!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
