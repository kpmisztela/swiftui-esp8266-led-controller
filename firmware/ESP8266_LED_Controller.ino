#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>

// Ustawienia sieci Wi-Fi – wpisz swoje dane
const char* ssid     = "XXXX";
const char* password = "XXXX";

// Utworzenie serwera HTTP na porcie 80
ESP8266WebServer server(80);

// Globalne zmienne przechowujące ostatnio przetworzony sygnał
int lastR = 0, lastG = 0, lastB = 0;
double lastBrightness = 0.0;
bool lastIsOn = false;
String lastProcessInfo = "Brak odebranych sygnałów.";

// Funkcja obsługująca żądanie GET na "/"
// Odpowiedź zwraca prosty tekst, linia pod linią
void handleRoot() {
  String response;
  response += "R: " + String(lastR) + "\n";
  response += "G: " + String(lastG) + "\n";
  response += "B: " + String(lastB) + "\n";
  response += "Brightness: " + String(lastBrightness, 2) + "\n";
  response += "LED: " + String(lastIsOn ? "Wlaczony" : "Wylaczony") + "\n";
  response += "Przetworzony sygnal: " + lastProcessInfo + "\n";
  
  server.send(200, "text/plain", response);
}

// Funkcja obsługująca żądanie POST na "/setColor"
void handleSetColor() {
  // Sprawdzamy, czy metoda to POST
  if (server.method() != HTTP_POST) {
    server.send(405, "text/plain", "Method Not Allowed");
    return;
  }

  // Sprawdzamy, czy odebrano ciało żądania
  if (!server.hasArg("plain")) {
    server.send(400, "text/plain", "Bad Request");
    return;
  }
  
  String body = server.arg("plain");
  Serial.println("Odebrany JSON: " + body);

  // Parsowanie JSON – zakładamy, że rozmiar dokumentu nie przekracza 200 bajtów
  StaticJsonDocument<200> doc;
  DeserializationError error = deserializeJson(doc, body);
  if (error) {
    Serial.print("Blad deserializacji JSON: ");
    Serial.println(error.c_str());
    server.send(400, "application/json", "{\"error\":\"Invalid JSON\"}");
    return;
  }
  
  // Pobieramy poszczególne wartości z JSON
  int r = doc["r"];                   // wartość czerwonego (0-255)
  int g = doc["g"];                   // wartość zielonego (0-255)
  int b = doc["b"];                   // wartość niebieskiego (0-255)
  double brightness = doc["brightness"]; // jasnosc (np. 0.0-1.0)
  bool isOn = doc["isOn"];            // stan wlaczenia (true/false)
  
  // Zapisujemy odebrane wartości w globalnych zmiennych
  lastR = r;
  lastG = g;
  lastB = b;
  lastBrightness = brightness;
  lastIsOn = isOn;
  
  // Przykładowa logika sterowania – zastąp poniższy fragment własnym kodem sterującym taśmą LED
  if (isOn) {
    lastProcessInfo = "Ustawiono LED: R=" + String(r) + ", G=" + String(g) +
                      ", B=" + String(b) + ", Brightness=" + String(brightness, 2);
    Serial.println("Wlaczam LED z ustawionymi kolorami i jasnoscia.");
  } else {
    lastProcessInfo = "LED zostal wylaczony.";
    Serial.println("Wylaczam LED.");
  }
  
  // Wyslanie odpowiedzi do klienta
  server.send(200, "application/json", "{\"status\":\"OK\"}");
}

void setup() {
  Serial.begin(9600);
  Serial.println("Start setup");
  delay(1000);
  
  // Laczymy sie z Wi-Fi
  Serial.println("Laczenie z Wi-Fi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Polaczono! Adres IP: ");
  IPAddress ip = WiFi.localIP();
  Serial.println(ip);
  
  // Przez pierwsze 10 sekund co 2 sekundy wypisujemy adres IP
  for (int i = 0; i < 5; i++) {
    Serial.print("Adres IP: ");
    Serial.println(ip);
    delay(2000);
  }
  
  // Rejestracja endpointóww
  server.on("/", HTTP_GET, handleRoot);
  server.on("/setColor", HTTP_POST, handleSetColor);
  
  // Uruchomienie serwera
  server.begin();
  Serial.println("Serwer HTTP wystartował.");
  Serial.println("Koniec setup");
}

void loop() {
  // Obsluga przychodzacych zadan HTTP
  server.handleClient();
}
