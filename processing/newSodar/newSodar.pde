/*----------------------------------------------------------------------
  Fichero:	newSodar.pde
  Documento:
  Autores:	ctemes, eukelade, milo, salvari
  Fecha:
  Descripción:
  Versión:      0.00
  Historial:    0.00
  ----------------------------------------------------------------------*/

import processing.serial.*;  // Importamos todos los metodos de serial

/// ----- constantes -----------------------------------------------------------

int CFONDO           = 0;            // color de fondo NEGRO
int CBORDE           = 100;          // color de borde GRIS
int DISTANCIA_MAXIMA = 100;          // distancia maxima que mide el sensor
int MAXX             = 1000;         // maxima ordenada de la pantalla, que sea par
int MAXY             = MAXX / 2;     // maxima abcisa de la pantalla
int CENTROX          = MAXX / 2;     // centro de coordenadas (x)
int CENTROY          = MAXY;         // centro de coordenadas (y)
int MAXD             = MAXY;         // maxima distancia a representar en la pantalla
int MEMORIA          = 30;           // numero de puntos a memorizar
int TAMP             = 30;           // tamaño de punto
int DECP             = TAMP/MEMORIA; // decremento de persistencia

/// ----- variables ------------------------------------------------------------
Serial miPuerto;

int distancia = -1;
int angulo    = 0;

String puntos = "";
int numPuntos = 0;

float[][] historia;    // {{ang0, dist0}, {ang1, dist1}, {ang2, dist2}, .... {angn, distn}}
int LONGHIST = 30;

/*----------------------------------------------------------------------
  setup
  Esta función establece los valores iniciales para configurar processing
  ----------------------------------------------------------------------*/
void setup() {
  size(MAXX, MAXY);                 // Preparamos el area de trabajo
  if (Serial.list().length > 0) {
    miPuerto = new Serial(this, Serial.list()[0] , 9600); // Preparamos el puerto serie
    miPuerto.bufferUntil('\n');    // se genera un evento serie con cada nueva linea
  }

  historia = new float[LONGHIST][2];
  for (int i=0; i < LONGHIST; i++){    // Preparamos el array de historia, lleno de ceros
    for (int j=0; j <= 1; j++){
      historia[i][j] = 0;
    }
  }
}

/*----------------------------------------------------------------------
  draw
  Esta función realiza de forma continua la actividad programada
  ----------------------------------------------------------------------*/
void draw() {
  pantalla();       // dibuja la pantalla del SODAR
  lineaBarrido();   // dibuja la linea de barrido
//  pintarPuntos();   // dibuja los puntos en la pantalla
}

/*----------------------------------------------------------------------
  pantalla
  Esta funcion dibuja la pantalla del SODAR
  ----------------------------------------------------------------------*/
void pantalla() {
  background(CFONDO);    // Color del fondo
  stroke(100);           // Color de borde
  noFill();              // Sin relleno

  // Dibuja los arcos concéntricos en múltiplos de 100 unidades de diámetro
  for (int i = 0; i <= (MAXX / 100); i++) {
    arc(CENTROX, CENTROY, 100 * i, 100 * i, PI, TWO_PI);
  }

  // Dibujamos lineas cada 20 grados
  for (int ang = 0; ang <= 180; ang = ang + 20) {
    float angulo_rad = 2*PI - radians(ang);
    line(CENTROX, CENTROY, CENTROX + MAXY * cos(angulo_rad), CENTROY +  MAXY * sin(angulo_rad));
  }
}

/*----------------------------------------------------------------------
  lineaBarrido
  Esta funcion dibuja la linea de barrido
  la linea se mueve en sentido antihorario escaneando distancias
  ----------------------------------------------------------------------*/
void lineaBarrido() {
  stroke(50, 150, 50);

  float angulo_rad = TWO_PI - radians(angulo);  // obtener angulo en radianes
  float x = MAXY * cos(angulo_rad);             // obtener coordenadas
  float y = MAXY * sin(angulo_rad);
  line(CENTROX,CENTROY,CENTROX+x,CENTROY+y);    // dibujar una linea de barrido
}

/*----------------------------------------------------------------------
  pintarPuntos
  Esta funcion dibuja los puntos en la pantalla del SODAR
  pinta tantos puntos como guarde en MEMORIA
 ----------------------------------------------------------------------*/
void pintarPuntos() {
  String[] p = split(puntos,";");         // obtener todos los puntos en memoria
  for (int f=0; f<p.length; f++) {        // para cada punto
    String[] v = split(p[f], ",");        // obtener angulo y distancia
    punto(int(v[0]),int(v[1]),DECP*f);    // pintar el punto
  }
}

/*----------------------------------------------------------------------
  funcion para pintar un punto en la pantalla del SODAR
  ----------------------------------------------------------------------*/
void punto(int angulopunto, int distanciapunto, int decpunto) {
  fill(50, 150, 50, 125);

  float angulo_rad = TWO_PI - radians(angulopunto);   // obtener angulo en radianes
  float x = distanciapunto * cos(angulo_rad);           // obtener coordenadas
  float y = distanciapunto * sin(angulo_rad);
  ellipse((CENTROX + x), (CENTROY + y), (TAMP - decpunto), (TAMP - decpunto));   // pintar punto como un circulo
}

/*----------------------------------------------------------------------
  guardaPunto
  funcion para guardar los puntos en memoria
  guarda tantos puntos como indique la constante MEMORIA
  ----------------------------------------------------------------------*/
void guardarPunto() {
  if (puntos.length() > 0){                                       // si ya hay puntos en memoria
    puntos = str(angulo) + "," + str(distancia) + ";" + puntos;   //  añadirlo al principio
  } else {                                                        // si no hay puntos en memoria
    puntos = str(angulo) + "," + str(distancia);                  //  guardarlo
  }
  
  if (numPuntos >= MEMORIA){                                      // si ya se ha llenado la memoria
    puntos = puntos.substring(0,lastindex(puntos,';'));           //  descartar puntos sobrantes
  } else {                                                        // si aun no esta llena
      numPuntos++;                                                //  incrementar el contador de puntos en memoria
  }
}

// funcion que obtiene la posicion en una cadena del ultimo caracter indicado
// ej: ultima posicion del caracter + en la cadena "1+3+4" seria 3
// (porque las cadenas empiezan en la posicion 0)

int lastindex(String s, char c) {
  int i= s.length()-1;                        // i es la posicion del final de la cadena
  while ((s.charAt(i) != c) && (i>=0)) i--;   // mientras el caracter en la posicion i no sea el buscado y no lleguemos al principio, ir hacia atras por la cadena
  return i;                                   // devolver la posicion del caracter encontrado o una posicion inexistente
}

/*----------------------------------------------------------------------
  serialEvent
  Esta funcion se llama cada vez que hay datos en el puerto serie
  ----------------------------------------------------------------------*/
void serialEvent(Serial puerto) {
  String contenidoSerie;

  contenidoSerie = puerto.readString();             // leemos el contenido del puerto serie
  if (contenidoSerie != null) {                     // si tiene datos
    contenidoSerie = trim(contenidoSerie);          // nos quedamos con los datos
    String[] valores = split(contenidoSerie, ',');  // valor[0] es el angulo en grados
                                                    // valor[1] es la distancia
                                                    // pero son strings..

    if (valores.length == 2){
      angulo = int(valores[0]);                     // el angulo a entero
      
      distancia = int(                              // de string a entero
                      map(float(valores[1]),        // valor a mapear
                          0, DISTANCIA_MAXIMA,      // rango origen
                          0 , MAXY)                 // rango destino
                     );
    } else return;
    if (distancia >= 0){
      guardarPunto();                 // si la distancia es significativa, guardamos el punto
    }
  }
}
