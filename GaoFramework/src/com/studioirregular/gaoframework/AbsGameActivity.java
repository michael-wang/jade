package com.studioirregular.gaoframework;

import java.io.File;
import java.io.IOException;
import java.util.Observable;
import java.util.Observer;

import android.app.Activity;
import android.content.SharedPreferences;
import android.graphics.Point;
import android.opengl.GLSurfaceView;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;

import com.studioirregular.gaoframework.audio.SoundSystem;
import com.studioirregular.gaoframework.functional.ProcessBackKeyPressed;
import com.studioirregular.gaoframework.gles.GLThread;
import com.testflightapp.lib.TestFlight;

public abstract class AbsGameActivity extends Activity {

	private static final String TAG = "abs-game-activity";
	private static final boolean DEBUG_LOG = false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (DEBUG_LOG) {
			Log.w(TAG, "onCreate");
		}
		
		TestFlight.takeOff(this.getApplication(), "e1d35c9d-3282-48a4-9ab6-2af2a52349d2");
		
		setContentView(R.layout.activity_main);
		fpsTextView = (TextView)findViewById(R.id.textview);
		
		View view = findViewById(R.id.surfaceview);
		if (view == null || !(view instanceof GLSurfaceView)) {
			throw new RuntimeException("onCreate: cannot find valid surfaceview:" + view);
		}
		
		surfaceView = (GLSurfaceView)view;
		surfaceView.setEGLContextClientVersion(2);
		surfaceView.setOnTouchListener(surfaaceViewTouchListener);
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			surfaceView.setPreserveEGLContextOnPause(true);
		}
		
		MyGLRenderer renderer = new MyGLRenderer();
		surfaceView.setRenderer(renderer);
		
		fps = new FrameRateCalculator();
		fps.addObserver(frameRateObserver);
		renderer.calculateFrameRate(fps);
		
		JavaInterface.getInstance().init(AbsGameActivity.this, renderer);
		
		if (!isFilesCopiedToStorage(LUA_FILES_COPY_STATE)) {
			copyAssetLuaFilesToStorage();
		}
		
		SoundSystem.getInstance().onCreate(AbsGameActivity.this);
		
		if (isPortraitMode()) {
			ActivityOnCreate(
					Config.WORLD_SHORT_SIDE,
					Config.WORLD_LONG_SIDE, 
					Config.Asset.GetLuaScriptPath(AbsGameActivity.this));
		} else {
			ActivityOnCreate(
					Config.WORLD_LONG_SIDE,
					Config.WORLD_SHORT_SIDE, 
					Config.Asset.GetLuaScriptPath(AbsGameActivity.this));
		}
		
//		setContentView(R.layout.activity_main);
//		fpsTextView = (TextView)findViewById(R.id.textview);
//		
//		ViewGroup contentView = (ViewGroup)findViewById(R.id.main_content);
//		ViewGroup.LayoutParams lp = new ViewGroup.LayoutParams(
//				ViewGroup.LayoutParams.MATCH_PARENT,
//				ViewGroup.LayoutParams.MATCH_PARENT);
//		// add surface view to bottom so text view can be seen.
//		contentView.addView(surfaceView, 0, lp);
	}
	
	private boolean isPortraitMode() {
		Display display = getWindowManager().getDefaultDisplay();
		Point size = new Point();
		display.getSize(size);
		
		return size.x <= size.y;
	}
	
	private static final String LUA_FILES_COPY_STATE = "lua_copied";
	
	private boolean isFilesCopiedToStorage(String whichFiles) {
		
		SharedPreferences pref = getSharedPreferences(
				Global.PREF_ASSET_FILE_COPY_STATE, MODE_PRIVATE);
		if (pref != null) {
			return pref.getBoolean(whichFiles, false);
		}
		return false;
	}
	
	private void setFilesCopiedToStorage(String whichFiles) {
		
		SharedPreferences pref = getSharedPreferences(
				Global.PREF_ASSET_FILE_COPY_STATE, MODE_PRIVATE);
		
		if (pref != null) {
			SharedPreferences.Editor editor = pref.edit();
			
			if (editor != null) {
				editor.putBoolean(whichFiles, true);
				editor.commit();
			}
		}
	}
	
	private boolean copyLuaToStorage() {
		
		File toHere = new File(Config.Asset.CopyLuaScriptFolderTo(AbsGameActivity.this));
		
		if (DEBUG_LOG) {
			Log.d(TAG, "copyLuaToStorage:" + toHere.getAbsolutePath());
		}
		
		try {
			
			AssetHelper helper = new AssetHelper();
			helper.copyAssetsToStorage(getAssets(), Config.Asset.LUA_SCRIPT_FOLDER, toHere);
			
		} catch (IOException e) {
			if (BuildConfig.DEBUG) {
				e.printStackTrace();
			}
			return false;
		}
		
		return true;
	}
	
	private void copyAssetLuaFilesToStorage() {
		
		if (copyLuaToStorage()) {
			setFilesCopiedToStorage(LUA_FILES_COPY_STATE);
		} else {
			Log.e(TAG, "copyAssetLuaFilesIfNecessary: failed to copy asset lua files.");
		}
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onDestroy");
		}
		
		ActivityOnDestroy();
		
		SoundSystem.getInstance().onDestroy();
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onResume");
		}
		
		if (surfaceView != null) {
			surfaceView.onResume();
		}
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onPause");
		}
		
		if (surfaceView != null) {
			surfaceView.onPause();
		}
	}
	
	@Override
	protected void onStart() {
		super.onStart();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onStart");
		}
		
		ActivityOnStart();
		
		SoundSystem.getInstance().onStart();
	}

	@Override
	protected void onStop() {
		super.onStop();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onStop");
		}
		
		ActivityOnStop();
		
		SoundSystem.getInstance().onStop();
	}

	@Override
	public void onBackPressed() {
		
		GLThread.getInstance().scheduleFunction(new ProcessBackKeyPressed(this));
		
		// Native will handle back key on next update, and ask activity to
		// finish if native cannot consume this back.
	}
	
	public void toFinishOnUiThread() {
		
		if (DEBUG_LOG) {
			Log.w(TAG, "toFinishOnUiThread");
		}
		
		this.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				finish();
			}
			
		});
	}
	
	private View.OnTouchListener surfaaceViewTouchListener = new View.OnTouchListener() {
		
		@Override
		public boolean onTouch(View v, MotionEvent event) {
			InputSystem.getInstance().onTouch(event);
			return true;
		}
	};
	
	private GLSurfaceView surfaceView;
	
	private FrameRateCalculator fps;
	private TextView fpsTextView;
	private Observer frameRateObserver = new Observer() {

		@Override
		public void update(Observable observable, Object data) {
			
			if (observable == fps) {
				final Float value = (Float)data;
				if (DEBUG_LOG) {
					Log.w(TAG, "fps:" + value);
				}
				
				showFPS.setFPS(value);
				AbsGameActivity.this.runOnUiThread(showFPS);
			}
		}
		
	};
	private class ShowFPS implements Runnable {

		private float value = 0;
		
		public void setFPS(float value) {
			this.value = value;
		}
		
		@Override
		public void run() {
			if (fpsTextView != null) {
				fpsTextView.setText("fps:" + value);
			}
		}
		
	};
	private ShowFPS showFPS = new ShowFPS();
	
	private native void ActivityOnCreate(int worldWidth, int worldHeight, String luaScriptPath);
	private native void ActivityOnDestroy();
	private native void ActivityOnStart();
	private native void ActivityOnStop();
	
	// On my Nexus S (running 4.1.2), it requires all dependent libs be loaded
	// in order, or UnsatisfiedLinkError is raised.
	static {
		System.loadLibrary("lua");
		System.loadLibrary("stlport_shared");
		System.loadLibrary("luabind");
		System.loadLibrary("luabins");
		System.loadLibrary("gaoframework");
	}
}
