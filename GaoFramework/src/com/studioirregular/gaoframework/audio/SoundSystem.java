package com.studioirregular.gaoframework.audio;

import java.util.HashSet;
import java.util.Set;

import android.content.Context;
import android.util.Log;

public class SoundSystem {

	private static final String TAG = "java-SoundSystem";
	private static final boolean DEBUG_LOG = false;
	
	// Singleton.
	public static SoundSystem getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final SoundSystem instance = new SoundSystem();
	}
	
	private SoundSystem() {
	}
	
	public void onCreate(Context context) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "open");
		}
		
		this.context = context;
		
		NonStreamingAudio.open();
	}
	
	public void onDestroy() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "close");
		}
		
		NonStreamingAudio.close();
		
		stopPlayingAudios();
	}
	
	public void onStart() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "start");
		}
		
		resumePlayingAudios();
	}
	
	public void onStop() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "stop");
		}
		
		pausePlayingAudios();
	}
	
	Context getContext() {
		return context;
	}
	
	// temp solution to stop background music on app terminated.
	void registerPlaying(StreamingAudio audio) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "registerPlaying:" + audio);
		}
		
		if (!playingAudios.add(audio)) {
			Log.w(TAG, "registerPlaying: this audio is already registered:" + audio);
		}
	}
	
	void unregisterPlaying(StreamingAudio audio) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "unregisterPlaying:" + audio);
		}
		
		if (!playingAudios.remove(audio)) {
			Log.w(TAG, "unregisterPlaying: this audio is not registered:" + audio);
		}
	}
	
	private void stopPlayingAudios() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "stopPlayingAudios");
		}
		
		for (StreamingAudio audio : playingAudios) {
			audio.Stop();
		}
	}
	
	private void pausePlayingAudios() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "pausePlayingAudios");
		}
		
		for (StreamingAudio audio : playingAudios) {
			audio.Pause();
		}
	}
	
	private void resumePlayingAudios() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "resumePlayingAudios");
		}
		
		for (StreamingAudio audio : playingAudios) {
			audio.Play();
		}
	}
	
	private Context context;
	private Set<StreamingAudio> playingAudios = new HashSet<StreamingAudio>();
}
