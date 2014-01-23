package com.studioirregular.gaoframework;

import java.io.File;

import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;
import android.util.Log;

public class StreamingAudio implements AbsAudioResource {

	private static final String TAG = "java-StreamingAudio";
	private static final boolean DEBUG_LOG = false;
	
	@Override
	public boolean Create(String path, boolean loop) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Create path:" + path + ",loop:" + loop);
		}
		
		this.filePath = path;
		this.looping = loop;
		
		return true;
	}

	@Override
	public boolean Play() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Play: " + filePath);
		}
		
		// Notice Play can be called after Pause, in this case, mplayer already
		// created.
		if (mplayer == null) {
		
			if (filePath.startsWith("/")) {
				mplayer = loadFromStorage(filePath);
			} else {
				mplayer = loadFromResources(filePath);
			}
			
			if (mplayer == null) {
				Log.e(TAG, "Play: failed to play:" + filePath);
				return false;
			}
			
			mplayer.setLooping(looping);
		}
		
		mplayer.start();
		SoundSystem.getInstance().registerPlaying(this);
		
		return true;
	}
	
	@Override
	public void Stop() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Stop: " + filePath);
		}
		
		if (mplayer != null) {
			if (mplayer.isPlaying()) {
				mplayer.stop();
			}
			
			mplayer.release();
			mplayer = null;
		}
		
		SoundSystem.getInstance().unregisterPlaying(this);
	}

	@Override
	public void Pause() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Pause");
		}
		
		if (mplayer != null && mplayer.isPlaying()) {
			mplayer.pause();
		}
	}

	@Override
	public void SetLoop(boolean loop) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetLoop:" + loop);
		}
		
		this.looping = loop;
		
		if (mplayer != null) {
			mplayer.setLooping(loop);
		}
	}

	@Override
	public void SetVolume(float volume) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetVolume:" + volume);
		}
		
		if (mplayer != null) {
			mplayer.setVolume(volume, volume);
		}
	}

	@Override
	public boolean IsPlaying() {
		
		if (mplayer != null) {
			return mplayer.isPlaying();
		}
		
		return false;
	}
	
	private MediaPlayer loadFromStorage(String path) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "loadFromStorage path:" + path);
		}
		
		Context ctx = SoundSystem.getInstance().getContext();
		final Uri uri = Uri.fromFile(new File(path));
		
		return MediaPlayer.create(ctx, uri);
	}
	
	private MediaPlayer loadFromResources(String path) {
		
		// Resource names cannot contain file extension, remove it.
		path = path.substring(0, path.lastIndexOf("."));
		
		if (DEBUG_LOG) {
			Log.d(TAG, "loadFromResources path:" + path);
		}
		
		Context ctx = SoundSystem.getInstance().getContext();
		
		final int resid = ctx.getResources().getIdentifier(path, "raw", ctx.getPackageName());
		
		if (resid == 0) {
			if (DEBUG_LOG) {
				Log.e(TAG, "Unable to find resource id for path:" + path);
			}
			return null;
		}
		return MediaPlayer.create(ctx, resid);
	}

	private MediaPlayer mplayer;
	private String filePath;
	private boolean looping;
}
