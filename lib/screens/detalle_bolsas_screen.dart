// lib/screens/detalle_bolsas_screen.dart
import 'package:flutter/material.dart';
import 'package:ing_software/models/inventario_model.dart';

class DetalleBolsasScreen extends StatefulWidget {
  final String tipoSangre;
  final List<InventarioItem> todasLasBolsas;

  const DetalleBolsasScreen({
    super.key,
    required this.tipoSangre,
    required this.todasLasBolsas,
  });

  @override
  State<DetalleBolsasScreen> createState() => _DetalleBolsasScreenState();
}

class _DetalleBolsasScreenState extends State<DetalleBolsasScreen> {
  String _criterioOrden = 'vencimiento'; // 'vencimiento', 'llegada', 'volumen'

  @override
  Widget build(BuildContext context) {
    // Filtrar solo las bolsas que coincidan con este tipo de sangre
    List<InventarioItem> bolsasFiltradas = widget.todasLasBolsas
        .where((b) => b.tipoSangre == widget.tipoSangre)
        .toList();

    // Aplicar ordenamiento según el filtro seleccionado
    if (_criterioOrden == 'vencimiento') {
      bolsasFiltradas.sort((a, b) => a.fechaVencimiento.compareTo(b.fechaVencimiento));
    } else if (_criterioOrden == 'llegada') {
      bolsasFiltradas.sort((a, b) => b.fechaLlegada.compareTo(a.fechaLlegada)); // Más recientes primero
    } else if (_criterioOrden == 'volumen') {
      bolsasFiltradas.sort((a, b) => b.volumenMl.compareTo(a.volumenMl));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bolsas de Sangre: ${widget.tipoSangre}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de Filtros / Ordenamiento
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ordenar por:', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _criterioOrden,
                  items: const [
                    DropdownMenuItem(value: 'vencimiento', child: Text('Fecha de Vencimiento')),
                    DropdownMenuItem(value: 'llegada', child: Text('Orden de Llegada')),
                    DropdownMenuItem(value: 'volumen', child: Text('Cantidad (Volumen)')),
                  ],
                  onChanged: (valor) {
                    if (valor != null) {
                      setState(() {
                        _criterioOrden = valor;
                      });
                    }
                  },
                ),
              ],
            ),
            const Divider(height: 20),
            Expanded(
              child: bolsasFiltradas.isEmpty
                  ? const Center(child: Text('No hay unidades registradas para este tipo.'))
                  : ListView.builder(
                itemCount: bolsasFiltradas.length,
                itemBuilder: (context, index) {
                  final bolsa = bolsasFiltradas[index];
                  final diasRestantes = bolsa.fechaVencimiento.difference(DateTime.now()).inDays;

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.bloodtype, color: Colors.red),
                      title: Text('ID Bolsa: ${bolsa.id} - ${bolsa.volumenMl} ml'),
                      subtitle: Text('Origen: ${bolsa.centroOrigen}\nVence en: $diasRestantes días'),
                      isThreeLine: true,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _mostrarEstadisticasBolsa(context, bolsa, diasRestantes);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ventana emergente con las estadísticas completas de la bolsa seleccionada
  void _mostrarEstadisticasBolsa(BuildContext context, InventarioItem bolsa, int diasRestantes) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Estadísticas - Bolsa #${bolsa.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detalleFila('Tipo de Sangre:', bolsa.tipoSangre),
              _detalleFila('Volumen:', '${bolsa.volumenMl} ml'),
              _detalleFila('Centro de Origen:', bolsa.centroOrigen),
              _detalleFila('Fecha de Llegada:', bolsa.fechaLlegada.toLocal().toString().split(' ')[0]),
              _detalleFila('Fecha de Vencimiento:', bolsa.fechaVencimiento.toLocal().toString().split(' ')[0]),
              _detalleFila('Días Restantes:', '$diasRestantes días'),
              _detalleFila('Estado:', diasRestantes > 5 ? 'Óptimo' : 'Próximo a vencer', color: diasRestantes > 5 ? Colors.green : Colors.red),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _detalleFila(String titulo, String valor, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(valor, style: TextStyle(color: color ?? Colors.black87)),
        ],
      ),
    );
  }
}