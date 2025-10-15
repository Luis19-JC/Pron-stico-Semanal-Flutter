import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const SplashApp());
}

class SplashApp extends StatelessWidget {
  const SplashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Forecast',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 130, 171, 233),
      body: Center(
        child: Lottie.asset(
          'assets/Loading_splash.json',
          width: 250,
          height: 250,
          onLoaded: (composition) {
            // Cuando termina la animación, pasa a la pantalla principal
            Future.delayed(composition.duration, () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const WeatherForecastPage()),
              );
            });
          },
        ),
      ),
    );
  }
}

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

DailyForecast getDailyForecastByIndex(int index) {
  final data = getForecasts();
  return data[index % data.length];
}

// =======================================================
// WIDGET DE LA TARJETA DE PRONÓSTICO
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
            SizedBox(
              width: 100,
              child: Text(
                forecast.day,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                forecast.condition,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
            Text(
              '${forecast.temp}°C',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// PANTALLA PRINCIPAL: Pronóstico del Clima
// =======================================================

class WeatherForecastPage extends StatelessWidget {
  const WeatherForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 250.0,
            stretch: true,
            onStretchTrigger: () async {
              print('### Recargando datos de pronóstico... ###');
              await Future.delayed(const Duration(milliseconds: 1500));
              print('### ¡Recarga completada! ###');
            },
            title: const Text('Pronóstico Semanal'),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'HORIZONS WEATHER',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/800/250',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((
              BuildContext context,
              int index,
            ) {
              final forecast = getDailyForecastByIndex(index);
              return ForecastCard(forecast: forecast);
            }, childCount: 7),
          ),
        ],
      ),
    );
  }
}
