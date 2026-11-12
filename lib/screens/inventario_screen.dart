import 'package:flutter/material.dart';
import 'package:ing_software/models/inventario_model.dart';
import 'package:ing_software/screens/detalle_bolsas_screen.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  String _tipoSeleccionado = 'O-';

  /// mocks de ejemplo para mostrar por pantalla
  final List<InventarioItem> _inventarioMock = [
    InventarioItem(id: 'B001', tipoSangre: 'O-', unidadesDisponibles: 1, centroOrigen: 'Hospital Regional', fechaLlegada: DateTime.now().subtract(const Duration(days: 5)), fechaVencimiento: DateTime.now().add(const Duration(days: 10)), volumenMl: 450),
    InventarioItem(id: 'B002', tipoSangre: 'O-', unidadesDisponibles: 1, centroOrigen: 'Centro de Sangre', fechaLlegada: DateTime.now().subtract(const Duration(days: 2)), fechaVencimiento: DateTime.now().add(const Duration(days: 3)), volumenMl: 400),
    InventarioItem(id: 'B003', tipoSangre: 'O+', unidadesDisponibles: 1, centroOrigen: 'Clínica Las Encinas', fechaLlegada: DateTime.now().subtract(const Duration(days: 10)), fechaVencimiento: DateTime.now().add(const Duration(days: 25)), volumenMl: 450),
    InventarioItem(id: 'B004', tipoSangre: 'O+', unidadesDisponibles: 1, centroOrigen: 'Hospital Regional', fechaLlegada: DateTime.now().subtract(const Duration(days: 1)), fechaVencimiento: DateTime.now().add(const Duration(days: 30)), volumenMl: 500),
    InventarioItem(id: 'B005', tipoSangre: 'A+', unidadesDisponibles: 1, centroOrigen: 'Hospital Regional', fechaLlegada: DateTime.now().subtract(const Duration(days: 4)), fechaVencimiento: DateTime.now().add(const Duration(days: 8)), volumenMl: 450),
    InventarioItem(id: 'B006', tipoSangre: 'AB+', unidadesDisponibles: 1, centroOrigen: 'Centro de Sangre', fechaLlegada: DateTime.now().subtract(const Duration(days: 8)), fechaVencimiento: DateTime.now().add(const Duration(days: 2)), volumenMl: 350),
  ];

  List<String> _obtenerCompatibles(String tipo) {
    switch (tipo) {
      case 'O-': return ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'];
      case 'O+': return ['O+', 'A+', 'B+', 'AB+'];
      case 'A-': return ['A-', 'A+', 'AB-', 'AB+'];
      case 'A+': return ['A+', 'AB+'];
      case 'B-': return ['B-', 'B+', 'AB-', 'AB+'];
      case 'B+': return ['B+', 'AB+'];
      case 'AB-': return ['AB-', 'AB+'];
      case 'AB+': return ['AB+'];
      default: return [];
    }
  }

  int _obtenerStockDe(String tipoSangre) {
    return _inventarioMock.where((i) => i.tipoSangre == tipoSangre).length;
  }

  Color _obtenerColorStock(int unidades) {
    if (unidades >= 2) return Colors.green.shade300;
    if (unidades == 1) return Colors.amber.shade300;
    return Colors.red.shade300;
  }

  @override
  Widget build(BuildContext context) {
    final tiposUnicos = _inventarioMock.map((e) => e.tipoSangre).toSet().toList();
    final compatibles = _obtenerCompatibles(_tipoSeleccionado);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario y Compatibilidad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stock Actual de Inventario ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tiposUnicos.length,
                itemBuilder: (context, index) {
                  final tipo = tiposUnicos[index];
                  final totalUnidades = _obtenerStockDe(tipo);
                  final colorCard = _obtenerColorStock(totalUnidades);

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleBolsasScreen(
                            tipoSangre: tipo,
                            todasLasBolsas: _inventarioMock,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      child: Container(
                        width: 140,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: colorCard, width: 4)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tipo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text('$totalUnidades bolsas', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            const Text('Ver detalle ➔', style: TextStyle(fontSize: 10, color: Colors.blue)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 40),
            const Text(
              'Consulta de Tabla de Compatibilidad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Tipo de sangre del paciente: '),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _tipoSeleccionado,
                  items: ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (nuevoValor) {
                    if (nuevoValor != null) {
                      setState(() {
                        _tipoSeleccionado = nuevoValor;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Tipos compatibles para $_tipoSeleccionado:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: compatibles.map((t) {
                final stock = _obtenerStockDe(t);
                final colorChip = _obtenerColorStock(stock);
                return Chip(
                  label: Text('$t ($stock disp.)'),
                  backgroundColor: colorChip,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}