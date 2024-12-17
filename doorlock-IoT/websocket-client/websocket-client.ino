#include <ArduinoWebsockets.h>
#include <ESP8266WiFi.h>

const char* ssid = "Axolotl"; //Enter SSID
const char* password = "11111111"; //Enter Password
const char* websockets_server = "ws://103.49.239.37:3001/doorlock/test"; //server adress and port

const int solenoid = 2;

using namespace websockets;

void onMessageCallback(WebsocketsMessage message) {
    Serial.print("Got Message: ");
    Serial.println(message.data());
    if (message.data() == "unlock") {
      digitalWrite(solenoid, LOW);
    }
}

void onEventsCallback(WebsocketsEvent event, String data) {
    if(event == WebsocketsEvent::ConnectionOpened) {
        Serial.println("Connnection Opened");
    } else if(event == WebsocketsEvent::ConnectionClosed) {
        Serial.println("Connnection Closed");
    } else if(event == WebsocketsEvent::GotPing) {
        Serial.println("Got a Ping!");
    } else if(event == WebsocketsEvent::GotPong) {
        Serial.println("Got a Pong!");
    }
}

WebsocketsClient client;
void setup() {
    Serial.begin(9600);
    // Connect to wifi
    WiFi.begin(ssid, password);

    // Wait some time to connect to wifi
    for(int i = 0; i < 100 && WiFi.status() != WL_CONNECTED; i++) {
        Serial.print(".");
        delay(1000);
    }

    Serial.println("connected?");

    // Setup Callbacks
    client.onMessage(onMessageCallback);
    client.onEvent(onEventsCallback);
    
    // Connect to server
    client.connect(websockets_server);

    // Send a message
    client.send("Hi Server!");
    // Send a ping
    client.ping();

    pinMode(solenoid, OUTPUT);
  
    digitalWrite(solenoid, HIGH);
}

void loop() {
    client.poll();
}