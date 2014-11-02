#include <NewPing.h>
#include <Servo.h>

#define ECHO_PIN 7 		// pin del Arduino unido al pin ECHO del sensor (el pin ECHO devuelve el pulso de ultrasonidos emitido)
#define TRIGGER_PIN 8 	// pin del Arduino unido al pin TRIGGER del sensor (el pin TRIGGER es por donde se emite el pulso de ultrasonidos)
#define SERVO_PWM_PIN 9	// pin del Arduino unido al pin PWM del servomotor (el pin PWM es el pin de control)

#define DISTANCIA_MAXIMA 100 // distancia máxima que queremos medir (en cm)
 
#define ANGULO_MIN 0	// angulo minimo del barrido (en grados)
#define ANGULO_MAX 180	// angulo maximo del barrido (en grados)
#define PASO_ANGULO 1	// paso de barrido (cantidad en que se incrementa el angulo de barrido)

#define ATRAS -1		
#define ADELANTE 1
 
int angulo = 0;			// variable para guardar el angulo de barrido (de ANGULO_MIN a ANGULO_MAX)
int direccion = 1;		// dirección del movimiento del servo

Servo miservo;			// objeto servo de la libreria Servo
NewPing sonar(TRIGGER_PIN, ECHO_PIN, DISTANCIA_MAXIMA);	// objeto sensor de ultrasonidos de la libreria NewPing
 
//------------------ FUNCION DE INICIALIZACION DEL ARDUINO ----------------
// Esta función establece los valores iniciales para configurar el arduino
//-------------------------------------------------------------------------
void setup() {
  Serial.begin(9600);				// inicia el puerto serie a la velocidad de 9600 bps
  
  miservo.attach(SERVO_PWM_PIN);	// inicia el servo indicando el pin de control
  pinMode(ECHO_PIN, INPUT);			// configura el pin de echo como un pin de entrada (lectura)
  pinMode(TRIGGER_PIN, OUTPUT);		// configura el pin de trigger como un pin de salida (escritura)
}

//--------------------- FUNCION DE TRABAJO DEL ARDUINO --------------------
// Esta función realiza de forma continua la actividad programada  
//-------------------------------------------------------------------------
void loop() {
  delay(50);							// espera 50 milisegundos
  miservo.write(angulo);				// avanza el servomotor al angulo indicado
  obtenerDistanciaEnviar(angulo);	// obtiene la distancia y envia los datos por el puerto serie

  if (angulo >= ANGULO_MAX) { direccion = ATRAS;}		// calcula la dirección de movimiento del motor
  if (angulo <= ANGULO_MIN) { direccion = ADELANTE;}	// hacia adelante o hacia atras
  
  angulo += direccion * PASO_ANGULO;		// incrementa el angulo de barrido un paso de barrido
}

// esta funcion obtiene la distancia a la que se encuentra un objeto 
// y envia por el puerto serie el angulo y la distancia del objeto encontrado
 
int obtenerDistanciaEnviar(int angulo) {
 
  int cm = sonar.ping_cm();		// obtiene la distancia en cm
  Serial.print(angulo, DEC);	// envia por puerto serie la distancia y el angulo
  Serial.print(",");			// formato:
  Serial.println(cm, DEC);		//	  angulo,distancia<FINLINEA>
}
