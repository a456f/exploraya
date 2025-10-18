import 'package:flutter/material.dart';
import 'data.dart'; // Contiene Destination, allDestinations, y los colores.
// ===========================================
// PANTALLA PRINCIPAL DE RESERVAS
// ===========================================
class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Dos pestañas: Próximas y Historial
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7), // Fondo gris claro
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Mis Reservas',
            style: TextStyle(
              color: darkBlueText,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: false,
          bottom: TabBar(
            indicatorColor: primaryBlue,
            labelColor: primaryBlue,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Próximas (3)'),
              Tab(text: 'Historial (12)'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Contenido de la pestaña 1: Próximas Reservas
            _UpcomingBookings(),
            // Contenido de la pestaña 2: Historial
            _HistoryBookings(),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------
// 2. WIDGET DE PRÓXIMAS RESERVAS
// -------------------------------------------
class _UpcomingBookings extends StatelessWidget {
  const _UpcomingBookings();

  @override
  Widget build(BuildContext context) {
    // Data simulada para próximas reservas
    final upcomingData = [
      {'title': 'Vuelo a Buenos Aires', 'date': '25 Nov - 02 Dic', 'status': 'Confirmado', 'type': Icons.flight},
      {'title': 'Hotel Hilton - Miami', 'date': '25 Nov - 01 Dic', 'status': 'Confirmado', 'type': Icons.hotel},
      {'title': 'Tour Machu Picchu', 'date': '10 Ene 2026', 'status': 'Pendiente de pago', 'type': Icons.local_activity},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: upcomingData.length,
      itemBuilder: (context, index) {
        final booking = upcomingData[index];
        return _BookingCard(
          title: booking['title'] as String,
          dateRange: booking['date'] as String,
          status: booking['status'] as String,
          icon: booking['type'] as IconData,
          isUpcoming: true,
        );
      },
    );
  }
}

// -------------------------------------------
// 3. WIDGET DE HISTORIAL DE RESERVAS
// -------------------------------------------
class _HistoryBookings extends StatelessWidget {
  const _HistoryBookings();

  @override
  Widget build(BuildContext context) {
    // Data simulada para historial
    final historyData = [
      {'title': 'Hotel en Madrid', 'date': '12 Abr - 19 Abr 2025', 'status': 'Completado', 'type': Icons.hotel},
      {'title': 'Vuelo a Ciudad de México', 'date': '05 Mar 2025', 'status': 'Cancelado', 'type': Icons.flight},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: historyData.length,
      itemBuilder: (context, index) {
        final booking = historyData[index];
        return _BookingCard(
          title: booking['title'] as String,
          dateRange: booking['date'] as String,
          status: booking['status'] as String,
          icon: booking['type'] as IconData,
          isUpcoming: false,
        );
      },
    );
  }
}

// -------------------------------------------
// 4. TARJETA INDIVIDUAL DE RESERVA
// -------------------------------------------
class _BookingCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final String status;
  final IconData icon;
  final bool isUpcoming;

  const _BookingCard({
    required this.title,
    required this.dateRange,
    required this.status,
    required this.icon,
    required this.isUpcoming,
  });

  Color _getStatusColor() {
    if (status.contains('Confirmado')) return Colors.green;
    if (status.contains('Pendiente')) return Colors.orange;
    if (status.contains('Cancelado')) return accentRed;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila 1: Título y Tipo de Viaje
            Row(
              children: [
                Icon(icon, color: primaryBlue, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: darkBlueText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Estado (Chip)
                Chip(
                  label: Text(
                    status,
                    style: TextStyle(color: _getStatusColor(), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  backgroundColor: _getStatusColor().withOpacity(0.1),
                  padding: const EdgeInsets.all(0),
                ),
              ],
            ),
            
            const Divider(height: 20),

            // Fila 2: Fechas
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  dateRange,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
            
            // Acciones solo si la reserva es PRÓXIMA
            if (isUpcoming) ...[
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Abriendo detalles de ${title}')),
                      );
                    },
                    child: const Text('Ver Detalles', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cancelando ${title}...')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: accentRed, width: 1.5),
                      foregroundColor: accentRed,
                    ),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}