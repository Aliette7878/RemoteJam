s.boot

(
{
	var gen = { rrand(1,10).reciprocal };
	BPF.ar(
		SelectX.ar(LFNoise2.kr(gen!4).exprange(0.02,2), [BrownNoise.ar, WhiteNoise.ar, PinkNoise.ar]).mean,
		LFNoise2.ar(gen!8).exprange(20,2e4),
		LFNoise2.ar(gen!8).exprange(0.1,2),
		LFNoise2.ar(gen!8).range(0.1,1)
	).clump(2).mean
	+ FreeVerb.ar(
		LFPar.ar(
			LFNoise2.ar(gen!8).exprange(20,2e4) * SinOsc.ar(1/gen!8).exprange(1,1.2), 0,
			LFNoise2.ar(gen!8).exprange(0.08,0.5) * EnvGen.ar(
				Env.perc.blend(Env.sine, LFNoise2.kr(gen!8)).circle,
				timeScale: gen!8 // LFNoise2.ar(gen!8).range(1/5, 5)
			)
		).clump(2).mean,
		LFNoise2.ar(1/5)
	)
	+ Pan2.ar(
		Pluck.ar(
			WhiteNoise.ar ! 2,
			Dust.ar(LFNoise2.kr(gen!2).exprange(1/5,5)),
			1/200, LFNoise2.kr(gen!2).exprange(1/14000,1/200),
			LFNoise2.kr(gen!2).range(1,10),
			LFNoise2.kr(gen!2).range(0,1),
			LFNoise2.kr(gen!2).exprange(0.2,1)
		),
		LFNoise2.kr(gen!2).range(-1,1)
	).sum
	/ 3;
}.play
)