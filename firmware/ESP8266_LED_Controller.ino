#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>

// Wi-Fi network settings
const char* ssid     = "XXXX";
const char* password = "XXXX";

// Create an HTTP server on port 80
ESP8266WebServer server(80);

// Global variables storing the last processed values
int lastR = 0, lastG = 0, lastB = 0;
double lastBrightness = 0.0;
bool lastIsOn = false;
String lastProcessInfo = "Brak odebranych sygnałów.";

// Handle GET request on "/"
// Returns the current values as plain text, line by line
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

// Handle POST request on "/setColor"
void handleSetColor() {
  // Check if the request method is POST
  if (server.method() != HTTP_POST) {
    server.send(405, "text/plain", "Method Not Allowed");
    return;
  }

  // Check if the request body is present
  if (!server.hasArg("plain")) {
    server.send(400, "text/plain", "Bad Request");
    return;
  }
  
  String body = server.arg("plain");
  Serial.println("Odebrany JSON: " + body);

  // Parse the JSON document
  // The expected document size does not exceed 200 bytes
  StaticJsonDocument<200> doc;
  DeserializationError error = deserializeJson(doc, body);
  if (error) {
    Serial.print("Blad deserializacji JSON: ");
    Serial.println(error.c_str());
    server.send(400, "application/json", "{\"error\":\"Invalid JSON\"}");
    return;
  }
  
  // Extract individual values from the JSON object
  int r = doc["r"];                   // Red component (0-255)
  int g = doc["g"];                   // Green component (0-255)
  int b = doc["b"];                   // Blue component (0-255)
  double brightness = doc["brightness"]; // Brightness (e.g. 0.0-1.0)
  bool isOn = doc["isOn"];            // LED state (true/false)
  
  // Store the received values in global variables
  lastR = r;
  lastG = g;
  lastB = b;
  lastBrightness = brightness;
  lastIsOn = isOn;
  
  // Example control logic
  // Replace this section with the actual LED strip control implementation
  if (isOn) {
    lastProcessInfo = "Ustawiono LED: R=" + String(r) + ", G=" + String(g) +
                      ", B=" + String(b) + ", Brightness=" + String(brightness, 2);
    Serial.println("Wlaczam LED z ustawionymi kolorami i jasnoscia.");
  } else {
    lastProcessInfo = "LED zostal wylaczony.";
    Serial.println("Wylaczam LED.");
  }
  
  // Send a response back to the client
  server.send(200, "application/json", "{\"status\":\"OK\"}");
}

void setup() {
  Serial.begin(9600);
  Serial.println("Start setup");
  delay(1000);
  
  // Connect to the Wi-Fi network
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
  
  // Print the IP address every 2 seconds for the first 10 seconds
  for (int i = 0; i < 5; i++) {
    Serial.print("Adres IP: ");
    Serial.println(ip);
    delay(2000);
  }
  
  // Register HTTP endpoints
  server.on("/", HTTP_GET, handleRoot);
  server.on("/setColor", HTTP_POST, handleSetColor);
  
  // Start the HTTP server
  server.begin();
  Serial.println("Serwer HTTP wystartował.");
  Serial.println("Koniec setup");
}

void loop() {
  // Handle incoming HTTP requests
  server.handleClient();
}