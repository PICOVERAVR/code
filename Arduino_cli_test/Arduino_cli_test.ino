void setup() {
  Serial.begin(9600);
  Serial.println("Arduino USB test!");
}

void loop() {
  if (Serial.available() > 0) {
    int inc_byte = Serial.read();
    Serial.print("Got ");
    Serial.print(inc_byte, HEX);
    Serial.print(", ");
    Serial.println((char) inc_byte);
  }
}
