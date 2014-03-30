package com.studioirregular.gaoframework;

import android.app.Activity;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.VideoView;

import com.studioirregular.gaoframework.functional.NotifyPlayMovieResult;
import com.studioirregular.gaoframework.gles.GLThread;

public class PlayMovieActivity extends Activity {

	private static final String TAG = "java-PlayMovieActivity";
	private static final boolean DEBUG_LOG = false;
	
	public static final String BUNDLE_MOVIE_FILE = "file";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_play_movie);
		
		immersiveMode = new ImmersiveMode(this);
		immersiveMode.setImmersiveMode();
		
		RelativeLayout contentView = (RelativeLayout)findViewById(R.id.main_content);
		if (contentView == null) {
			somethingWrong("Cannot find content view.");
			return;
		}
		
		VideoView videoView = setupVideoView(contentView);
		if (videoView == null) {
			somethingWrong("Failed to setupVideoView");
			return;
		}
		
		videoView.setOnErrorListener(errorListener);
		videoView.setOnCompletionListener(completeListener);
		
		final String filename = getIntent().getStringExtra(BUNDLE_MOVIE_FILE);
		if (DEBUG_LOG) {
			Log.d(TAG, "filename:" + filename);
		}
		
		if (shouldMuteVideo()) {
			muteVideo(videoView);
		}
		
		if (BuildConfig.DEBUG) {
			loadFromFile(filename, videoView);
		} else {
			loadFromResource(filename, videoView);
		}
		
		videoView.start();
	}
	
	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
		super.onWindowFocusChanged(hasFocus);
		
		if (immersiveMode != null) {
			immersiveMode.onWindowFocusChanged(hasFocus);
		}
	}
	
	@Override
	protected void onStop() {
		
		final boolean success = !houstonWeGotProblem;
		NotifyPlayMovieResult op = new NotifyPlayMovieResult(success);
		GLThread.getInstance().scheduleFunction(op);
		
		super.onStop();
	}
	
	private VideoView setupVideoView(RelativeLayout contentView) {
		
		VideoView vv = new VideoView(PlayMovieActivity.this);
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		
		// Now calculate layout parameters that can scale video view to match parent 
		// while maintaining video aspect ratio.
		RelativeLayout.LayoutParams param = null;
		
		final float sx = (float)metrics.widthPixels / (float)Config.MOVIE_WIDTH;
		final float sy = (float)metrics.heightPixels / (float)Config.MOVIE_HEIGHT;
		
		if (sx >= sy) {
			if (DEBUG_LOG) {
				Log.d(TAG, "sx(" + sx + ") >= sy(" + sy + "): match parent in X-axis.");
			}
			param = new RelativeLayout.LayoutParams(
					ViewGroup.LayoutParams.MATCH_PARENT,
					ViewGroup.LayoutParams.WRAP_CONTENT);
		} else {
			if (DEBUG_LOG) {
				Log.d(TAG, "sx(" + sx + ") < sy(" + sy + "): match parent in Y-axis.");
			}
			param = new RelativeLayout.LayoutParams(
					ViewGroup.LayoutParams.WRAP_CONTENT,
					ViewGroup.LayoutParams.MATCH_PARENT);
		}
		
		param.addRule(RelativeLayout.CENTER_IN_PARENT);
		
		contentView.addView(vv, param);
		
		return vv;
	}
	
	private void loadFromResource(String resourceName, VideoView view) {
		
		final String resName = resourceName.substring(0, resourceName.lastIndexOf("."));
		final int id = getResources().getIdentifier(resName, "raw", getPackageName());
		Uri uri = Uri.parse("android.resource://" + getPackageName() + "/" + id);
		if (DEBUG_LOG) {
			Log.d(TAG, "uri:" + uri);
		}
		
		view.setVideoURI(uri);
	}
	
	private void loadFromFile(String fileName, VideoView view) {
		
		final String path = Config.Asset.GetVideoPath() + fileName;
		view.setVideoPath(path);
	}
	
	private MediaPlayer.OnErrorListener errorListener = new MediaPlayer.OnErrorListener() {

		@Override
		public boolean onError(MediaPlayer mp, int what, int extra) {
			
			somethingWrong("onError what:" + what + ",extra:" + extra);
			return false;
		}
		
	};
	
	private MediaPlayer.OnCompletionListener completeListener = new MediaPlayer.OnCompletionListener() {

		@Override
		public void onCompletion(MediaPlayer mp) {
			
			if (DEBUG_LOG) {
				Log.d(TAG, "onCompletion");
			}
			
			finish();
		}
		
	};
	
	private void somethingWrong(String what) {
		
		Log.e(TAG, "Houston we got problem:" + what);
		
		houstonWeGotProblem = true;
		finish();
	}
	
	private boolean houstonWeGotProblem = false;
	private ImmersiveMode immersiveMode;
	
	private boolean shouldMuteVideo() {
		
		final boolean soundDisabled = !NativeInterface.getInstance().CallBooleanLuaFunction(Global.LUA_IS_SFX_ENABLED);
		if (soundDisabled) {
			return true;
		}
		
		final boolean musicDisabled = !NativeInterface.getInstance().CallBooleanLuaFunction(Global.LUA_IS_BGM_ENABLED);
		return musicDisabled;
	}
	
	private void muteVideo(VideoView videoView) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "muteVideo");
		}
		
		if (videoView != null) {
			videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
				
				@Override
				public void onPrepared(MediaPlayer mp) {
					
					if (mp != null) {
						mp.setVolume(0, 0);
					}
				}
			});
		}
	}

}
