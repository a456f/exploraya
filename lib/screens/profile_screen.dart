// perfil_screen.dart
import 'package:flutter/material.dart';

// --- DATA: Enum y Clase de Usuario para manejar los planes ---

/// Enumeración de los planes de usuario.
enum PlanUsuario { basico, premium, gold }

/// Clase que representa a un usuario.
class Usuario {
  final String nombre;
  final String ubicacion;
  final PlanUsuario plan;
  // Añade aquí más campos si los necesitas (saldo, pedidos, etc.)

  const Usuario({
    required this.nombre,
    required this.ubicacion,
    required this.plan,
  });
}

// Datos de ejemplo para simular la carga del usuario
const usuarioActual = Usuario(
  nombre: 'Johan Smith',
  ubicacion: 'California, USA',
  plan: PlanUsuario.gold, // <--- CAMBIA ESTO para probar los diferentes planes
);

// --- PANTALLA PRINCIPAL ---

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Un fondo ligeramente gris
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Botones superiores
              _construirBotonesAppbar(context),
              const SizedBox(height: 10),

              // 2. Encabezado del perfil (Imagen, Nombre, Ubicación, Plan)
              _construirEncabezadoPerfil(usuarioActual),
              const SizedBox(height: 25),

              // 3. Barra de Estadísticas y Botón de Planes (Clickeable)
              const _BarraEstadisticas(),
              const SizedBox(height: 30),

              // 4. Menú de Opciones
              _construirMenuPerfil(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS AUXILIARES ---

// Manejo de la Lógica y Visualización de Planes
Widget _construirEncabezadoPerfil(Usuario usuario) {
  String textoPlan;
  Color colorPlan;

  // LÓGICA DE PLANES
  switch (usuario.plan) {
    case PlanUsuario.gold:
      textoPlan = 'MIEMBRO GOLD';
      colorPlan = Colors.amber;
      break;
    case PlanUsuario.premium:
      textoPlan = 'PREMIUM';
      colorPlan = Colors.teal;
      break;
    case PlanUsuario.basico:
    default:
      textoPlan = 'BÁSICO';
      colorPlan = Colors.grey;
      break;
  }

  return Column(
    children: [
      const CircleAvatar(
        radius: 60,
        backgroundColor: Colors.teal,
        child: Icon(Icons.person, size: 50, color: Colors.white),
      ),
      const SizedBox(height: 10),
      // Título con el Badge del Plan
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            usuario.nombre,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          // Badge del Plan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorPlan,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              textoPlan,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        usuario.ubicacion,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ],
  );
}

// Botones de la App Bar (Atrás y Editar)
Widget _construirBotonesAppbar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.black),
          onPressed: () {}, // Lógica para editar el perfil
        ),
      ],
    ),
  );
}

// Barra de Estadísticas (Verde) - AHORA ES CLICKABLE
class _BarraEstadisticas extends StatelessWidget {
  const _BarraEstadisticas();

  // Función para mostrar el diálogo de planes
  void _mostrarDialogoPlanes(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const _DialogoPlanes(); // Llama al widget del diálogo
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos GestureDetector para hacer todo el contenedor clickeable
    return GestureDetector(
      onTap: () => _mostrarDialogoPlanes(context), // <--- FUNCIÓN AGREGADA
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.teal, // Color base verde
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ItemEstadistica(etiqueta: 'Saldo', valor: '\$00.00'), 
            _ItemEstadistica(etiqueta: 'Pedidos', valor: '10'),
            _ItemEstadistica(etiqueta: 'Gasto Total', valor: '\$000.0'), 
          ],
        ),
      ),
    );
  }
}

// Elemento individual de la estadística
class _ItemEstadistica extends StatelessWidget {
  final String etiqueta;
  final String valor;
  const _ItemEstadistica({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          etiqueta,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// --- NUEVO: DIÁLOGO CON LA LISTA DE PLANES ---

class _DialogoPlanes extends StatelessWidget {
  const _DialogoPlanes();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Elige tu Plan',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      contentPadding: const EdgeInsets.only(top: 10),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Plan Básico
            _BotonPlan(
              plan: PlanUsuario.basico,
              descripcion: 'Acceso Estándar',
              onTap: () => _seleccionarPlan(context, PlanUsuario.basico),
            ),
            const Divider(height: 0),
            // Plan Premium
            _BotonPlan(
              plan: PlanUsuario.premium,
              descripcion: 'Envío Gratis y Soporte Prioritario',
              onTap: () => _seleccionarPlan(context, PlanUsuario.premium),
            ),
            const Divider(height: 0),
            // Plan Gold
            _BotonPlan(
              plan: PlanUsuario.gold,
              descripcion: 'Beneficios VIP, Descuentos Exclusivos',
              onTap: () => _seleccionarPlan(context, PlanUsuario.gold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CERRAR'),
        ),
      ],
    );
  }

  // Lógica de selección (simulada)
  void _seleccionarPlan(BuildContext context, PlanUsuario plan) {
    Navigator.of(context).pop(); // Cierra el diálogo
    String mensaje = '¡Plan ${plan.toString().split('.').last.toUpperCase()} seleccionado!';
    
    // Muestra un SnackBar para confirmar la acción
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
    // NOTA: Aquí iría la lógica real para actualizar el plan del usuario en tu estado/backend.
  }
}

// Widget auxiliar para cada botón de plan
class _BotonPlan extends StatelessWidget {
  final PlanUsuario plan;
  final String descripcion;
  final VoidCallback onTap;

  const _BotonPlan({
    required this.plan,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener color y nombre del plan
    Color color;
    String nombre;
    switch (plan) {
      case PlanUsuario.gold:
        color = Colors.amber;
        nombre = 'GOLD (\$99/mes)';
        break;
      case PlanUsuario.premium:
        color = Colors.teal;
        nombre = 'PREMIUM (\$49/mes)';
        break;
      default:
        color = Colors.grey;
        nombre = 'BÁSICO (Gratis)';
        break;
    }

    return ListTile(
      leading: Icon(Icons.star, color: color),
      title: Text(
        nombre,
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
      subtitle: Text(descripcion),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}


// Menú de Opciones
Widget _construirMenuPerfil() {
  return Column(
    children: [
      const _ItemMenu(icon: Icons.person_outline, titulo: 'Información Personal'),
      const _ItemMenu(icon: Icons.shopping_cart_outlined, titulo: 'Tus Pedidos'),
      const _ItemMenu(icon: Icons.favorite_border, titulo: 'Tus Favoritos'),
      const _ItemMenu(icon: Icons.payment, titulo: 'Métodos de Pago'),
      const _ItemMenu(icon: Icons.store_mall_directory_outlined, titulo: 'Tiendas Recomendadas'),
      const _ItemMenu(icon: Icons.location_on_outlined, titulo: 'Tienda Más Cercana'),
      const Divider(height: 30, thickness: 1, indent: 20, endIndent: 20),
      _ItemMenu(
        icon: Icons.logout,
        titulo: 'Cerrar Sesión',
        color: Colors.red[400],
      ),
    ],
  );
}

// Elemento individual del Menú
class _ItemMenu extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final Color? color;

  const _ItemMenu({
    required this.icon,
    required this.titulo,
    this.color = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal, size: 24),
      title: Text(
        titulo,
        style: TextStyle(color: color, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Implementar la navegación a cada detalle del menú
        debugPrint('Tapped on $titulo');
      },
    );
  }
}