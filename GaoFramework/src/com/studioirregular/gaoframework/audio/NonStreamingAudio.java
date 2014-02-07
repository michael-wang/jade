package com.studioirregular.gaoframework.audio;

import android.content.Context;
import android.content.res.Resources;
import android.media.AudioManager;
import android.media.SoundPool;
import android.util.Log;

import com.studioirregular.gaoframework.BuildConfig;

public class NonStreamingAudio implements AbsAudioResource {

	private static final String TAG = "java-NonStreamingAudio";
	private static final boolean DEBUG_LOG = true;
	
	private static SoundPool soundPool = null;
	static void open() {
		soundPool = new SoundPool(MAX_STREAMS, AudioManager.STREAM_MUSIC, 0);
	}
	
	static void close() {
		if (soundPool != null) {
			soundPool.release();
			soundPool = null;
		}
	}
	
	public NonStreamingAudio() {
		super();
		
		this.soundID = INVALID_SOUND_ID;
		this.streamID = INVALID_STREAM_ID;
	}
	
	@Override
	public boolean Create(String path, boolean loop) {
		if (DEBUG_LOG) {
			Log.d(TAG, "Create: path:" + path + ",loop:" + loop);
		}
		
		this.filePath = path;
		this.loop = loop;
		
		AudioLoader.getInstance().scheduleLoad(this);
		return true;
	}
	
	@Override
	public boolean Play() {
		if (DEBUG_LOG) {
			Log.d(TAG, "Play");
		}
		
		if (soundID == INVALID_SOUND_ID) {
			if (DEBUG_LOG) {
				Log.w(TAG, "Play: sound not ready:" + filePath);
			}
			return false;
		}
		
		final int loopMode = loop ? LOOP_FOREVER : NO_LOOP;
		
		streamID = soundPool.play(soundID, MAX_VOLUME, MAX_VOLUME, NORMAL_PRIORITY,
				loopMode, PLAYBACK_RATE_NORMAL);
		
		final boolean success = (streamID != INVALID_STREAM_ID);
		if (!success) {
			Log.e(TAG, "Play: failed to play sound file:" + filePath);
		}
		
		return success;
	}
	
	@Override
	public void Stop() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Stop");
		}
	}

	@Override
	public void Pause() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Pause");
		}
	}
	
	@Override
	public void SetLoop(boolean loop) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetLoop:" + loop);
		}
		
		this.loop = loop;
		
		if (soundPool != null) {
			final int loopMode = loop ? LOOP_FOREVER : NO_LOOP;
			soundPool.setLoop(streamID, loopMode);
		}
	}

	@Override
	public void SetVolume(float volume) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetVolume:" + volume);
		}
		
		if (soundPool != null) {
			soundPool.setVolume(streamID, volume, volume);
		}
	}
	
	@Override
	public boolean IsPlaying() {
		
		if (BuildConfig.DEBUG) {
			Log.w(TAG, "IsPlayer: NO IMPLEMENTATION, why need to know if a sound is playing?");
		}
		return false;
	}

	@Override
	public String toString() {
		return super.toString() + ":" + filePath;
	}
	
	@Override
	public boolean load() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "doCreate:" + filePath);
		}
		if (filePath.startsWith("/")) {
			soundID = loadFromStorage(filePath);
		} else {
			soundID = loadFromResource(filePath);
		}
		
		final boolean success = (soundID != INVALID_SOUND_ID);
		
		if (success) {
			if (DEBUG_LOG) {
				Log.d(TAG, "SUCCESS to load path:" + filePath);
			}
		} else {
			Log.e(TAG, "FAILED to load path:" + filePath);
		}
		
		return success;
	}
	
	private int loadFromResource(String path) {
		
		// Resource names cannot contain file extension, remove it.
		path = path.substring(0, path.lastIndexOf("."));
		
		if (DEBUG_LOG) {
			Log.d(TAG, "loadFromResource path:" + path);
		}
		
		Context ctx = SoundSystem.getInstance().getContext();
		if (ctx == null) {
			return INVALID_SOUND_ID;
		}
		
		Resources res = ctx.getResources();
		if (res == null) {
			return INVALID_SOUND_ID;
		}
		
		final int resid = res.getIdentifier(path, "raw", ctx.getPackageName());
		if (resid == 0) {
			if (DEBUG_LOG || BuildConfig.DEBUG) {
				Log.e(TAG, "Unable to find raw resource:" + path);
			}
			return INVALID_SOUND_ID;
		}
		
		return soundPool.load(ctx, resid, 1);
	}
	
	private int loadFromStorage(String path) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "loadFromStorage path:" + path);
		}
		
		return soundPool.load(path, 1);
	}
	
	private static final int INVALID_SOUND_ID = 0;
	private static final int INVALID_STREAM_ID = 0;
	private static final int   MAX_STREAMS = 8;
	private static final float MAX_VOLUME = 1.0f;
	private static final int   NORMAL_PRIORITY = 1;
	private static final int   NO_LOOP = 0;
	private static final int   LOOP_FOREVER = -1;
	private static final float PLAYBACK_RATE_NORMAL = 1.0f; /* 0.5 ~ 2.0 */
	
	private String filePath;
	private boolean loop;
	
	private int soundID = INVALID_SOUND_ID;
	private int streamID = INVALID_STREAM_ID;
}
