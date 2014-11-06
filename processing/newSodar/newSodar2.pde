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
int PBORDE           = #329632;      // color de borde del punto (RGB en hexadecimal: 329632 = 50,150,50)
int PFONDO           = 0x7D329632;   // color de fondo del punto (ARGB en hexadecimal, A indica la transparencia: 7D329632 = 125,50,150,50)
int DISTANCIA_MAXIMA = 100;          // distancia maxima que mide el sensor
int MAXX             = 1000;         // maxima ordenada de la pantalla, que sea par
int MAXY             = MAXX / 2;     // maxima abcisa de la pantalla
int CENTROX          = MAXX / 2;     // centro de coordenadas (x)
int CENTROY          = MAXY;         // centro de coordenadas (y)
int MEMORIA          = 30;           // numero de puntos a memorizar
int TAMP             = 30;           // tamaño de punto
int DECP             = TAMP/MEMORIA; // decremento de persistencia
int ANGULO	     = 0;	     // posicion del angulo en el array historia
int DISTANCIA	     = 0;	     // posicion de la distancia en el array historia


/// ----- variables ------------------------------------------------------------
Serial miPuerto;

float distancia = -1;
float angulo    = 0;

// array bidimensinal para almacenar los puntos (se almacenan tantos como indique la constante MEMORIA)
float[][] historia;   // {{ang0, dist0}, {ang1, dist1}, {ang2, dist2}, .... {angn, distn}}
int numPuntos = 0;  // indica el número de puntos almacenados en memoria (en el array historia)

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

  historia = new float[MEMORIA][2];
  for (int i=0; i < MEMORIA; i++){    // Preparamos el array de historia, lleno de ceros
    for (int j=0; j < 2; j++){
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
  pintarPuntos();   // dibuja los puntos en la pantalla
}

/*----------------------------------------------------------------------
  pantalla
  Esta funcion dibuja la pantalla del SODAR
  ----------------------------------------------------------------------*/
void pantalla() {
  background(CFONDO);    // Color del fondo
  stroke(CBORDE);           // Color de borde
  noFill();              // Sin relleno

  // Dibuja los arcos concéntricos en múltiplos de 100 unidades de diámetro
  for (int i = 0; i <= (MAXX / 100); i++) {
    arc(CENTROX, CENTROY, 100 * i, 100 * i, PI, TWO_PI);
  }

  // Dibujamos lineas cada 20 grados
  for (int ang = 0; ang <= 180; ang = ang + 20) {
    line(CENTROX, CENTROY, CENTROX + MAXY * cos(angulo), CENTROY +  MAXY * sin(angulo));
  }
}

/*----------------------------------------------------------------------
  lineaBarrido
  Esta funcion dibuja la linea de barrido
  la linea se mueve en sentido antihorario escaneando distancias
  ----------------------------------------------------------------------*/
void lineaBarrido() {
  stroke(PBORDE);
  float x = MAXY * cos(angulo);             // obtener coordenadas
  float y = MAXY * sin(angulo);
  line(CENTROX,CENTROY,CENTROX+x,CENTROY+y);    // dibujar una linea de barrido
}

/*----------------------------------------------------------------------
  pintarPuntos
  Esta funcion dibuja los puntos en la pantalla del SODAR
  pinta tantos puntos como guarde en MEMORIA
 ----------------------------------------------------------------------*/
void pintarPuntos() {
  for (int i=MEMORIA-numPuntos; i < MEMORIA; i++) {        // para cada punto
    punto(historia[i][ANGULO],historia[i][DISTANCIA],DECP*(i-MEMORIA-numPuntos));    // pintar el punto
  }
}

/*----------------------------------------------------------------------
  funcion para pintar un punto en la pantalla del SODAR
  ----------------------------------------------------------------------*/
void punto(float angulopunto, float distanciapunto, int decpunto) {
  fill(PFONDO);
  float x = distanciapunto * cos(angulopunto);         // obtener coordenadas
  float y = distanciapunto * sin(angulopunto);
  ellipse((CENTROX + x), (CENTROY + y), (TAMP - decpunto), (TAMP - decpunto));   // pintar punto como un circulo
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

    if (valores.length == 2) {
      angulo = TWO_PI - radians(float(valores[0])); // obtener angulo en radianes
      
      distancia = map(float(valores[1]),            // valor a mapear
                          0, DISTANCIA_MAXIMA,      // rango origen
                          0 , MAXY);                // rango destino
    } else return;

    if (distancia >= 0){                            // si la distancia es significativa, guardamos el punto
      historia[MEMORIA-numPuntos-1][ANGULO]=angulo;
      historia[MEMORIA-numPuntos-1][DISTANCIA]=distancia;
      numPuntos = (numPuntos + 1) % MEMORIA;                 
    }
  }
}

