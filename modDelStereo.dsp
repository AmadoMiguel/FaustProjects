import("stdfaust.lib");

// Delay function. Modulation process is added in parallel to the delay process.
del(d) = + ~ ( @(d) : *(0.75) );
modDel(d,f_LFO,modDepth) = del(d) <: _ , *(os.osc(f_LFO)*modDepth) :> _ * 0.5;

channel(c) = vgroup( "chan %c",modDel(d,f_LFO,modDepth)
             with{
                  d = hslider("del(ms)[style:knob]",50,20,1000,1)/1000 * 44100;
                  f_LFO = vslider("rate(Hz)",0,0,20,1);
                  modDepth = vslider("depth",0,0,1,0.1);
             });

// Stereo output (two wires in paralel).
modDelSt = hgroup( "Mod Delay (Stereo)",
				   par(i,2,channel(i)) );

process = button("play") : pm.djembe(60,0.3,0.4,1) <: modDelSt;