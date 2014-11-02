/*----------------------------------------------------------------------
  Programa diseñado para el taller de SODAR: Arduino + Processing
  OSHWDem-2014

  radar_a.ino Esqueleto inicial del programa

  Objetivo mover el servo
 ----------------------------------------------------------------------*/

#include <Servo.h>           // Importamos la libreria "Servo" para poder controlar el servo

#define SERVO_PWM_PIN 9      // El servo lo conectamos al pin 9 del arduino (PWM)

Servo miservo;                       // Declaramos una variable de tipo servo

/*----------------------------------------------------------------------
  setup
   Se ejecuta una sola vez al principio del programa. O cuando el arduino
   se resetea.
 ----------------------------------------------------------------------*/
void setup() {
  Serial.begin(9600);                // Abrimos el puerto serie (de momento para depurar)

  miservo.attach(SERVO_PWM_PIN);     // Asociamos el objeto servo a un pin de control  
}


/*----------------------------------------------------------------------
  loop
   Se ejecuta siempre, hasta el fin de los tiempos :-)
 ----------------------------------------------------------------------*/
void loop() {
}
 
