package com.studioirregular.gaoframework;

import android.util.Log;


public class AudioResource implements AbsAudioResource {

	private static final String TAG = "java-AudioResource";
	
	public AudioResource(int type) {
		
		Log.d(TAG, "AudioResource type:" + type);
		
		this.type = type == 0 ? Type.NonStreaming : Type.Streaming;
		
		if (this.type == Type.NonStreaming) {
			impl = new NonStreamingAudio();
		} else if (this.type == Type.Streaming) {
			impl = new StreamingAudio();
		}
	}
	
	@Override
	public boolean Create(String assetFile, boolean loop) {
		
		if (impl != null) {
			return impl.Create(assetFile, loop);
		}
		
		return false;
	}
	
	@Override
	public boolean Play() {
		
		if (impl != null) {
			return impl.Play();
		}
		
		return false;
	}
	
	@Override
	public void Stop() {
		
		if (impl != null) {
			impl.Stop();
		}
	}

	@Override
	public void Pause() {
		
		if (impl != null) {
			impl.Pause();
		}
	}

	@Override
	public boolean IsPlaying() {
		
		if (impl != null) {
			return impl.IsPlaying();
		}
		
		return false;
	}

	private Type type;
	private AbsAudioResource impl;
}
