import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pessoa.dart';

class ApiService {
  static const String baseUrl = 'https://exemplospringrestapi.onrender.com/api/v1/pessoas';

  // GET: Listar todos os pessoas
  static Future<List<Pessoa>> getPessoas() async {
    final response = await http.get(Uri.parse(baseUrl));
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((pessoa) => Pessoa.fromJson(pessoa)).toList();
    } else {
      throw Exception('Falha ao carregar pessoas');
    }
  }

  // POST: Adicionar novo pessoa
  static Future<Pessoa> addPessoa(Pessoa pessoa) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      //body: json.encode(pessoa.toJson()),
      body: json.encode(pessoa.toJsonInsert())
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Pessoa.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao adicionar pessoa');
    }
  }

  // DELETE: Remover pessoa
  static Future<void> deletePessoa(int id) async {
    //final response = await http.delete(Uri.parse('$baseUrl/$id'));
    final response = await http.get(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar pessoa');
    }
  }
}