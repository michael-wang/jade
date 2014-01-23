package com.studioirregular.gaoframework;

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
	
	void onCreate(Context context) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "open");
		}
		
		this.context = context;
		
		NonStreamingAudio.open();
	}
	
	void onDestroy() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "close");
		}
		
		NonStreamingAudio.close();
		
		stopPlayingAudio();
	}
	
	void onStart() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "start");
		}
		
		resumePlayingAudio();
	}
	
	void onStop() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "stop");
		}
		
		pausePlayingAudio();
	}
	
	Context getContext() {
		return context;
	}
	
	// temp solution to stop background music on app terminated.
	void registerPlaying(StreamingAudio audio) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "registerPlaying:" + audio);
		}
		
		playingAudios.add(audio);
	}
	
	void unregisterPlaying(StreamingAudio audio) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "unregisterPlaying:" + audio);
		}
		
		playingAudios.remove(audio);
	}
	
	private void stopPlayingAudio() {
		
		for (StreamingAudio audio : playingAudios) {
			audio.Stop();
		}
	}
	
	private void pausePlayingAudio() {
		
		for (StreamingAudio audio : playingAudios) {
			audio.Pause();
		}
	}
	
	private void resumePlayingAudio() {
		
		for (StreamingAudio audio : playingAudios) {
			audio.Play();
		}
	}
	
	private Context context;
	private Set<StreamingAudio> playingAudios = new HashSet<StreamingAudio>();
}
