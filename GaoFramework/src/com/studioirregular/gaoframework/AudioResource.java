package com.studioirregular.gaoframework;

import android.util.Log;

public class AudioResource {

	private static final String TAG = "java-audioresource";
	
	public AudioResource() {
		this.soundID = SoundSystem.INVALID_SOUND_ID;
		this.streamID = SoundSystem.INVALID_STREAM_ID;
	}
	
	// Java API for native code.
	public boolean Create(String assetFile, boolean loop) {
		Log.d(TAG, "Create: assetFile:" + assetFile + ",loop:" + loop);
		
		this.assetFile = assetFile;
		this.loop = loop;
		
		soundID = SoundSystem.getInstance().load(assetFile);
		
		final boolean success = (soundID != SoundSystem.INVALID_SOUND_ID);
		if (!success) {
			Log.e(TAG, "Create: failed to laod sound file:" + assetFile);
		}
		
		return success;
	}
	
	// Java API for native code.
	public boolean Play() {
		Log.d(TAG, "Play");
		
		streamID = SoundSystem.getInstance().play(soundID, loop);
		
		final boolean success = (streamID != SoundSystem.INVALID_STREAM_ID);
		if (!success) {
			Log.e(TAG, "Play: failed to play sound file:" + assetFile);
		}
		
		return success;
	}
	
	private String assetFile;
	private int soundID;
	private int streamID;
	private boolean loop;
}
