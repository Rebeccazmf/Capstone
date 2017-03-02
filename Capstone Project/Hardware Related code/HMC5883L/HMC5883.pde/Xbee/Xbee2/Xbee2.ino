
char letter;
void setup() {
Serial.begin(9600);
}

void loop() {
  Serial.write('a');
  delay(400);
  if (!Serial.available()){
 letter= Serial.read();
  Serial.print(letter);
}
}

