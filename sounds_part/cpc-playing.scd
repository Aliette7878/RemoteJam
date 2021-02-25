s.boot;

(
{var ampOsc;
	ampOsc = SinOsc.kr(0.5, 1.5pi, 0.5, 0.5);
	SinOsc.ar(440, 0, ampOsc);
}.play;
)

{SinOsc.ar}.freqscope;

{[SinOsc.ar(220,0,0.2), Saw.ar(880,0.2)]}.play;

{SinOsc.ar([440,880], 0, 0.2)}.play();

(
{var sig, amp;
	amp = SinOsc.kr([7,1]).range(0,1);
	sig = SinOsc.ar([300, 500]);
	sig = sig*amp;
}.play;
)


(
{var sig, amp;
	amp = SinOsc.kr([0.1,1,1,0]).range(0.05,0.2);
	//amp = 0.2;
	sig = SinOsc.ar([200, 0, 10, 100]);
	sig = sig*amp;
	sig = FreeVerb.ar(sig, room:0.7);
	Mix.new(sig)*0.25;
}.play;
)

{PinkNoise.ar(0.2) + SinOsc.ar(440, 0, 0.2) + Saw.ar(660, 0.2)}.play;


SynthDef.new(\sine, {
	arg freq=440, amp = 1;
	var sig, env, oscfreq;
	env = SinOsc.kr([0.1,1,1,0]).range(0.05,0.2);
	oscfreq = {freq * LFNoise2.kr(0.5).range(0.98, 1.02)};
	sig = SinOsc.ar([oscfreq, 0, 10, 100]);
	sig = sig * env * amp;
	sig = FreeVerb.ar(sig, room:0.7);
	Out.ar(0, Mix.new(sig)*0.5);
}).add;

~sine = Synth(\sine, [\freq, 200, \amp, 0.1]);

SinOsc.ar(100).plot;
Env.new([0,1], [1], [3]).plot;


(
SynthDef("bass", { arg freq = 440, amp = 0.5, gate = 1;
	var snd, env, oscfreq, output;
	oscfreq = {freq * LFNoise2.kr(0.5).range(0.98, 1.02)};
	snd = Splay.ar(SinOsc.ar(oscfreq, mul: amp));
	env = Env.adsr(0.1, 4, 0.1, 0).kr(doneAction:2, gate: gate);
	snd = snd;
	output = LPF.ar(snd, (env*freq) + 2*freq);
	Out.ar(0, output);
	}).add;
)

Pbind(
	\instrument, "bass",
	\tempo, 113/60,
	\ctranspose, -26,
	\degree, Pseq([Pseq([3, 5, 1, 3, 5, 8, 1], 2), Pseq([3, 2, 5, -1], 1), Pseq([3, 2, 5, 0], 1), Pseq([1, 5, 0,1,2,5,4], 2), Pseq([1, 0,2],2), 3],inf),
	\dur, Pseq([Pseq([8, 4, 4, 8, 4, 2, 2], 2), Pseq([8,4,2, 2], 2),Pseq([8, 4, 4, 8, 4, 2, 2], 2), Pseq([8, 4, 4], 2), 16], inf),
	\legato, 1,
	\amp, 0.6,
).play;




s = Server.internal.boot;

		Server.default = Server.internal;



		// Create analyzer in a window you might want to see the spectrum of your vowels

		(

		w = Window("Frequency Spectrum", Rect(0, 0, 300, 200)); // width should be 511

		f = FreqScopeView(w, w.view.bounds);

		f.active_(true); 	// turn it on the first time;

		f.dbRange_(100); 	// turn it on the first time;

		w.onClose_({ f.kill }); // you must have this

		w.front;

		)

Quarks.install("Vowel");



Vowel(); // defaults to A bass

Vowel(\a, \bass);

Vowel(\e, \tenor);

Vowel(\i, \counterTenor);

Vowel(\o, \alto);

Vowel(\u, \soprano);



{Formants.ar(100, Vowel(\e, \bass)) * 0.1 }.play

{Formants.ar(200, Vowel(\o, \alto)) * 0.1 }.play

{Formants.ar(300, Vowel(\i, \soprano)) * 0.1 }.play