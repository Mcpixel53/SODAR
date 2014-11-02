/*----------------------------------------------------------------------
  Programa diseñado para el taller de SODAR: Arduino + Processing
  OSHWDem-2014

  SODAR_01/radar_a_solved.ino

  Una solución para el primer ejercicio del curso.

  Objetivo mover el servo
 ----------------------------------------------------------------------*/

#include <Servo.h>

#define SERVO_PWM_PIN 9    // El servo lo conectamos al pin 9 del arduino (PWM)
#define ANG_PASO 2         // El paso al inicio es de 2 grados
#define ANG_MIN 0
#define ANG_MAX 180


int angulo    = ANG_MIN;   // Empezamos el barrido en el ángulo mínimo
int dir       = 1;         // Empezamos aumentando el ángulo

Servo miservo;             // Declaramos una variable de tipo servo

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
   Se ejecuta siempre repetidamente, hasta el fin de los tiempos :-)
 ----------------------------------------------------------------------*/
void loop() {
  delay(50);                          // Esperamos para que el servo acabe su último movimiento 
  miservo.write(angulo);              // Pasamos el nuevo ángulo al servo
  angulo += dir * ANG_PASO;           // Calculo el siguiente ángulo
  if (angulo >= ANG_MAX || angulo <= ANG_MIN) {  // Si el ángulo esta fuera de límites
    dir = -dir;                                  //  cambio la dirección
  }
    
}
 
