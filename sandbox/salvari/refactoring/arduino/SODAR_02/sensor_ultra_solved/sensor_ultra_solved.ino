/*----------------------------------------------------------------------
  Programa diseñado para el taller de SODAR: Arduino + Processing
  OSHWDem-2014

  SODAR_02/sensor_ultra_solved_a/sensor_ultra_a_solved.ino

  Calcular distancias con el sensor de ultrasonidos
 ----------------------------------------------------------------------*/

#define ECHO_PIN    7 // El pin "echo" de sensor estará en el pin 7 del arduino
#define TRIGGER_PIN 8 // El pin "trigger" del sensor estará en el pin 8 del arduino


float dist, time;

/*----------------------------------------------------------------------
  setup
   Se ejecuta una sola vez al principio del programa. O cuando el arduino
   se resetea.
 ----------------------------------------------------------------------*/
void setup() {
  pinMode(TRIGGER_PIN, OUTPUT);  // pin trigger es salida
  pinMode(ECHO_PIN   , INPUT );  // pin echo es entrada
  
  Serial.begin(9600);        // Abrimos el puerto serie
}


/*----------------------------------------------------------------------
  loop
   Se ejecuta siempre repetidamente, hasta el fin de los tiempos :-)
 ----------------------------------------------------------------------*/
void loop() {

                                        // Preparamos el sensor
  digitalWrite(TRIGGER_PIN, LOW);       //   Nivel bajo para estabilizar
  delayMicroseconds(5);                 //   garantizamos 5 microsegundos
  
                                        // Enviamos un pulso de 10 microsegundos
  digitalWrite(TRIGGER_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGGER_PIN, LOW);
  
                                        // Leemos el echo, viene codificado en 
  time = pulseIn(ECHO_PIN, HIGH);       // el ancho del pulso
  
  
  
  dist = time / 29 /2;                  // Calculamos la distancia
                                        //  y la imprimimos
  Serial.println(dist);
  
  delay(60);

}
