/*----------------------------------------------------------------------
  Fichero:	sodar_plantilla.ino
  Documento:	
  Autores:	ctemes, eukelade, milo, salvari
  Fecha:        
  Descripción:	
  Versión:      0.00
  Historial:    0.00
  ----------------------------------------------------------------------*/


#include <NewPing.h>    // Importamos librerias        
#include <Servo.h>

#define ECHO_PIN 7      // pin del Arduino unido al pin ECHO del sensor
                        // (el pin ECHO devuelve el pulso de ultrasonidos emitido)
#define TRIGGER_PIN 8   // pin del Arduino unido al pin TRIGGER del sensor
                        // (el pin TRIGGER es por donde se emite el pulso de ultrasonidos)
#define SERVO_PWM_PIN 9 // pin del Arduino unido al pin PWM del servomotor
                        // (el pin PWM es el pin de control)

#define DISTANCIA_MAXIMA 100 // distancia máxima que queremos medir (en cm)
 
#define ANGULO_MIN 0    // angulo minimo del barrido (en grados)
#define ANGULO_MAX 180  // angulo maximo del barrido (en grados)
#define PASO_ANGULO 1   // paso de barrido (cantidad en que se incrementa el angulo de barrido)

#define ATRAS -1
#define ADELANTE 1

Servo miservo;    // objeto servo de la libreria Servo

NewPing sonar(TRIGGER_PIN,
              ECHO_PIN,
              DISTANCIA_MAXIMA);   // objeto sensor de ultrasonidos de la libreria NewPing
 
//------------------ FUNCION DE INICIALIZACION DEL ARDUINO ----------------
// Esta función establece los valores iniciales para configurar el arduino
//-------------------------------------------------------------------------
void setup() {
  Serial.begin(9600);   // inicia el puerto serie a la velocidad de 9600 bps
  
  miservo.attach(SERVO_PWM_PIN);    // inicia el servo indicando el pin de control
  pinMode(ECHO_PIN, INPUT);         // configura el pin de echo como un pin de entrada (lectura)
  pinMode(TRIGGER_PIN, OUTPUT);     // configura el pin de trigger como un pin de salida (escritura)
}

//--------------------- FUNCION DE TRABAJO DEL ARDUINO --------------------
// Esta función realiza de forma continua la actividad programada  
//-------------------------------------------------------------------------
void loop() {

	// esta funcion debe colocar el servo en la posicion adecuada
	// obtener una medida y enviar por el puerto serie la medida y el angulo
	// durante el recorrido del barrido

}

