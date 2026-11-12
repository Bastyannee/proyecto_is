class InventarioItem {
  final String id;
  final String tipoSangre;
  final int unidadesDisponibles; // O volumen/cantidad de esta unidad específica
  final String centroOrigen;
  final DateTime fechaLlegada;
  final DateTime fechaVencimiento;
  final int volumenMl; // Ej: 450 ml

  InventarioItem({
    required this.id,
    required this.tipoSangre,
    required this.unidadesDisponibles,
    required this.centroOrigen,
    required this.fechaLlegada,
    required this.fechaVencimiento,
    required this.volumenMl,
  });
}