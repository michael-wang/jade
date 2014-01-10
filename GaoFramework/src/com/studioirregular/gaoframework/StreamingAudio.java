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
		
		Context ctx = SoundSystem.getInstance().getContext();
		Uri uri = Uri.fromFile(new File(path));
		
		mplayer = MediaPlayer.create(ctx, uri);
		
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

	private MediaPlayer mplayer;
}
