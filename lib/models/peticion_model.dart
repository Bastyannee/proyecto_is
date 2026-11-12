class Peticion {

  final String id;
  final String centroSolicitante;
  final String tipoSangre;
  final int cantidad;
  String estado;

  Peticion({
    required this.id,
    required this.centroSolicitante,
    required this.tipoSangre,
    required this.cantidad,
    this.estado = 'pendiente',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'centroSolicitante': centroSolicitante,
      'tipoSangre': tipoSangre,
      'cantidad': cantidad,
      'estado': estado,
    };
  }

  factory Peticion.fromJson(Map<String, dynamic> json) {
    return Peticion(
      id: json['id'],
      centroSolicitante: json['centroSolicitante'],
      tipoSangre: json['tipoSangre'],
      cantidad: json['cantidad'],
      estado: json['estado'],
    );
  }
}