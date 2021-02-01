
/* LEAD MELODY */

SynthDef(\blip_lead, {|out=0 freq=400 pan=0 amp=1 dur rel=0.5 numHarm=15 gate=1 index=10 index2=1|
	var env, mod1, mod2, sig;
	env = EnvGen.ar(Env.adsr(0.1,0.1,0.5,rel), gate, doneAction: 2);
	mod1 = SinOsc.ar(freq,0,index);
	mod2 = SinOsc.ar(freq) * freq * index2;
	sig = Blip.ar(freq + mod2, numHarm, 1 + mod1);
	Out.ar(out, Pan2.ar(sig*env*amp)); }).store;


Scale.directory
Tuning.directory
~scale = Scale.dorian(\just);

Pdef(\x, Pbind(\instrument, \blip_lead,
	\amp,Pseq([0.25,0.25,0.5],inf),\dur, Pseq([1/4,1/4,1/2,1,1/8,1/8,1/2],inf),
	\legato,1.5,
	\octave,Pxrand([3,4,5],inf), \index, Pwhite(0.125,0.75),\index2, Pwhite(0.125,0.5),
	\numHarm, Pwhite(1, 15),
	\degree, Pseq([0,2,4,6,5,3,0,2,1],inf), \scale, ~scale));

Pdef(\x).play;

SynthDef(\FM_mel, {|out=0 freq=400 pan=0 amp=1 dur rel=0.1 index=0.1 gate=1 width=0.4|
	var env, sig, mod1, car;

	env = EnvGen.ar(Env.adsr(0.005,0.001,0.5, rel), gate, doneAction: 2);

	mod1 = Saw.ar(freq) * freq * index;

	car = Pulse.ar(freq+ mod1,width);
		car = MoogLadder.ar(car, SinOsc.kr(freq*0.01).range(300,6000), 0.5,5.0);
	Out.ar(out, Pan2.ar(car*env*amp)); }).store;

SynthDef(\melodySynth, {|out=0 amp=0.25 freq=440 dur=0.25 rel=0.1 widthMod=0.01 res=0.1|
	var gate, env,filtEnv,sig;
	gate = EnvGen.kr(Env([1,0],[dur+rel],1));
	env = EnvGen.ar(Env.adsr(dur/4,dur/8,0.5,rel),gate,doneAction:2);
	sig = Mix(Pulse.ar([freq*0.499,freq,freq*2.02],LFNoise2.kr(widthMod).range(0.1,0.95),0.33));
	filtEnv = EnvGen.ar(Env.adsr(dur/2,dur/3,0.5,rel*0.75),gate,doneAction:0);
	sig = MoogVCF.ar(sig, Rand(1000,8000)*filtEnv, res,3);
	Out.ar(out, Pan2.ar(sig*amp*env, 0)) }).add;

SynthDef(\bells, {|out=0 dur=0.25 freq=110 amp=1 rel=0.001 gate=1|
	var env,sig,sig2,vecMod;
	//gate = EnvGen.kr(Env([1,0],[dur+rel]),1);
	env = EnvGen.ar(Env.adsr(0.05,0.01,0.5,rel),gate,doneAction:2);
	sig = SinOsc.ar([freq*0.496,freq*0.5,freq*0.503],Rand(0.0,1.0)!3,0.05!3);
	sig = sig + SinOsc.ar([freq*0.975,freq,freq*1.025],Rand(0.0,1.0)!3,0.1!3);
	sig = sig + SinOsc.ar([freq*1.976,freq*2,freq*2.01],Rand(0.0,1.0)!3,0.08!3);
	sig =sig + SinOsc.ar([freq*3.975,freq*4,freq*4.049],Rand(0.0,1.0)!3,0.075!3);
	sig = Mix(sig + SinOsc.ar([freq*7.965,freq*8.01,freq*8.03],Rand(0.0,1.0)!3,0.05!3));
	Out.ar(out, Pan2.ar(sig*env*amp,0)) }).store;

SynthDef(\strangeBells, {|out=0 dur=0.25 freq=110 amp=1 overlap=0.001 vecFreq=0.5|
	var env,gate,sig,sig2,vecMod;
	gate = EnvGen.kr(Env([1,0],[dur+overlap]),1);
	env = EnvGen.ar(Env.adsr(dur*0.5,dur*0.25,0.5,overlap),gate,doneAction:2);
	sig = SinOsc.ar([freq*0.496,freq*0.5,freq*0.503],Rand(0.0,1.0)!3,0.05!3);
	sig = sig + SinOsc.ar([freq*0.975,freq,freq*1.025],Rand(0.0,1.0)!3,0.1!3);
	sig = sig + SinOsc.ar([freq*1.976,freq*2,freq*2.01],Rand(0.0,1.0)!3,0.08!3);
	sig =sig + SinOsc.ar([freq*3.975,freq*4,freq*4.049],Rand(0.0,1.0)!3,0.075!3);
	sig = Mix(sig + SinOsc.ar([freq*7.965,freq*8.01,freq*8.03],Rand(0.0,1.0)!3,0.05!3));

	sig2 = Pulse.ar([freq*0.496,freq*0.5,freq*0.503],LFNoise2.kr(Rand(0.1,0.9)).range(0.1,0.8)!3,0.05!3);
	sig2 = sig + Pulse.ar([freq*0.975,freq,freq*1.025],LFNoise2.kr(Rand(0.1,0.9)).range(0.1,0.8)!3,0.1!3);
	sig2 = sig + Pulse.ar([freq*1.976,freq*2,freq*2.01],LFNoise2.kr(Rand(0.1,0.9)).range(0.1,0.8)!3,0.08!3);
	sig2 = sig + Pulse.ar([freq*3.975,freq*4,freq*4.049],LFNoise2.kr(Rand(0.1,0.9)).range(0.1,0.8)!3,0.075!3);
	sig2 = Mix(sig + Pulse.ar([freq*7.965,freq*8.01,freq*8.03],LFNoise2.kr(Rand(0.1,0.9)).range(0.1,0.8)!3,0.05!3));

	vecMod = SinOsc.ar(vecFreq,0,0.5,1);

	sig = Mix( (sig * vecMod) + ( sig2 * ( 1 - vecMod)) );

	Out.ar(out, Pan2.ar(sig*env*amp,0)) }).add;


/* BASSES */
	SynthDef(\FM_bass, {|out=0 freq=400 pan=0 amp=1 dur rel=0.1 index=0.1 gate=1 width=0.4|
	var env, sig, mod1, car;

	env = EnvGen.ar(Env.asr(0.005, 1,rel),gate, doneAction: 2);

	mod1 = Saw.ar(freq) * freq * index;

	car = Saw.ar(freq+ mod1).tanh;
	car = RLPF.ar(car, 800, Rand(0.1,0.6), 2);
		Out.ar(out, Pan2.ar(car*env*amp, SinOsc.kr(Rand(10,1000) ).range(-1.0,-0.25)  ); ); }).store;



/* PERCUSSIVE */
SynthDef(\kick, {|out=0 freq=200 rq=0.4 rel=0.25 amp=0.5|
		var env, sig;
		env = EnvGen.ar(Env.perc(0.001, rel), doneAction: 2);
		sig = RLPF.ar( WhiteNoise.ar(1), freq, rq, 10).tanh;
		sig = MidEQ.ar(sig, 100,0.3,8,3);

		Out.ar(out, Pan2.ar(sig*env*amp, 0.5) ); }).store;

SynthDef(\hat, {|out=0 freq=1000 rq=0.4 rel=0.25 amp=0.5|
		var env, sig;
		env = EnvGen.ar(Env.perc(0.001, rel), doneAction: 2);
		sig = RHPF.ar( WhiteNoise.ar(1), freq, rq, 2).tanh;
		sig = MidEQ.ar(sig, 2000,0.3,8,1);

		Out.ar(out, Pan2.ar(sig*env*amp, -0.5) ); }).store;





