import 'package:flutter/material.dart';
import 'data.dart'; // Asume que este archivo define: whiteColor, shadowColor, darkBlueText, primaryBlue, Destination, allDestinations.

// ===============================================
// 2. PANTALLA PRINCIPAL DEL MAPA 
// ===============================================
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Área de Mapa Visual (Se usa Image.asset con la ruta local)
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              // RUTA LOCAL INSERTADA DIRECTAMENTE AQUÍ
              'lib/assets/images/mapa.png', 
              fit: BoxFit.cover,
            ),
          ),

          // 2. Barra de Búsqueda y Botón de Volver (Flota arriba)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: SafeArea(
              child: Row(
                children: [
                  _MapActionButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: _MapSearchField(),
                  ),
                ],
              ),
            ),
          ),

          // 3. Botón de Geolocalización (Centrar el mapa)
          Positioned(
            bottom: size.height * 0.45,
            right: 20,
            child: _MapActionButton(
              icon: Icons.my_location,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Centrando en tu ubicación...')),
                );
              },
            ),
          ),

          // 4. Sección Inferior de Resultados (Flota abajo)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.4,
            child: const _BottomMapResultsSection(),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------
// 3. WIDGETS AUXILIARES PARA MAPSCREEN (CORREGIDO)
// -------------------------------------------

class _MapActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Mantenemos 'const' en BoxDecoration para los valores conocidos
      decoration: const BoxDecoration( 
        color: whiteColor, // Asumiendo whiteColor es const en data.dart
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor, // Asumiendo shadowColor es const en data.dart
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // QUITAMOS 'const' de IconButton y Icon para permitir el color importado
      child: IconButton( 
        icon: Icon(icon, color: darkBlueText), // darkBlueText importado
        onPressed: onTap,
      ),
    );
  }
}

class _MapSearchField extends StatelessWidget {
  const _MapSearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // QUITAMOS 'const' de TextField para manejar el estilo y el ícono
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar destinos o actividades...",
          hintStyle: TextStyle(color: Colors.grey[600]), 
          border: InputBorder.none,
          icon: Icon(Icons.search, color: primaryBlue), // primaryBlue importado
        ),
      ),
    );
  }
}

// -------------------------------------------
// 4. SECCIÓN DE RESULTADOS
// -------------------------------------------
class _BottomMapResultsSection extends StatelessWidget {
  const _BottomMapResultsSection();

  @override
  Widget build(BuildContext context) {
    final List<Destination> destinations = allDestinations;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicador/Handle para deslizar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),
          
          Text(
            'Resultados Cercanos (${destinations.length})', 
            style: const TextStyle(
              color: darkBlueText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Área para la lista horizontal de resultados
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: destinations.length, 
              itemBuilder: (context, index) {
                return _PlaceCard(destination: destinations[index]); 
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------
// 5. TARJETA DE LUGAR
// -------------------------------------------
class _PlaceCard extends StatelessWidget {
  final Destination destination; 

  const _PlaceCard({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                destination.image, 
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200], 
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.redAccent))
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              destination.title, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, color: darkBlueText),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  destination.rating, 
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                if (destination.isPopular) 
                  const Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Text(
                      '⭐ Popular',
                      style: TextStyle(fontSize: 12, color: primaryBlue, fontWeight: FontWeight.bold),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}