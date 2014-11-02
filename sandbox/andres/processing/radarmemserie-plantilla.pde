import processing.serial.*;

/// ----- constantes -----------------------------------------------------------

int MAXX=200;				// maxima ordenada de la pantalla			
int MAXY=200;				// maxima abcisa de la pantalla
int CENTROX=MAXX / 2;		// centro de coordenadas (x)
int CENTROY=MAXY / 2;		// centro de coordenadas (y)


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
    background(255);
    size(MAXX, MAXY); 
    if (Serial.list().length > 0) {     
       miPuerto = new Serial(this, Serial.list()[0] , 9600);
       miPuerto.bufferUntil('\n'); 		// se genera un evento serie con cada nueva linea
    }
} 


//---------------------------- FUNCION DE DIBUJO --------------------------
// Esta función realiza de forma continua la actividad programada 
//-------------------------------------------------------------------------
void draw() { 
    pantalla();			// dibuja la pantalla del SODAR
    lineaBarrido();		// dibuja la linea de barrido
    pintarPuntos();		// dibuja los puntos en la pantalla
}


void pantalla() {

// Esta funcion dibuja la pantalla del SODAR
// debe ser una circunferencia con una cuadricula de puntos

}


void lineaBarrido() {

// Esta funcion dibuja la linea de barrido
// la linea se mueve en sentido antihorario escaneando distancias

}


void pintarPuntos() {

// Esta funcion dibuja los puntos en la pantalla del SODAR
// pinta tantos puntos como guarde en MEMORIA

}    


void serialEvent(Serial puerto) {  

// Esta funcion se llama cada vez que hay datos en el puerto serie
// debe obtener los valores de angulo y distancia enviados por el puerto serie
// y guardarlos en memoria

}


