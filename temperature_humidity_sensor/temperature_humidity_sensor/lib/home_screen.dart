import 'package:flutter/material.dart';
import 'bluetooth_service.dart';
import 'thermometer_widget.dart';
import 'humidity_gauge_widget.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BluetoothService _bluetoothService = BluetoothService();
  String temperature = "0.0";
  String humidity = "0.0";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    connectToDevice();
    autoReadData(); // Leer datos automáticamente cada 5 segundos
  }

  void autoReadData() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      _bluetoothService.readSensorData();
    });
  }

  void connectToDevice() async {
    await _bluetoothService.connectToDevice();

    // Usar el stream para escuchar los datos
    _bluetoothService.listenToData().listen((data) {
      setState(() {
        List<String> sensorData = data.split(',');
        temperature = sensorData[0].split(':')[1];
        humidity = sensorData[1].split(':')[1];
      });
    });
  }

  void disconnectDevice() {
    _bluetoothService.disconnectDevice();
  }

  @override
  void dispose() {
    timer?.cancel();
    disconnectDevice();
    super.dispose();
  }

  Color _getTemperatureTextColor(double temp) {
    if (temp < 1) {
      return Colors.blue; // Azul para temperaturas menores a 0
    } else if (temp >= 1 && temp < 35) {
      return Colors.green; // Verde para temperaturas entre 0 y 35
    } else {
      return Colors.red; // Rojo para temperaturas de 35 o más
    }
  }

  Color _getHumidityTextColor(double hum) {
    if (hum < 50) {
      return Colors.blue; // Azul para humedad menor a 30%
    } else if (hum >= 50 && hum < 70) {
      return Colors.green; // Verde para humedad entre 30% y 60%
    } else {
      return Colors.red; // Rojo para humedad de 60% o más
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Por AC-DC'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _bluetoothService.readSensorData,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(14.0),
        child: Column(
          children: [
            ThermometerWidget(temperature: double.tryParse(temperature) ?? 0.0),
            HumidityGaugeWidget(humidity: double.tryParse(humidity) ?? 0.0),
            SizedBox(height: 6),
            Text(
              'Temperatura: $temperature °C',
              style: TextStyle(
                fontSize: 14,
                color: _getTemperatureTextColor(double.tryParse(temperature) ?? 0.0),
              ),
            ),
            Text(
              'Humedad: $humidity %',
              style: TextStyle(
                fontSize: 14,
                color: _getHumidityTextColor(double.tryParse(humidity) ?? 0.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}