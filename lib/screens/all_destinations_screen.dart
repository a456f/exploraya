// Archivo: lib/all_destinations_screen.dart

import 'package:flutter/material.dart';
import 'data.dart'; // Importa la lista allDestinations, Destination y los colores (lightBlueBackground, darkBlueText, primaryBlue)
import 'details_screen.dart'; // Necesario para la navegacion a los detalles

// =================================================================
// 1. PANTALLA PRINCIPAL: AllDestinationsScreen (Ahora Stateful)
// =================================================================

class AllDestinationsScreen extends StatefulWidget {
  const AllDestinationsScreen({super.key});

  @override
  State<AllDestinationsScreen> createState() => _AllDestinationsScreenState();
}

class _AllDestinationsScreenState extends State<AllDestinationsScreen> {
  // Lista que contendrá los destinos filtrados (o todos inicialmente)
  List<Destination> _filteredDestinations = allDestinations;
  
  // Controlador para obtener el texto del campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialmente, la lista filtrada es igual a la lista completa
    _filteredDestinations = allDestinations;
    
    // Escucha los cambios en el campo de texto para filtrar
    _searchController.addListener(_filterDestinations);
  }

  @override
  void dispose() {
    // Es importante limpiar los controladores al salir
    _searchController.removeListener(_filterDestinations);
    _searchController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE BÚSQUEDA Y FILTRADO ---
  void _filterDestinations() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        // Si el campo está vacío, mostramos todos los destinos
        _filteredDestinations = allDestinations;
      } else {
        // Filtramos la lista basándonos en si el título o subtítulo contienen la consulta
        _filteredDestinations = allDestinations.where((destination) {
          final titleLower = destination.title.toLowerCase();
          final subtitleLower = destination.subtitle.toLowerCase();
          return titleLower.contains(query) || subtitleLower.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlueBackground,
      appBar: AppBar(
        title: const Text(
          'Todos los Destinos',
          style: TextStyle(color: darkBlueText, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkBlueText),
      ),
      body: Column(
        children: [
          // --- 2. BARRA DE BÚSQUEDA (NUEVO) ---
          _buildSearchBar(context),
          
          // --- 3. LISTA DE DESTINOS FILTRADOS ---
          Expanded(
            child: _filteredDestinations.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron destinos.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    itemCount: _filteredDestinations.length,
                    itemBuilder: (context, index) {
                      final destination = _filteredDestinations[index];
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _ListDestinationCard(destination: destination),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  // Widget para construir la barra de búsqueda
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por título o ubicación...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: primaryBlue),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear(); // Limpia el texto y dispara el listener
                    FocusScope.of(context).unfocus(); // Oculta el teclado
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        ),
        onChanged: (value) {
          // El listener ya se encarga del filtrado, pero es bueno tener onChanged
          setState(() {}); // Forzar el rebuild para mostrar/ocultar el icono de limpiar
        },
      ),
    );
  }
}

// -----------------------------------------------------------------
// 2. WIDGET AUXILIAR: _ListDestinationCard (Sin cambios)
// -----------------------------------------------------------------

// Este widget es una variante de _DestinationCard adaptada para ListView.
class _ListDestinationCard extends StatelessWidget {
  final Destination destination;

  const _ListDestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
// Navegacion a la pantalla de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              title: destination.title,
              location: destination.subtitle,
              rating: destination.rating,
              imageUrl: destination.image,
              description: destination.description,
              // ¡CAMBIO CLAVE! Añadir gpsLocation
              gpsLocation: destination.gpsLocation, 
            ),
          ),
        );
      },
      child: Container(
        height: 120, // Altura fija para la tarjeta en la lista
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen del Destino (Lado Izquierdo)
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
              child: Image.network(
                destination.image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

            // Detalles (Lado Derecho)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Titulo y Ubicación
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkBlueText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                destination.subtitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Rating en la parte inferior
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              Text(
                                destination.rating,
                                style: const TextStyle(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.bold, 
                                  color: primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios, 
                          color: Colors.grey, 
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}