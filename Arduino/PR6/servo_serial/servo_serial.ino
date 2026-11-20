#include <Servo.h>

Servo motor;
const byte servoPin = 9;

// Start with a conservative travel range. Adjust for your servo's specification.
const int minAngle = 20;
const int maxAngle = 160;

int angle = 90;
int incomingAngle = 0;
byte digitCount = 0;
bool invalidCommand = false;

void setup() {
  Serial.begin(9600);
  motor.attach(servoPin);
  motor.write(angle);
}

void loop() {
  while (Serial.available() > 0) {
    char symbol = Serial.read();
    if (symbol == '\r') continue;
    if (symbol == '\n') {
      if (!invalidCommand && digitCount > 0 &&
          incomingAngle >= minAngle && incomingAngle <= maxAngle) {
        angle = incomingAngle;
        motor.write(angle);
        Serial.print("OK ");
        Serial.println(angle);
      } else {
        Serial.println("ERR angle");
      }
      incomingAngle = 0;
      digitCount = 0;
      invalidCommand = false;
    } else if (symbol >= '0' && symbol <= '9' && digitCount < 3) {
      incomingAngle = incomingAngle * 10 + (symbol - '0');
      digitCount++;
    } else {
      invalidCommand = true;
    }
  }
}
