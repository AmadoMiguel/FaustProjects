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
	fc = vslider("[0]Center freq (Hz)[style:knob]",200,101,2000,0.1);
	q = vslider("[1]Q[style:knob]",5,1,10,0.1);
	Q = q * os.osc(lfoFreq)*lfoDepth : max(10);
	lfoFreq = vslider("[2]Q LFO Freq[style:knob]",3,0.1,20,0.1);
	lfoDepth = hslider("[3]Q LFO depth[style:knob]",500,1,2000,1);
  };
};

process = vgroup("[0]Substractive poly",waveGen <: filters :> _);
			