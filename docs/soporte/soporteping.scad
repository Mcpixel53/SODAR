pcbx=1.60;	// grosor pcb
pcby=45.30;	// largo pcb
pcbz=20.50;	// alto pcb

distanciasensores=26;
grosorbase=4;

module cilindro(){
translate([3,0,0])
rotate([0,90,0])	
cylinder(d=(20.50-4), h=12, center=true);
}

difference(){
union(){
translate([pcbx/2+3,0,0])	cube ([7,pcby+3,pcbz+3], center=true); //frontal

translate([2,0,-pcbz/2-grosorbase/2])	cube([10,pcby+3,grosorbase],center=true); //base
}
// ranura
translate([pcbx/2,0,-pcbz/2-grosorbase/2])	cube([0.5,pcby/2,grosorbase],center=true);

// cristal y conector
translate([pcbx/2+4/2,0,pcbz/2-2])		cube([4,11,6],center=true);
translate([pcbx/2+4/2,0,-pcbz/2+6/2])	cube([4,11,6],center=true);

union(){		// PING
cube([pcbx,pcby,pcbz], center=true);	// pcb block 
translate([0,distanciasensores/2,0])	cilindro();
translate([0,-distanciasensores/2,0])	cilindro();
}
}
