(
//Global sinusoidal envelope simulates passing of the storm
SynthDef (\global, {
	arg uitbus, duur;
	Out.kr(uitbus, EnvGen.kr(Env.sine(duur, 1), doneAction: 2))
}).send(s);
)


//wind
(
SynthDef(\wind, {
	arg inbus;
	var w1, w2;								//two identical functions, one left, one right
	w1=RLPF.ar(
		WhiteNoise.ar(1), 					//normal level, out level comes later
		LFNoise1.kr(0.5, 1000, 1100)*In.kr(inbus, 1) + 20,//filter controlled by global envelope.
												//Beware of low cutoff when using RLPF
		LFNoise1.kr(0.4, 0.45, 0.55),  // 0.55 to 1 varying reciprocal Q
		0.1*In.kr(inbus, 1)			//low level, controlled by global envelope
	);
	w2=RLPF.ar(
		WhiteNoise.ar(1),
		LFNoise1.kr(0.5, 1000, 1100)*In.kr(inbus, 1) + 20,
		LFNoise1.kr(0.4, 0.45, 0.55),
		0.1*In.kr(inbus, 1)
	);
	Out.ar(0,[w1, w2] )
}).send(s);
)


//Global controlbus
b=Bus.control(s, 1);
g=Synth(\global, [\uitbus, b, \duur: 300]); //300 is number of seconds. Change this if you like
//here comes the wind
w=Synth.after(\wind, [\inbus, b]);
..