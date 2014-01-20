package com.studioirregular.gaoframework;

import java.io.File;

import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;
import android.util.Log;

public class StreamingAudio implements AbsAudioResource {

	private static final String TAG = "java-StreamingAudio";
	private static final boolean DEBUG_LOG = false;
	
	// TODO: delay media player creation until first play.
	@Override
	public boolean Create(String path, boolean loop) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Create path:" + path + ",loop:" + loop);
		}
		
		if (path.startsWith("/")) {
			mplayer = loadFromAsset(path);
		} else {
			mplayer = loadFromResources(path);
		}
		
		if (mplayer != null) {
			mplayer.setLooping(loop);
		}
				
		final boolean success = (mplayer != null);
		return success;
	}

	@Override
	public boolean Play() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Play");
		}
		
		if (mplayer == null) {
			Log.e(TAG, "Play: call Create first.");
			return false;
		}
		
		mplayer.start();
		
		return true;
	}
	
	@Override
	public void Stop() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Stop");
		}
		
		if (mplayer != null) {
			if (mplayer.isPlaying()) {
				mplayer.stop();
			}
			
			mplayer.release();
			mplayer = null;
		}
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
	public boolean IsPlaying() {
		
		if (mplayer != null) {
			return mplayer.isPlaying();
		}
		
		return false;
	}
	
	private MediaPlayer loadFromAsset(String path) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "loadFromAsset path:" + path);
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
}
