#include <NewPing.h>
#include <Servo.h>

#define ECHO_PIN 7 // Arduino pin tied to echo pin on the ultrasonic sensor.
#define TRIGGER_PIN 8 // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define SERVO_PWM_PIN 9

// Maximum sensor distance is rated at 400-500cm.
#define MAX_DISTANCE 100 // Maximum distance we want to ping for (in cm).
 
#define ANGLE_MIN 0
#define ANGLE_MAX 180
#define ANGLE_STEP 5
 
int angle = 0;	// de ANGLE_MIN a ANGLE_MAX
 
// direction of servo movement
// -1 = back, 1 = forward
int dir = 1;

Servo myservo;
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);
 
void setup() {
  Serial.begin(9600);
  
  myservo.attach(SERVO_PWM_PIN);
  pinMode(ECHO_PIN, INPUT);
  pinMode(TRIGGER_PIN, OUTPUT);
}
 
void loop() {
  delay(50);

  myservo.write(angle);

  getDistanceAndSend2Serial(angle);

  if (angle >= ANGLE_MAX) { dir = -1;}
  if (angle <= ANGLE_MIN) { dir = 1;}
  
  angle += dir * ANGLE_STEP;
}
 
int getDistanceAndSend2Serial(int angle) {
 
  int cm = sonar.ping_cm();
  Serial.print(angle, DEC);
  Serial.print(",");
  Serial.println(cm, DEC);
}
