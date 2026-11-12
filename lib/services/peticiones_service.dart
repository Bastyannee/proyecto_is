import 'package:ing_software/models/peticion_model.dart';

class PeticionesService {
  static String centroActual = 'Hospital Regional Concepción';

  static final List<Peticion> _peticionesDB = [
    Peticion(
      id: 'PET-001',
      centroSolicitante: 'Hospital Regional Concepción',
      tipoSangre: 'O-',
      cantidad: 2,
      estado: 'pendiente',
    ),
    Peticion(
      id: 'PET-002',
      centroSolicitante: 'Clínica Las Encinas',
      tipoSangre: 'A+',
      cantidad: 5,
      estado: 'pendiente',
    ),
  ];

  List<Peticion> obtenerPeticiones() {
    return _peticionesDB;
  }

  List<Peticion> obtenerMisPeticiones() {
    return _peticionesDB.where((p) => p.centroSolicitante == centroActual).toList();
  }

  void crearPeticion({
    required String tipoSangre,
    required int cantidad,
    String? centroPersonalizado,
  }) {
    final String emisor = centroPersonalizado ?? centroActual;

    final nuevaPeticion = Peticion(
      id: 'PET-${(_peticionesDB.length + 1).toString().padLeft(3, '0')}',
      centroSolicitante: emisor,
      tipoSangre: tipoSangre,
      cantidad: cantidad,
      estado: 'pendiente',
    );
    _peticionesDB.add(nuevaPeticion);
  }

  bool cerrarPeticion(String id) {
    try {
      final peticion = _peticionesDB.firstWhere((p) => p.id == id);
      peticion.estado = 'cerrada';
      return true;
    } catch (e) {
      return false;
    }
  }
}