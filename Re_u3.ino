#include <BluetoothSerial.h>
#include <DHT.h>

#define DHTPIN  4    
#define RED_LED  2    
#define GREEN_LED  15 

#define DHTTYPE DHT11  
DHT dht(DHTPIN, DHTTYPE);
BluetoothSerial SerialBT;

void setup() {
  Serial.begin(9600);
  SerialBT.begin("ESP32-DHT11"); 
  pinMode(RED_LED, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  
  dht.begin();
}

void loop() {
  float temp = dht.readTemperature();
  float hum = dht.readHumidity();

  // Verificamos si la lectura fue correcta
  if (isnan(temp) || isnan(hum)) {
    Serial.println("Error al leer del sensor DHT11");
    return;
  }

  // Control del LED rojo (temperatura mayor a 35 grados)
  if (temp > 35) {
    digitalWrite(RED_LED, HIGH);
  } else {
    digitalWrite(RED_LED, LOW);
  }

  // Control del LED verde (humedad mayor al 50%)
  if (hum > 50) {
    digitalWrite(GREEN_LED, HIGH);
  } else {
    digitalWrite(GREEN_LED, LOW);
  }

  // Enviar datos por Bluetooth
  String data = "Temp:" + String(temp) + ",Hum:" + String(hum);
  SerialBT.println(data);

  delay(5000); 
}
