package com.studioirregular.gaoframework.audio;

import java.io.File;

import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;
import android.util.Log;

import com.studioirregular.gaoframework.BuildConfig;

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
	public synchronized boolean Play() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Play: " + filePath);
		}
		
		load();
		
		if (mplayer.isPlaying()) {
			Log.w(TAG, "Play: audio already playing:" + filePath);
		}
		
		mplayer.start();
		SoundSystem.getInstance().registerPlaying(this);
		
		return true;
	}
	
	@Override
	public synchronized void Stop() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Stop: " + filePath);
		}
		
		if (mplayer == null) {
			if (DEBUG_LOG) {
				Log.w(TAG, "Stop: audio not playing:" + filePath);
			}
			return;
		}
		
		if (mplayer.isPlaying()) {
			// Don't stop before release media player.
			// see this issue: https://code.google.com/p/android/issues/detail?id=63345
			// mplayer.stop();
			
			onAudioStopped();
		}
	}

	@Override
	public synchronized void Pause() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Pause: " + filePath);
		}
		
		if (mplayer != null && mplayer.isPlaying()) {
			mplayer.pause();
		}
	}

	@Override
	public synchronized void Resume() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Resume: " + filePath);
		}
		
		if (mplayer != null) {
			mplayer.start();
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
	public synchronized boolean IsPlaying() {
		
		boolean result = false;
		
		if (mplayer != null) {
			result = mplayer.isPlaying();
		}
		
		if (DEBUG_LOG) {
			if (!result) {
				Log.w(TAG, "IsPlaying:" + filePath + ", result:" + result);
			}
		}
		return result;
	}
	
	@Override
	public boolean load() {
		// Make sure mplayer haven't be created yet.
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
		
		if (!looping) {
			mplayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
				
				@Override
				public void onCompletion(MediaPlayer mp) {
					
					if (DEBUG_LOG) {
						Log.w(TAG, "OnCompletionListener:" + filePath);
					}
					onAudioStopped();
				}
			});
		}
		
		return true;
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
	
	private synchronized void onAudioStopped() {
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onAudioStopped:" + filePath);
		}
		
		if (mplayer != null) {
			mplayer.release();
			mplayer = null;
		} else {
			if (BuildConfig.DEBUG) {
				Log.w(TAG, "onAudioStopped: expect mplayer != null");
			}
		}
		
		SoundSystem.getInstance().unregisterPlaying(this);
	}
	
	@Override
	public String toString() {
		return this.getClass().getSimpleName() + ":" + filePath;
	}

	private MediaPlayer mplayer;
	private String filePath;
	private boolean looping;
}
