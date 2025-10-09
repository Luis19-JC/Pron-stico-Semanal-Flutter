// lib/main.dart

import 'package:flutter/material.dart';

// =======================================================
// ESTRUCTURA DE DATOS (Simulación de la API)
// =======================================================

class DailyForecast {
  final String day;
  final int temp;
  final String condition;
  final String imageId;

  DailyForecast(this.day, this.temp, this.condition, this.imageId);
}

// Función que simula obtener los datos de 7 días
List<DailyForecast> getForecasts() {
  return [
    DailyForecast('Lunes', 22, 'Soleado', 'assets/sun.jpg'),
    DailyForecast('Martes', 18, 'Nublado', 'assets/cloud.jpg'),
    DailyForecast('Miércoles', 15, 'Lluvioso', 'assets/rain.jpg'),
    DailyForecast('Jueves', 25, 'Cálido', 'assets/sun.jpg'),
    DailyForecast('Viernes', 19, 'Viento', 'assets/wind.jpg'),
    DailyForecast('Sábado', 20, 'Parcial', 'assets/partly.jpg'),
    DailyForecast('Domingo', 23, 'Soleado', 'assets/sun.jpg'),
  ];
}

// Función para obtener un pronóstico específico por índice
DailyForecast getDailyForecastByIndex(int index) {
  final data = getForecasts();
  return data[index % data.length];
}

// =======================================================
// WIDGET DE LA TARJETA DE PRONÓSTICO (ForecastCard)
// =======================================================

class ForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            // Día (Izquierda)
            SizedBox(
              width: 100,
              child: Text(
                forecast.day,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            // Condición (Centro) - Ocupa el espacio restante
            Expanded(
              child: Text(
                forecast.condition,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
            // Temperatura (Derecha)
            Text(
              '${forecast.temp}°C',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// APLICACIÓN PRINCIPAL
// =======================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Slivers Demo',
      home: WeatherForecastPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherForecastPage extends StatelessWidget {
  const WeatherForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos CustomScrollView para contener los slivers
      body: CustomScrollView(
        slivers: <Widget>[
          // 1. SLIVER APP BAR (El encabezado dinámico)
          SliverAppBar(
            // Comportamiento del AppBar:
            pinned: true,           // Mantiene la barra visible al colapsar
            floating: true,         // Permite que la barra aparezca/desaparezca rápidamente
            expandedHeight: 250.0,  // Altura máxima de expansión
            stretch: true,          // Habilita el estiramiento (pull-to-refresh)
            
            // Función que se activa al estirar la barra lo suficiente
            onStretchTrigger: () async {
              print('### Recargando datos de pronóstico... ###');
              await Future.delayed(const Duration(milliseconds: 1500)); 
              print('### ¡Recarga completada! ###');
            },
            
            // Título de la barra cuando está colapsada
            title: const Text('Pronóstico Semanal'), 
            
            // Espacio flexible que se mueve y colapsa
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'HORIZONS WEATHER',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,

              // Fondo con imagen y degradado para mejor contraste del título
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen de fondo (Placeholder de una URL pública)
                  Image.network(
                    'https://picsum.photos/800/250', 
                    fit: BoxFit.cover,
                  ),
                  // Degradado para mejorar la visibilidad del título
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: <Color>[
                          Color(0x60000000), // Negro semitransparente
                          Color(0x00000000), // Totalmente transparente
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2. SLIVER LIST (La lista con carga perezosa)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Se construye solo lo necesario
                final forecast = getDailyForecastByIndex(index);
                return ForecastCard(forecast: forecast);
              },
              childCount: 7, // Número total de elementos en la lista
            ),
          ),
        ],
      ),
    );
  }
}