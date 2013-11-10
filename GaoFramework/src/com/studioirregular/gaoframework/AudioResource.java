package com.studioirregular.gaoframework;

import android.util.Log;


public class AudioResource implements AbsAudioResource {

	private static final String TAG = "java-AudioResource";
	
	public AudioResource(int type) {
		
		Log.d(TAG, "AudioResource type:" + type);
		
		if (type == NON_STREAMING) {
			impl = new NonStreamingAudio();
		} else if (type == STREAMING) {
			impl = new StreamingAudio();
		} else {
			Log.e(TAG, "Invalid type:" + type);
		}
	}
	
	@Override
	public boolean Create(String assetFile, boolean looping) {
		
		Log.d(TAG, "Create file:" + assetFile + ",looping:" + looping);
		
		if (impl != null) {
			return impl.Create(assetFile, looping);
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

	private AbsAudioResource impl;
}
