import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; 
import 'dart:async'; // Necesario para el Timer

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Estado para controlar la opacidad y animar el contenido inferior
  double _opacityLevel = 0.0;
  
  @override
  void initState() {
    super.initState();
    // Inicia un temporizador para aumentar la opacidad después de un breve retraso (0.5 segundos)
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacityLevel = 1.0;
        });
      }
    });
  }

  final TextStyle logoTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 34,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(blurRadius: 10.0, color: Colors.black26, offset: Offset(0, 4))
    ],
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // 1. Imagen de Fondo de Pantalla Completa (Asset: fondo.jpg)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/fondo.jpg'), 
                  fit: BoxFit.cover,
                ),
              ),
              // ⭐ EFECTO PROFESIONAL: Filtro de color suave para oscurecer y mejorar el contraste
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), // Oscurece muy ligeramente
                  BlendMode.darken,
                ),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // 2. Gradiente Oscuro para Legibilidad del Texto (Ajustado)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black12,
                    Colors.black45,
                    Colors.black87,
                  ],
                  stops: [0.4, 0.65, 0.85, 1.0], 
                ),
              ),
            ),
          ),

          // 3. Contenido Principal (Ahora animado con opacidad)
          // ⭐ EFECTO PROFESIONAL: Transición de opacidad para la entrada del contenido
          AnimatedOpacity(
            opacity: _opacityLevel,
            duration: const Duration(seconds: 1),
            child: Padding(
              padding: EdgeInsets.only(
                left: 32.0, 
                right: 32.0, 
                bottom: 60.0 + MediaQuery.of(context).padding.bottom, 
                top: screenHeight / 6.0, 
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // --- A. Logo de la Empresa (Parte Superior, GRANDE) ---
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/images/exploraya_logo.png', 
                          height: 220, 
                          width: 220,  
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  
                  // --- B. Contenido de Bienvenida (Parte Inferior) ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título/Lema principal
                      Text(
                        'Explora Ya',
                        style: logoTextStyle.copyWith(fontSize: 42), // Tamaño más grande
                      ),
                      const SizedBox(height: 8),

                      // Eslogan
                      const Text(
                        'Más que un guía, tu compañero de viaje.',
                        style: TextStyle(
                          color: Colors.white, // Blanco puro para más contraste
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Botón de flecha (diseño original mantenido)
                      Align(
                        alignment: Alignment.center,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ),
                            );
                          },
                          backgroundColor: Colors.white,
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 15, 37, 163), 
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}