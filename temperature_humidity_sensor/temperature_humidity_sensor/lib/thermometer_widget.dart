import 'package:flutter/material.dart';

class ThermometerWidget extends StatelessWidget {
  final double temperature;

  ThermometerWidget({required this.temperature});

  Color _getMercuryColor(double temp) {
    if (temp < 1) {
      return Colors.blue; // Azul para temperaturas menores a 0
    } else if (temp >= 1 && temp < 35) {
      return Colors.green; // Verde para temperaturas entre 0 y 35
    } else {
      return Colors.red; // Rojo para temperaturas de 35 o más
    }
  }

  Color _getTextColor(double temp) {
    return _getMercuryColor(temp); // Usa la misma lógica para el color del texto
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 220,
      child: Stack(
        children: [
          // Cuerpo del termómetro
          Positioned(
            left: 15,
            top: 0,
            right: 15,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[300],
              ),
            ),
          ),
          // Mercurio
          Positioned(
            left: 15,
            top: (220 - (temperature + 10) * 220 / 60),
            right: 15,
            height: (temperature + 10) * 220 / 60,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: _getMercuryColor(temperature),
              ),
            ),
          ),
          // Parte superior del termómetro
          Positioned(
            left: 10,
            right: 10,
            top: 0,
            height: 10,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.grey[600],
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
            ),
          ),
          // Valor de la temperatura
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Center(
              child: Text(
                '${temperature.toStringAsFixed(1)}°C',
                style: TextStyle(
                  fontSize: 16,
                  color: _getTextColor(temperature), // Cambia el color del texto
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}