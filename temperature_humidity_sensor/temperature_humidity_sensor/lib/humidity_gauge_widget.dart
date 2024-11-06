import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HumidityGaugeWidget extends StatelessWidget {
  final double humidity;

  HumidityGaugeWidget({required this.humidity});

  Color _getHumidityTextColor(double humidity) {
    if (humidity < 50) {
      return Colors.blue; // Azul para humedad menor a 30%
    } else if (humidity >= 50 && humidity < 70) {
      return Colors.green; // Verde para humedad entre 30% y 60%
    } else {
      return Colors.red; // Rojo para humedad de 60% o más
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 180,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 50, color: Colors.blue),
              GaugeRange(startValue: 50, endValue: 75, color: Colors.green),
              GaugeRange(startValue: 75, endValue: 100, color: Colors.red),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(value: humidity),
            ],
          ),
        ],
      ),
    );
  }
}