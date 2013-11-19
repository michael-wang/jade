package com.studioirregular.gaoframework;

import android.content.Context;
import android.content.res.Resources;
import android.media.MediaPlayer;
import android.util.Log;

public class StreamingAudio implements AbsAudioResource {

	private static final String TAG = "java-StreamingAudio";
	
	@Override
	public boolean Create(String assetFile, boolean loop) {
		
		Log.d(TAG, "Create assetFile:" + assetFile + ",loop:" + loop);
		
		this.loop = loop;
		
		Context ctx = SoundSystem.getInstance().getContext();
		Resources res = ctx.getResources();
		final String resName = assetFile.substring(0, assetFile.lastIndexOf("."));
		final String path = ctx.getPackageName() + RAW_RESOURCE_PREFIX + resName;
		int resid = res.getIdentifier(path, null, null);
		Log.w(TAG, "path:" + path + ",resid:" + resid);
		
		mplayer = MediaPlayer.create(ctx, resid);
		
		if (mplayer != null) {
			mplayer.setLooping(loop);
		}
				
		final boolean success = (mplayer != null);
		return success;
	}

	@Override
	public boolean Play() {
		
		Log.d(TAG, "Play");
		
		if (mplayer == null) {
			Log.e(TAG, "Play: call Create first.");
			return false;
		}
		
		mplayer.start();
		
		return true;
	}
	
	@Override
	public void Stop() {
		
		Log.d(TAG, "Stop");
		
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
		
		Log.d(TAG, "Pause");
		
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

	private static final String ASSET_FILE_URI_PREFIX = "file:///android_asset/";
	private static final String RAW_RESOURCE_PREFIX = ":raw/";
	
	private MediaPlayer mplayer;
	private boolean loop;
}
