import 'package:flutter/material.dart';
// ¡Necesitas esta importación para abrir Google Maps!
import 'package:url_launcher/url_launcher.dart'; 
// Asumo que 'data.dart' contiene las constantes (colores, kDefaultPrice)
import 'data.dart'; 


// =================================================================
// 1. PANTALLA PRINCIPAL: DetailsScreen (MODIFICADA)
// =================================================================

class DetailsScreen extends StatelessWidget {
  final String title;
  final String location;
  final String rating;
  final String imageUrl;
  final String description;
  final String gpsLocation; // <-- NUEVO: Para las coordenadas

  const DetailsScreen({
    super.key,
    required this.title,
    required this.location,
    required this.rating,
    required this.imageUrl, 
    required this.description,
    required this.gpsLocation, // <-- REQUERIDO
  });

  // --- FUNCIÓN DE NAVEGACIÓN A MAPS (Utiliza las coordenadas) ---
  void _launchMaps() async {
    // 1. Limpia las coordenadas y elimina espacios en blanco para evitar errores de codificación.
    final cleanCoordinates = gpsLocation.replaceAll(' ', ''); 
    final encodedTitle = Uri.encodeComponent(title);
    
    // 2. URI para el esquema geo: (más directo, pero a veces falla en Android sin configuración)
    final geoUrl = Uri.parse('geo:$cleanCoordinates?q=$cleanCoordinates($encodedTitle)'); 
    
    // 3. URI para el esquema HTTPS/Web (Google Maps) como alternativa robusta
    final httpUrl = Uri.parse('https://maps.google.com/?q=$cleanCoordinates');

    debugPrint('Intentando abrir URL de Maps con Coordenadas: $geoUrl'); 

    // Intenta lanzar primero el esquema GEO
    if (await launchUrl(geoUrl, mode: LaunchMode.externalApplication)) {
      return;
    } 
    
    // Si falla GEO, intenta lanzar el enlace HTTPS
    if (await launchUrl(httpUrl, mode: LaunchMode.externalApplication)) {
      return;
    }
    
    // Si ambos fallan
    debugPrint('ERROR: No se pudo abrir ninguna aplicación de mapas para: $title');
    // En una app real, podrías mostrar un SnackBar o diálogo de error.
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topSectionHeight = screenHeight * 0.40;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Sección Superior: Imagen con botón de Play
                _buildTopVideoSection(topSectionHeight, imageUrl), 

                // Tarjeta de Contenido
                Container(
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0), 
                  padding: const EdgeInsets.only(top: 40), 
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Padding(
                    // Padding inferior aumentado para que el contenido no quede oculto bajo la BottomPriceBar
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleAndRating(title, location, rating),
                        const SizedBox(height: 15),

                        // CORRECCIÓN 1: Pasar la función _launchMaps al guía turístico
                        _buildTourGuideSection(_launchMaps), 
                        
                        const SizedBox(height: 20),

                        // Sección con Imagen y Descripción
                        _buildDescriptionSection(imageUrl, description), 
                        
                        const SizedBox(height: 20),
                        _buildGallerySection(),
                        const SizedBox(height: 20),
                        _buildIncludedSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildAppBarButtons(context),
          // CORRECCIÓN 2: Llamar a BottomPriceBar sin el parámetro onGpsClick
          // NOTA: Asegúrate que BottomPriceBar ya no requiere onGpsClick
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomPriceBar(), 
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES (Con el botón GPS añadido aquí) ---

  // Sección Superior (con la imagen de fondo)
  Widget _buildTopVideoSection(double height, String imagePath) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Imagen de Fondo
          Positioned.fill(
            child: Image.network(
              imagePath, 
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: lightBackground,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      color: primaryBlue,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: primaryBlue.withOpacity(0.5), 
                child: const Center(child: Icon(Icons.videocam_off, color: Colors.white, size: 40)),
              ),
            ),
          ),
          
          // 2. Capa Oscura (para contraste)
          Container(
            color: Colors.black.withOpacity(0.2), 
            height: height,
          ),

          // 3. Botón de Play Centrado
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  // Sección de la Descripción (con la imagen incluida)
  Widget _buildDescriptionSection(String imagePath, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        
        // ⭐️ IMAGEN REPETIDA EN LA DESCRIPCIÓN
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imagePath, 
            height: 150, 
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 150,
              width: double.infinity,
              color: lightBackground,
              child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
            ),
          ),
        ),
        const SizedBox(height: 15),
        
        // Texto de la descripción
        Text(
          desc,
          style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
  
  // Título, Ubicación y Rating
  Widget _buildTitleAndRating(String title, String location, String rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: lightBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 5),
                  Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.grey, size: 16),
            const SizedBox(width: 5),
            Text(location, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ],
    );
  }
  
  // Guía Turístico (AHORA CON BOTÓN DE GPS)
  Widget _buildTourGuideSection(VoidCallback onGpsClick) {
    return Row(
      children: [
        // Mantener el ícono de persona
        const CircleAvatar(backgroundColor: primaryBlue, child: Icon(Icons.person, color: Colors.white, size: 20)),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre peruano
            Text('Juan Pérez', style: TextStyle(fontWeight: FontWeight.bold)),
            // Rol traducido
            Text('Soporte', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const Spacer(),
        
        // 1. BOTÓN DE GPS (Añadido y unificado con el estilo de _ContactButton)
        GestureDetector(
          onTap: onGpsClick,
          child: _ContactButton(
            icon: Icons.location_on, 
            color: primaryBlue.withOpacity(0.1)
          ),
        ),
        const SizedBox(width: 10),
        
        // 2. Botón de Mensaje
        _ContactButton(icon: Icons.message, color: primaryBlue.withOpacity(0.1)),
        const SizedBox(width: 10),
        
        // 3. Botón de Teléfono
        _ContactButton(icon: Icons.phone, color: primaryBlue.withOpacity(0.1)),
      ],
    );
  }
  
  // Galería de Imágenes
  Widget _buildGallerySection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Galería", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _GalleryImagePlaceholder(width: 100, height: 70),
            _GalleryImagePlaceholder(width: 100, height: 70),
            _GalleryImagePlaceholder(width: 100, height: 70),
          ],
        ),
      ],
    );
  }
  
  // Qué incluye
  Widget _buildIncludedSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Que Incluye", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _IncludedItem(Icons.apartment, 'Hotel'),
            _IncludedItem(Icons.flight, 'Viajes'),
            _IncludedItem(Icons.directions_car, 'Transporte'),
            _IncludedItem(Icons.restaurant, 'Comida'),
          ],
        ),
      ],
    );
  }

  // Botones de la App Bar (atrás y menú)
  Widget _buildAppBarButtons(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CircularIconButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.pop(context), 
            ),
            const _CircularIconButton(icon: Icons.more_vert),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// 2. WIDGETS REUTILIZABLES AUXILIARES (MODIFICADOS)
// =================================================================

class BottomPriceBar extends StatelessWidget {
  // CORRECCIÓN: Eliminamos el parámetro onGpsClick, ya que el botón se movió.
  // Ahora es un widget más simple que solo muestra el precio y el botón de reserva.
  const BottomPriceBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Columna de Precio
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Precio Total', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$$kDefaultPrice',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const Text(' / Persona', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ],
          ),
          
          // Botón de Reserva (Traducido)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              'Reservar Ahora', // Texto traducido
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircularIconButton({required this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap ?? () {},
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _ContactButton({required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: primaryBlue.withOpacity(0.2)),
      ),
      child: Icon(icon, color: primaryBlue, size: 20),
    );
  }
}

class _GalleryImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;
  const _GalleryImagePlaceholder({required this.width, required this.height});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        height: height,
        color: lightBackground,
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey),
        ),
      ),
    );
  }
}

class _IncludedItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IncludedItem(this.icon, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: lightBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: primaryBlue, size: 24),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}