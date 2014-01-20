package com.studioirregular.gaoframework;

import android.util.Log;


public class AudioResource implements AbsAudioResource {

	private static final String TAG = "java-AudioResource";
	private static final boolean DEBUG_LOG = false;
	
	public AudioResource(int type) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "AudioResource type:" + type);
		}
		
		if (type == NON_STREAMING) {
			impl = new NonStreamingAudio();
		} else if (type == STREAMING) {
			impl = new StreamingAudio();
		} else {
			Log.e(TAG, "Invalid type:" + type);
		}
	}
	
	@Override
	public boolean Create(String name, boolean looping) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Create name:" + name + ",looping:" + looping);
		}
		
		final String path = Config.Asset.GetSoundPath() + name;
		
		if (impl != null) {
			return impl.Create(path, looping);
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
