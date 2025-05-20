class Pessoa {
  final int? id;
  final String nome;

  Pessoa({this.id, required this.nome});

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
      };
  
  Map<String, dynamic> toJsonInsert() => {
        'nome': nome,
      };
}