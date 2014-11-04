/*----------------------------------------------------------------------
  Fichero:	sodar.pde
  Documento:	
  Autores:	ctemes, eukelade, milo, salvari
  Fecha:        
  Descripción:	
  Versión:      0.00
  Historial:    0.00
  ----------------------------------------------------------------------*/

import processing.serial.*;

/// ----- constantes -----------------------------------------------------------

int ANCHOCUADRICULA=15;       // ancho de la cuadricula
int CFONDO= 0;                // color de fondo
int DISTANCIA_MAXIMA = 100;   // distancia maxima que mide el sensor
int MAXX=1000;                // maxima ordenada de la pantalla			
int MAXY=500;                 // maxima abcisa de la pantalla
int CENTROX=MAXX / 2;         // centro de coordenadas (x)
int CENTROY=MAXY;             // centro de coordenadas (y)
int MAXD=500;                 // maxima distancia a representar en la pantalla
int MEMORIA=20;               // numero de puntos a memorizar
int TAMP=30;                  // tamaño de punto
int DECP=TAMP/MEMORIA;        // decremento de persistencia

/// ----- variables ------------------------------------------------------------

int distancia=-1;
int angulo=0;
String puntos="";
int numPuntos=0;
String contenidoSerie;
Serial miPuerto;


//------------------------ FUNCION DE INICIALIZACION ----------------------
// Esta función establece los valores iniciales para configurar processing
//-------------------------------------------------------------------------
void setup() {   
  size(MAXX, MAXY); 
  if (Serial.list().length > 0) {     
     miPuerto = new Serial(this, Serial.list()[0] , 9600);
     miPuerto.bufferUntil('\n');    // se genera un evento serie con cada nueva linea
  }
} 

//---------------------------- FUNCION DE DIBUJO --------------------------
// Esta función realiza de forma continua la actividad programada 
//-------------------------------------------------------------------------
void draw() { 
  pantalla();       // dibuja la pantalla del SODAR
  lineaBarrido();   // dibuja la linea de barrido
  pintarPuntos();   // dibuja los puntos en la pantalla
}


// Esta funcion dibuja la pantalla del SODAR
// debe ser una circunferencia con una cuadricula de puntos

void pantalla() {
  background(CFONDO);
  stroke(100);
  noFill();

  // Dibuja los arcos concéntricos en múltiplos de 100 unidades de diámetro
  for (int i = 0; i <= (MAXX / 100); i++) {
    arc(CENTROX, CENTROY, 100 * i, 100 * i, radians(180), radians(360));
  }

  // Dibuja una división cada 20 grados
  for (int i = 0; i <= 180/20; i++) {
    float angle = -90 + i * 20;
    float radAngle = radians(angle);
    line(CENTROX, CENTROY, CENTROX + MAXD*sin(radAngle), CENTROY - MAXD*cos(radAngle));
  }
}


// Esta funcion dibuja la linea de barrido
// la linea se mueve en sentido antihorario escaneando distancias

void lineaBarrido() {
  stroke(50, 150, 50);
  
  float angulo_rad= TWO_PI - radians(angulo);   // obtener angulo en radianes
  float x = MAXD*cos(angulo_rad);               // obtener coordenadas
  float y = MAXD*sin(angulo_rad);
  line(CENTROX,CENTROY,CENTROX+x,CENTROY+y);    // dibujar una linea de barrido
}


// Esta funcion dibuja los puntos en la pantalla del SODAR
// pinta tantos puntos como guarde en MEMORIA

void pintarPuntos() {
  String[] p = split(puntos,";");         // obtener todos los puntos en memoria
  for (int f=0; f<p.length; f++) {        // para cada punto
    String[] v = split(p[f], ",");        // obtener angulo y distancia
    punto(int(v[0]),int(v[1]),DECP*f);    // pintar el punto
  }
}    


// funcion para pintar un punto en la pantalla del SODAR

void punto(int angulopunto, int distanciapunto, int decpunto) {
  fill(50, 150, 50, 125);
  
  float angulo_rad= TWO_PI - radians(angulopunto);    // obtener angulo en radianes
  float x = distanciapunto*cos(angulo_rad);           // obtener coordenadas
  float y = distanciapunto*sin(angulo_rad);
  ellipse(CENTROX+x,CENTROY+y,TAMP-decpunto,TAMP-decpunto);   // pintar punto como un circulo
}


// funcion para guardar los puntos en memoria
// guarda tantos puntos como indique la constante MEMORIA

void guardarPunto() {
  if (puntos.length() > 0)                                        // si ya hay puntos en memoria
    puntos = str(angulo) + "," + str(distancia) + ";" + puntos;   // añadirlo al principio
  else                                                            // si no hay puntos en memoria
    puntos = str(angulo) + "," + str(distancia);                  // guardarlo
    if (numPuntos >= MEMORIA)                                     // si ya se ha llenado la memoria
			puntos = puntos.substring(0,lastindex(puntos,';'));   // descartar puntos sobrantes        
    else                                                          // si aun no esta llena
      numPuntos++;                                                // incrementar el contador de puntos en memoria
}

// funcion que obtiene la posicion en una cadena del ultimo caracter indicado
// ej: ultima posicion del caracter + en la cadena "1+3+4" seria 3 
// (porque las cadenas empiezan en la posicion 0)

int lastindex(String s, char c) {
  int i= s.length()-1;                        // i es la posicion del final de la cadena
  while ((s.charAt(i) != c) && (i>=0)) i--;   // mientras el caracter en la posicion i no sea el buscado y no lleguemos al principio, ir hacia atras por la cadena
  return i;   // devolver la posicion del caracter encontrado o una posicion inexistente
}


// Esta funcion se llama cada vez que hay datos en el puerto serie

void serialEvent(Serial puerto) {  
  contenidoSerie = puerto.readString();             // leemos el contenido del puerto serie
  if (contenidoSerie != null) {                     // si tiene datos
    contenidoSerie=trim(contenidoSerie);            // nos quedamos con los datos
    String[] valores = split(contenidoSerie, ',');  // y calculamos  
    try {      
      angulo = Integer.parseInt(valores[0]);        // el angulo
      distancia = int(Float.parseFloat(valores[1]) / DISTANCIA_MAXIMA * MAXD);  // y la distancia
    } catch (Exception e) {}  
  if (distancia>=0) guardarPunto();   // si la distancia es un valor real, guardamos el punto
  }
}


