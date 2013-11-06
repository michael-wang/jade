package com.studioirregular.gaoframework;

import java.io.IOException;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.media.AudioManager;
import android.media.SoundPool;
import android.util.Log;

public class SoundSystem {

	private static final String TAG = "java-audiorenderer";
	
	// Singleton.
	public static SoundSystem getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final SoundSystem instance = new SoundSystem();
	}
	
	private SoundSystem() {
		soundPool = new SoundPool(MAX_STREAMS, AudioManager.STREAM_MUSIC, 0);
	}
	
	public static final int INVALID_SOUND_ID = 0;
	public static final int INVALID_STREAM_ID = 0;
	
	public int load(String assetFile) {
		Log.d(TAG, "CreateAudio assetFile:" + assetFile);
		
		AssetFileDescriptor afd = null;
		try {
			afd = assetManager.openFd(assetFile);
		} catch (IOException e) {
			e.printStackTrace();
			return INVALID_SOUND_ID;
		}
		
		return soundPool.load(afd, 1);
	}
	
	public int play(int soundID, boolean loop) {
		
		final int loopValue = loop ? LOOP : NO_LOOP;
		
		return soundPool.play(soundID, MAX_VOLUME, MAX_VOLUME, PRIORITY_NORMAL,
				loopValue, PLAYBACK_RATE_NORMAL);
	}
	
	void init(Context context) {
		assetManager = context.getAssets();
	}
	
	private static final int   MAX_STREAMS = 8;
	private static final float MAX_VOLUME = 1.0f;
	private static final int   PRIORITY_NORMAL = 1;
	private static final int   NO_LOOP = 0;
	private static final int   LOOP = 1;
	private static final float PLAYBACK_RATE_NORMAL = 1.0f; /* 0.5 ~ 2.0 */
	
	private AssetManager assetManager;
	private SoundPool soundPool;
}
