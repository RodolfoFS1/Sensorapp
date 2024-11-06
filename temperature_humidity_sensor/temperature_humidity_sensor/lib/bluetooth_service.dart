import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

class BluetoothService {
  BluetoothConnection? connection;
  StreamController<String> dataController = StreamController<String>();

  Future<bool> connectToDevice() async {
    try {
      // Intentar buscar dispositivos emparejados
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();

      // Buscar el dispositivo específico por nombre
      BluetoothDevice? selectedDevice = devices.firstWhere(
              (device) => device.name == 'ESP32-DHT11', orElse: () => BluetoothDevice(address: '', name: '', type: BluetoothDeviceType.unknown));

      // Verificar si se encontró el dispositivo antes de intentar la conexión
      if (selectedDevice.address.isNotEmpty) {
        // Intentar la conexión
        connection = await BluetoothConnection.toAddress(selectedDevice.address);
        print('Conectado a ${selectedDevice.name}');
        return true;
      } else {
        print('Dispositivo no encontrado. Asegúrate de que esté emparejado.');
        return false;
      }
    } catch (e) {
      print('Error al conectar: $e');
      return false;
    }
  }

  void disconnectDevice() {
    if (connection != null) {
      connection!.dispose();
      connection = null;
      print('Dispositivo desconectado');
    } else {
      print('No hay conexión activa para desconectar.');
    }
  }

  Future<void> readSensorData() async {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList([1])); // Enviar solicitud de datos
      await connection!.output.allSent;
    } else {
      print('Conexión no establecida');
    }
  }

  Stream<String> listenToData() {
    if (connection != null && connection!.isConnected) {
      connection!.input!.listen((Uint8List data) {
        String receivedData = String.fromCharCodes(data);
        dataController.add(receivedData);
      }).onDone(() {
        print("Desconectado del dispositivo");
        disconnectDevice();
      });
    } else {
      print('No hay conexión para escuchar datos.');
    }
    return dataController.stream;
  }
}
