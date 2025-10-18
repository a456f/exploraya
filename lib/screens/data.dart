import 'package:flutter/material.dart';

// --- CONSTANTES DE COLOR ---
const Color primaryBlue = Color(0xFF2196F3);
const Color lightBlueBackground = Color(0xFFE3F2FD);
const Color darkBlueText = Color(0xFF0D47A1);
const Color lightBackground = Color(0xFFF3F4F6); // Usado en detalles (Ratings/Iconos)
const Color accentRed = Color.fromARGB(255, 243, 2, 2); // Usado en detalles (Ratings/Iconos)
const Color whiteColor = Colors.white;
const Color shadowColor = Color(0x33000000); // Sombra semitransparente
// --- CONSTANTES DE DATOS UNIVERSALES ---
const String universalImageUrl = 'https://urbania.pe/blog/wp-content/uploads/2025/01/imovelwebcomunicacaoltda_quintoandarperu_image_636.jpeg';
// URL de imagen de mapa simulado
// NOTA: En un proyecto real, reemplazarías esto con el widget de Google Maps
const String mapImageUrl = 'lib/assets/images/fondo.jpg';

// --- CLASE MODELO DE DESTINO (MODIFICADA) ---
class Destination {
  final String title;
  final String subtitle;
  final String rating;
  final String image;
  final String description;
  final bool isPopular; 
  final String gpsLocation; // <-- NUEVO CAMPO PARA GPS/DIRECCIÓN EXACTA

  const Destination({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.image,
    required this.description,
    this.isPopular = false,
    required this.gpsLocation, // <-- AHORA ES REQUERIDO
  });
}

// --- LISTA MAESTRA DE DESTINOS DE HUANCAYO Y JUNÍN ---
// --- LISTA MAESTRA DE DESTINOS DE HUANCAYO Y JUNÍN (¡CON COORDENADAS!) ---
const List<Destination> allDestinations = [
  // ----------------------------------------------------
  //  DESTINOS POPULARES
  // ----------------------------------------------------
  Destination(
    title: 'Nevado de Huaytapallana',
    subtitle: 'Huancayo, Junín',
    rating: '4.9',
    image: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/c9/a9/12/sirena-donde-estas.jpg?w=900&h=-1&s=1',
    description: 'El Nevado de Huaytapallana es uno de los principales atractivos naturales de Huancayo. Ofrece caminatas impresionantes entre paisajes andinos, lagunas glaciares y una vista panorámica de los Andes Centrales.',
    isPopular: true,
    gpsLocation: '-11.9678, -75.0506', // Coordenadas del Nevado
  ),
  Destination(
    title: 'Plaza Constitución',
    subtitle: 'Centro de Huancayo',
    rating: '4.8',
    image: 'https://diariocorreo.pe/resizer/v2/6Q4JKCZV2BC57C27JAPIHDYYKQ.jpg?auth=398463128e5908c4266380b8d9cdb0b3f967fc2b9fcb01ab3adc6bd6c212d8ff&width=1200&height=900&quality=75&smart=true',
    description: 'La Plaza Constitución es el corazón de la ciudad de Huancayo. Rodeada de iglesias, cafés y comercios, destaca por su pileta central y su ambiente lleno de vida cultural y turística.',
    isPopular: true,
    gpsLocation: '-12.067332, -75.204561', // Coordenadas de la Plaza
  ),
  Destination(
    title: 'Parque de la Identidad Wanka',
    subtitle: 'Huancayo, Junín',
    rating: '4.7',
    image: 'https://icommunblog.wordpress.com/wp-content/uploads/2015/10/cxvxvxzxcz.jpg',
    description: 'El Parque de la Identidad Wanka es un homenaje al arte y cultura del valle del Mantaro. Su arquitectura en piedra, esculturas y murales representan la historia y tradiciones del pueblo wanka.',
    isPopular: true,
    gpsLocation: '-12.0617, -75.2093', // Coordenadas del Parque
  ),
  Destination(
    title: 'Torre Torre',
    subtitle: 'Huancayo, Junín',
    rating: '4.8',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0rZG1ikFy_9UnciGtEOYYuUkATOCs9dNO7w&s',
    description: 'Torre Torre es una formación natural de columnas de tierra erosionadas que asemejan torres gigantes. Es un sitio ideal para caminatas y fotografías con una vista increíble de la ciudad.',
    isPopular: true,
    gpsLocation: '-12.0715, -75.1846', // Coordenadas de Torre Torre
  ),
  
  // ----------------------------------------------------
  //  OTROS DESTINOS
  // ----------------------------------------------------
  Destination(
    title: 'Santuario de Wariwillka',
    subtitle: 'Huancán, Huancayo',
    rating: '4.7',
    image: 'https://consultasenlinea.mincetur.gob.pe/fichaInventario/foto.aspx?cod=567092',
    description: 'El Santuario de Wariwillka es un sitio arqueológico que conserva restos del antiguo templo wanka. Aquí se realizaban ceremonias religiosas y ofrendas al dios del agua Hatun Pariacaca.',
    isPopular: true,
    gpsLocation: '-12.1384, -75.2049', 
  ),
  Destination(
    title: 'Pueblos Artesanales (Cocharcas, Hualhuas y San Jerónimo)',
    subtitle: 'Valle del Mantaro, Junín',
    rating: '4.8',
    image: 'https://consultasenlinea.mincetur.gob.pe/fichaInventario/foto.aspx?cod=526825',
    description: 'Los pueblos de Cochas, Hualhuas y San Jerónimo son conocidos por sus artesanías tradicionales. En ellos se elaboran tejidos, tallados en mate burilado y prendas de lana con diseños típicos de la región.',
    isPopular: true,
    gpsLocation: '-12.0015, -75.2530', 
  ),
  Destination(
    title: 'Ingenio',
    subtitle: 'Concepción, Junín',
    rating: '4.9',
    image: 'https://portal.andina.pe/EDPFotografia3/thumbnail/2022/12/29/000922232M.jpg',
    description: 'El criadero de truchas de Ingenio es un atractivo natural y gastronómico donde se puede disfrutar de hermosos paisajes, paseos en bote y deliciosos platos de trucha fresca.',
    isPopular: true,
    gpsLocation: '-11.9079, -75.2933', 
  ),
  Destination(
    title: 'Mirador de Piedra Parada',
    subtitle: 'Huancayo, Junín',
    rating: '4.7',
    image: 'https://consultasenlinea.mincetur.gob.pe/fichaInventario/foto.aspx?cod=544589',
    description: 'El Mirador de Piedra Parada ofrece una vista panorámica del valle del Mantaro. Es un punto ideal para disfrutar del atardecer y tomar fotografías del paisaje andino.',
    isPopular: true,
    gpsLocation: '-12.0620, -75.1950', 
  ),
  Destination(
    title: 'Nevado Verdish',
    subtitle: 'Comas, Concepción',
    rating: '4.8',
    image: 'https://thumbs.dreamstime.com/b/nevado-verdish-en-huancayo-detalle-de-verduras-nevadas-los-andes-161993317.jpg',
    description: 'El Nevado Verdish es una majestuosa montaña que atrae a excursionistas y amantes de la naturaleza por su belleza escénica y su entorno de lagunas altoandinas.',
    isPopular: true,
    gpsLocation: '-11.8700, -75.0200',
  ),
  Destination(
    title: 'Convento de Santa Rosa de Ocopa',
    subtitle: 'Concepción, Junín',
    rating: '4.9',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaTh9B03qAHX4zmsjL5oKmI6mAl_kh6LPiSA&s',
    description: 'Fundado en 1725, el Convento de Santa Rosa de Ocopa es uno de los más importantes del Perú. Destaca por su biblioteca con más de 25 mil volúmenes antiguos y su arquitectura colonial.',
    isPopular: true,
    gpsLocation: '-11.9839, -75.2908',
  ),
  Destination(
    title: 'Arco del Amor',
    subtitle: 'Huancayo, Junín',
    rating: '4.6',
    image: 'https://cloudfront-us-east-1.images.arcpublishing.com/eluniverso/KYVNVO6DUVCONJAWV3HRSI54BM.jpg',
    description: 'El Arco del Amor es un símbolo romántico y moderno ubicado en el centro de Huancayo. Es un lugar popular para parejas y visitantes que buscan una foto memorable.',
    isPopular: true,
    gpsLocation: '-12.0722, -75.2015',
  ),
  Destination(
    title: 'Laguna de Ñahuimpuquio',
    subtitle: 'Ahuac, Chupaca',
    rating: '4.9',
    image: 'https://portal.andina.pe/EDPfotografia3/Thumbnail/2020/04/27/000671334W.webp',
    description: 'La Laguna de Ñahuimpuquio es un atractivo natural rodeado de vegetación andina. Se pueden realizar paseos en bote, pesca recreativa y visitar el sitio arqueológico de Arwaturo cercano.',
    isPopular: true,
    gpsLocation: '-12.0526, -75.3134',
  ),
  Destination(
    title: 'Cerro Wilka Urco',
    subtitle: 'Chilca, Huancayo',
    rating: '4.7',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1usHIQbY5UCNSgUABfUB7wXC_CPC0_GlK9Q&s',
    description: 'El Cerro Wilka Urco es un antiguo lugar ceremonial wanka. Desde su cima se tiene una espectacular vista de todo el valle del Mantaro y se pueden observar restos arqueológicos.',
    isPopular: true,
    gpsLocation: '-12.0911, -75.1950',
  ),
  Destination(
    title: 'Museo Paleontológico de San Juan de Iscos',
    subtitle: 'El Tambo, Huancayo',
    rating: '4.8',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5gIGU5_H8UaLrphDglfANNUDmKJhnYU_J2w&s',
    description: 'El Museo Paleontológico de San Juan de Iscos conserva fósiles prehistóricos hallados en la región. Es un espacio educativo que muestra la evolución de la fauna andina.',
    gpsLocation: '-12.0620, -75.2045', 
  ),
  Destination(
    title: 'Sitio Arqueológico de Arwaturo',
    subtitle: 'Chupaca, Junín',
    rating: '4.8',
    image: 'https://consultasenlinea.mincetur.gob.pe/fichaInventario/foto.aspx?cod=548076',
    description: 'Arwaturo es un complejo arqueológico preincaico ubicado cerca de la laguna de Ñahuimpuquio. Ofrece una caminata escénica entre terrazas agrícolas y antiguos muros de piedra.',
    gpsLocation: '-12.0505, -75.3211', 
  ),
];
const String kDefaultPrice = '313'; // Usado en la barra inferior de detalles