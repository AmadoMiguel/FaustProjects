import("stdfaust.lib");

waveGen = hgroup("[0]Wave Generator",
				 no.noise,os.triangle(freq),os.square(freq)*0.35,os.sawtooth(freq)*0.3 : ba.selectn(4,waveNum))
  with{
  waveNum = nentry("[0]waveform",0,0,3,1);
  freq = hslider("[1]freq",100,60,500,1);
};

// In parallel Resonant Low-pass Filters
filters = vgroup( "[1]Filters",par(i,4,someFilter(i)) )
with{
  someFilter(i) = hgroup( "[%i]Resonant Lp %i",fi.resonlp(fc,Q,0.5) )
	with {
	f = vslider("[0]Center freq (Hz)[style:knob]",100,70,2000,0.1);
	lfoFreq = vslider("[1]LFO Freq[style:knob]",3,0.1,20,0.1);
	lfoDepth = hslider("[2]LFO depth[style:knob]",500,1,2000,1);
	fc = f + os.osc(lfoFreq)*lfoDepth : max(30);
	Q = vslider("[3]Q[style:knob]",5,0.6,20,0.1);
  };
};

process = vgroup("[0]Substractive poly",waveGen <: filters :> _);