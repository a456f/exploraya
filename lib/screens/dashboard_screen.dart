// Archivo: lib/dashboard_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'data.dart'; // Contiene Destination, allDestinations, y los colores.
import 'all_destinations_screen.dart'; // La pantalla de lista completa.
import 'profile_screen.dart';
import 'BookingScreen.dart';
import 'MapScreen.dart';
// --- WIDGET PRINCIPAL ---
const List<String> activityImages = [
  'https://blogs.ucontinental.edu.pe/wp-content/uploads/2022/08/santiago-datos-curiosos-sobre-esta-tradicional-celebracion-en-huancayo-universidad-continental-3.jpg', // Senderismo/Naturaleza
  'https://i.ytimg.com/vi/LXs12ZGT37o/sddefault.jpg', // Mercados/Cultura
  'https://i.ytimg.com/vi/sdo9zDqrY7Q/maxresdefault.jpg', // Playa/Aventura Familiar
];
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          // Fondo del encabezado (Blanco)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              color: Colors.white,
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              // Usamos un padding horizontal mayor para compensar el Stack/Positioned
              padding: const EdgeInsets.symmetric(horizontal: 25.0), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[ 
                  _HeaderSection(),
                  SizedBox(height: 20),
                  _SearchSection(),
                  SizedBox(height: 30), // Espacio antes del carrusel
                  // ⭐ SECCIÓN DEL CARRUSEL INSERTADA AQUÍ ⭐
                  _ActivitiesCarousel(), 
                  SizedBox(height: 30), // Espacio después del carrusel
                  _CategorySection(),
                  SizedBox(height: 30),
                  // Se usan las secciones actualizadas con filtrado
                  _PopularDestinationsSection(), 
                  SizedBox(height: 30),
                  _NewDestinationsSection(),
                  SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
      // Barra de navegacion inferior
      bottomNavigationBar: const _CustomBottomNavBar(),
    );
  }
}
// ===========================================
// 2. NUEVA SECCIÓN: CARRUSEL DE ACTIVIDADES
// ===========================================
// -------------------------------------------
// 3. SECCIÓN DE CARRUSEL (AUTOMÁTICO)
// -------------------------------------------
class _ActivitiesCarousel extends StatefulWidget {
  const _ActivitiesCarousel();

  @override
  State<_ActivitiesCarousel> createState() => _ActivitiesCarouselState();
}

class _ActivitiesCarouselState extends State<_ActivitiesCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer; 

  @override
  void initState() {
    super.initState();
    
    // Configura el deslizamiento automático cada 2 segundos
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        
        if (nextPage >= activityImages.length) {
          nextPage = 0; 
        }
        
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });

    // Listener para actualizar el indicador de página (dots)
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); 
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividades Populares',
          style: TextStyle(
            color: darkBlueText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        
        // Carrusel (PageView)
        SizedBox(
          height: 200, 
          child: PageView.builder(
            controller: _pageController,
            itemCount: activityImages.length,
            itemBuilder: (context, index) {
              return _CarouselItem(
                imageUrl: activityImages[index],
                title: index == 0 ? 'Tunantada' : (index == 1 ? 'Gran fiesta' : 'Reali Huancayo'),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Indicadores de página (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(activityImages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: _currentPage == index ? 24.0 : 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index ? primaryBlue : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ],
    );
  }
}


// -------------------------------------------
// 4. CLASES AUXILIARES (IMPLEMENTACIONES MÍNIMAS)
// -------------------------------------------

class _CarouselItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  const _CarouselItem({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.red[100], child: const Center(child: Icon(Icons.error))),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 15,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(blurRadius: 5, color: Colors.black54, offset: Offset(1, 1))
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

// ------------------------------------------------------------------
// --- WIDGETS AUXILIARES DE DASHBOARDSCREEN ---
// ------------------------------------------------------------------
// ===========================================
// 1. HEADER SECTION (Con Chatbot interactivo)
// ===========================================
class _HeaderSection extends StatelessWidget {
  const _HeaderSection({super.key});

  // Lógica para el mensaje inicial del chatbot
  String getChatbotInitialMessage() {
    final now = DateTime.now();
    
    // Simulación de detección de festivo (Marzo, Abril, o principios de Mayo)
    if (now.month >= 3 && now.month <= 5) {
      return "¡Hola, Alex! Veo que se acerca Semana Santa. 🌴 ¿Necesitas ideas de viaje, o puedo ayudarte con algo más?";
    }

    return "¡Hola, Alex! Estoy aquí para ayudarte a planear tu próxima aventura. ¿Qué tienes en mente hoy? 🗺️";
  }

  // ⭐ NUEVA FUNCIÓN: Muestra el diálogo del chatbot con campo de texto ⭐
  void _showChatbotDialog(BuildContext context) {
    // Usamos TextEditingController para manejar la entrada del usuario
    final controller = TextEditingController(); 
    final initialMessage = getChatbotInitialMessage();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        // Usamos StateFulBuilder para que el diálogo pueda reconstruirse (para la respuesta futura del bot)
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width * 0.9, // Hace el diálogo más ancho
                height: MediaQuery.of(context).size.height * 0.7, // Altura fija para simular un chat
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Encabezado ---
                    Row(
                      children: [
                        const Icon(Icons.chair, color: primaryBlue, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          "Exploraya Asistente",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkBlueText,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                    const Divider(height: 10, thickness: 1),
                    
                    // --- Área de Conversación (Simulación) ---
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Burbuja del Bot con mensaje inicial
                            _ChatBubble(
                              text: initialMessage, 
                              isBot: true,
                              color: primaryBlue.withOpacity(0.1),
                              borderColor: primaryBlue,
                            ),
                            const SizedBox(height: 15),

                            // Simulación de opciones (Preguntas Frecuentes)
                            Text(
                              "O si prefieres, toca una de estas opciones:",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),

                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: [
                                _ChatOptionChip(
                                  text: "¿Qué planes para este fin de semana?",
                                  onTap: () {
                                    // Simula la respuesta y cierra el chat
                                    Navigator.of(context).pop(); 
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Buscando planes para este fin de semana...')),
                                    );
                                  },
                                ),
                                _ChatOptionChip(
                                  text: "¿Qué destino conoceremos hoy?",
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('¡Excelente! Abriendo mapa de destinos.')),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Aquí se añadirían más burbujas de conversación
                          ],
                        ),
                      ),
                    ),
                    
                    // --- Campo de Texto para Escribir ---
                    const Divider(height: 10, thickness: 1),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Escribe tu pregunta...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                            ),
                          ),
                        ),
                        // Botón de Enviar (Simulación)
                        IconButton(
                          icon: const Icon(Icons.send_rounded, color: primaryBlue),
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              // ⭐ Lógica de simulación de envío:
                              final userMessage = controller.text;
                              controller.clear();
                              Navigator.of(context).pop(); // Cierra el diálogo para la simulación
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tu pregunta ("$userMessage") fue enviada al asistente.')),
                              );
                              // En un chat real, aquí llamarías a setState para añadir la burbuja del usuario.
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // El resto del widget _HeaderSection se mantiene igual
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Avatar de Perfil
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(universalImageUrl),
              backgroundColor: darkBlueText,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenido',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  'Hola, Alex!',
                  style: TextStyle(
                    color: darkBlueText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Icono de Chatbot
        GestureDetector(
          onTap: () => _showChatbotDialog(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: primaryBlue,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================
// WIDGETS AUXILIARES PARA EL CHATBOT
// ===========================================

// Widget para la burbuja de chat
class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isBot;
  final Color color;
  final Color borderColor;

  const _ChatBubble({
    required this.text,
    this.isBot = true,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15).copyWith(
          // Estilo de burbuja de chat: esquina de origen plana
          topLeft: isBot ? const Radius.circular(0) : const Radius.circular(15),
          topRight: isBot ? const Radius.circular(15) : const Radius.circular(0),
        ),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isBot ? darkBlueText : Colors.white,
        ),
      ),
    );
  }
}


// Widget auxiliar para las opciones de chat (Ahora con onTap)
class _ChatOptionChip extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  
  const _ChatOptionChip({required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(text, style: TextStyle(color: primaryBlue, fontSize: 13)),
        backgroundColor: primaryBlue.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryBlue.withOpacity(0.5), width: 0.8),
        ),
      ),
    );
  }
}

// ===========================================
// 2. SEARCH SECTION (Mantenido sin cambios)
// ===========================================
class _SearchSection extends StatelessWidget {
  const _SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
        // Contenedor del Campo de Búsqueda y el Icono de Calendario
        Row(
          children: [
            // Campo de Busqueda (Input) - EXPANDIDO
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar aqui...', 
                    icon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 10),
            
            // Icono de Calendario
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({super.key});

  final List<Map<String, String>> categories = const [
    // Updated with the image URLs you provided
    {'name': 'Parques', 'image': 'https://img.freepik.com/foto-gratis/parque-camino-madera-bancos_1137-254.jpg?semt=ais_hybrid&w=740&q=80'},
    {'name': 'Hoteles', 'image': 'https://media-cdn.tripadvisor.com/media/photo-s/16/1a/ea/54/hotel-presidente-4s.jpg'},
    {'name': 'Restaurantes', 'image': 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/27/ea/3c/66/ana-caribe-asia.jpg?w=900&h=500&s=1'},
    {'name': 'Cocheras', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxHtxs795ZXiD21SBachr7nnhrMAGsiGxu8g&s'},
    {'name': 'Grifos', 'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQ0Z-LMd_SJ1rkNKZPbx0LCZ9Utr3HUVatng&s'},
    {'name': 'Lugares', 'image': 'https://www.dehuancayo.com/imagenes/parque-mates-burilados.webp'}, // Reusing the park image for 'Lugares'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lista Horizontal de Categorias
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(categories[index]['image']!),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      categories[index]['name']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
class _DestinationCard extends StatelessWidget {
  final Destination destination; 
  final bool isLarge;

  const _DestinationCard({
    super.key,
    required this.destination,
    this.isLarge = true,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = isLarge ? 250 : MediaQuery.of(context).size.width * 0.45;

 return GestureDetector(
      onTap: () {
        // Navegacion a la pantalla de detalles usando el objeto Destination
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              title: destination.title,
              location: destination.subtitle,
              rating: destination.rating,
              imageUrl: destination.image, 
              description: destination.description, 
              // ¡AÑADIDO! Pasar la ubicación GPS a la pantalla de detalles
              gpsLocation: destination.gpsLocation, 
            ),
          ),
        );
      },

      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 15),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  Image.network(
                    destination.image, 
                    height: isLarge ? 150 : 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: isLarge ? 150 : 100,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: isLarge ? 150 : 100,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text(
                            destination.rating,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: darkBlueText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      Expanded(
                        child: Text(
                          destination.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isLarge) 
                        const Icon(Icons.arrow_circle_right, color: primaryBlue, size: 20)
                      else 
                        const Icon(Icons.info, color: primaryBlue, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// --- SECCIONES CORREGIDAS CON FILTRADO ---
// ------------------------------------------------------------------

class _PopularDestinationsSection extends StatelessWidget {
  const _PopularDestinationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // FILTRADO: Obtiene la lista de destinos donde isPopular es true
    final List<Destination> popularDestinations = allDestinations.where((dest) => dest.isPopular).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Populares', 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkBlueText,
              ),
            ),
            // Navegacion al presionar "Ver Todo"
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllDestinationsScreen(),
                  ),
                );
              },
              child: const Text(
                'Ver Todo', 
                style: TextStyle(
                  fontSize: 14,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 250, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularDestinations.length, // Usamos la lista filtrada
            itemBuilder: (context, index) {
              final dest = popularDestinations[index];
              return _DestinationCard(
                destination: dest, 
                isLarge: true,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NewDestinationsSection extends StatelessWidget {
  const _NewDestinationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // FILTRADO: Obtiene la lista de destinos donde isPopular es false (los nuevos/normales)
    final List<Destination> newDestinations = allDestinations.where((dest) => !dest.isPopular).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nuevos Destinos', 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkBlueText,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 170, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newDestinations.length, // Usamos la lista filtrada
            itemBuilder: (context, index) {
              final dest = newDestinations[index];
              return _DestinationCard(
                destination: dest, 
                isLarge: false,
              );
            },
          ),
        ),
      ],
    );
  }
}
// ------------------------------------------------------------------
// --- FIN DE LAS SECCIONES CORREGIDAS ---
// ------------------------------------------------------------------

// ===============================================
// 3. BARRA DE NAVEGACIÓN INFERIOR PERSONALIZADA (CORREGIDA)
// ===============================================
class _CustomBottomNavBar extends StatelessWidget {
  // NOTA: El constructor de la clase principal puede seguir siendo const
  const _CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 60 + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. INICIO (Home) - SE REMUEVE 'const'
          _BottomNavItem( 
            icon: Icons.home, 
            isActive: true, 
            onTap: () {
               Navigator.popUntil(context, (route) => route.isFirst); 
            },
          ),

          // 2. GPS / MAPA - SE REMUEVE 'const'
          _BottomNavItem(
            icon: Icons.map_outlined, 
            isActive: false,
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute no es const
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
          
          // 3. RESERVAS / BOOKMARKS - SE REMUEVE 'const'
          _BottomNavItem(
            icon: Icons.bookmark_border, 
            isActive: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingScreen()),
              );
            },
          ),

          // 4. PERFIL - SE REMUEVE 'const'
          _BottomNavItem(
            icon: Icons.person_outline,
            isActive: false, 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()), 
              );
            },
          ),
        ],
      ),
    );
  }
}
// The original _BottomNavItem (assumed structure):
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  // We need to add an onTap callback!
  final VoidCallback? onTap; 

  const _BottomNavItem({
    required this.icon,
    required this.isActive,
    this.onTap, // <--- New property
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // <--- Use GestureDetector for tap
      onTap: onTap, // <--- Apply the callback
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          icon,
          color: isActive ? Colors.teal : Colors.grey, // Assuming 'teal' is your primary color
          size: 28,
        ),
      ),
    );
  }
}
