
/* LEAD MELODY */


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





