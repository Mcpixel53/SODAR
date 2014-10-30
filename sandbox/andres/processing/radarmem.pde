// version processing (java)

import processing.serial.*;

int ANCHOCUADRICULA=15;
int CFONDO= #B0C4DE; // #D3D3D3;
int MINANG=0;
int MAXANG=180;
int MAX_DISTANCE = 100;
int PASO = 10;
int MAXX=200;
int MAXY=200;
int MAXD=75;
int MEMORIA=5;
int TAMP=15;
int DECP=TAMP/MEMORIA;
int d=-1;
int a=0;
int s=1;
int time=0;
String puntos="";
int i=0;
String comPortString;
Serial myPort;

void setup() {   
    background(255);
    size(200, 200);
    if (Serial.list().length > 0) {     
       myPort = new Serial(this, Serial.list()[0] , 9600);
       myPort.bufferUntil('\n'); // Trigger a SerialEvent on new line
    }
} 

void draw() { 
    pantalla();
    scanline();
    //obtenerDatos(); // solo pruebas! los datos los proporciona serialEvent
    pintarPuntos();
}

void pantalla() {
    background(CFONDO); 
    ellipse(MAXX/2,MAXY/2,MAXD+MAXD,MAXD+MAXD);
    stroke(CFONDO);  
    for(int i=0; i<MAXX; i+=ANCHOCUADRICULA) {
        line(i,0,i,MAXY);
        line(0,i,MAXX,i);
    }
    stroke(0);
}

void punto(int ap, int dp, int tp) {
        float b= TWO_PI - radians(ap);    
        float x = dp*cos(b);
        float y = dp*sin(b);
        ellipse(MAXX/2+x,MAXX/2+y,TAMP-tp,TAMP-tp);
}

void scanline() {
    float b= TWO_PI - radians(a);
    float x = MAXD*cos(b);
    float y = MAXD*sin(b); 
    line(MAXX/2,MAXX/2,MAXX/2+x,MAXY/2+y);
}
    
void serialEvent(Serial cPort) {  
    comPortString = cPort.readString();
    if (comPortString != null) {    
        comPortString=trim(comPortString);    
        String[] values = split(comPortString, ',');    
        try {      
            a = Integer.parseInt(values[0]);      
            d = int(Float.parseFloat(values[1]) / MAX_DISTANCE * MAXD);
        } catch (Exception e) {}  
  if (d>=0) guardarPunto();
    }
}

void guardarPunto() {
        if (puntos.length() > 0) 
            puntos = str(a) + "," + str(d) + ";" + puntos; 
        else 
            puntos = str(a) + "," + str(d);
        if (i >= MEMORIA) {
            puntos = puntos.substring(0,lastindex(puntos,';'));           
        }
        else
            i++;    
}

void pintarPuntos() {
    String[] p = split(puntos,";");
    for (int f=0; f<p.length; f++) {
        String[] v = split(p[f], ",");  
        punto(int(v[0]),int(v[1]),DECP*f);
    }
}

int lastindex(String s, char c) {
    int i= s.length()-1;
    while ((s.charAt(i) != c) && (i>=0)) i--;
    return i;
}

