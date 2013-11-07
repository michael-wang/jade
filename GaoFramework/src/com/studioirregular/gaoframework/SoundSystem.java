package com.studioirregular.gaoframework;

import android.content.Context;

public class SoundSystem {

	private static final String TAG = "java-soundsystem";
	
	// Singleton.
	public static SoundSystem getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final SoundSystem instance = new SoundSystem();
	}
	
	private SoundSystem() {
	}
	
	void open(Context context) {
		
		this.context = context;
		
		NonStreamingAudio.open();
	}
	
	void close() {
		NonStreamingAudio.close();
	}
	
	Context getContext() {
		return context;
	}
	
	private Context context;
}
