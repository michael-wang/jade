package com.studioirregular.gaoframework;

import java.io.File;
import java.io.IOException;
import java.util.Observable;
import java.util.Observer;

import android.app.Activity;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public abstract class AbsGameActivity extends Activity {

	private static final String TAG = "abs-game-activity";
	private static final boolean DEBUG_LOG = false;
	
	// provide your lua script (in string for now) to be called on update game
	// logic.
	protected abstract String delegateUpdateLua();
	protected abstract String delegateRenderLua();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (DEBUG_LOG) {
			Log.w(TAG, "onCreate");
		}
		
		surfaceView = new GLSurfaceView(AbsGameActivity.this);
		surfaceView.setEGLContextClientVersion(2);
		surfaceView.setOnTouchListener(surfaaceViewTouchListener);
		
		MyGLRenderer renderer = new MyGLRenderer();
		surfaceView.setRenderer(renderer);
		
		fps = new FrameRateCalculator();
		fps.addObserver(frameRateObserver);
		renderer.calculateFrameRate(fps);
		
		JavaInterface.getInstance().init(AbsGameActivity.this, renderer);
		
		copyAssetLuaFilesToStorageIfNecessary();
		
		SoundSystem.getInstance().open(AbsGameActivity.this);
		
		final File FILES_DIR = getFilesDir();
		ActivityOnCreate(
			buildPath(FILES_DIR, "lua/Core.lua"),
			buildPath(FILES_DIR, delegateUpdateLua()),
			buildPath(FILES_DIR, delegateRenderLua()));
		
		setContentView(R.layout.activity_main);
		fpsTextView = (TextView)findViewById(R.id.textview);
		
		ViewGroup contentView = (ViewGroup)findViewById(R.id.main_content);
		ViewGroup.LayoutParams lp = new ViewGroup.LayoutParams(
				ViewGroup.LayoutParams.MATCH_PARENT,
				ViewGroup.LayoutParams.MATCH_PARENT);
		// add surface view to bottom so text view can be seen.
		contentView.addView(surfaceView, 0, lp);
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
	
	private boolean copyLuaToStorage(File to) {
		if (DEBUG_LOG) {
			Log.w(TAG, "copyLuaToStorage to:" + to.getAbsolutePath());
		}
		
		AssetHelper helper = new AssetHelper();
		
		try {
			helper.copyAssetsToStorage(getAssets(), "lua", to);
		} catch (IOException e) {
			//e.printStackTrace();
			Log.e(TAG, "copyLuaToStorage exception:" + e);
			return false;
		}
		
		return true;
	}
	
	private String buildPath(File folder, String fileName) {
		return folder.getAbsolutePath() + File.separator + fileName;
	}
	
	private void copyAssetLuaFilesToStorageIfNecessary() {
		
		final boolean IS_DEBUG_BUILD = 
				(getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0;
		
		boolean needCopy = false;
		if (IS_DEBUG_BUILD) {
			// always copy for debug build.
			needCopy = true;
		} else {
			needCopy = !isFilesCopiedToStorage(LUA_FILES_COPY_STATE);
		}
		
		if (needCopy) {
			
			final File copyToPath = getFilesDir();
			
			if (copyLuaToStorage(copyToPath)) {
				setFilesCopiedToStorage(LUA_FILES_COPY_STATE);
			} else {
				Log.e(TAG, "copyAssetLuaFilesIfNecessary: failed to copy asset lua files.");
			}
		}
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		ActivityOnDestroy();
		
		SoundSystem.getInstance().close();
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		if (surfaceView != null) {
			surfaceView.onResume();
		}
		
		ActivityOnResume();
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		
		if (surfaceView != null) {
			surfaceView.onPause();
		}
		
		ActivityOnPause();
	}
	
	private View.OnTouchListener surfaaceViewTouchListener = new View.OnTouchListener() {
		
		@Override
		public boolean onTouch(View v, MotionEvent event) {
			JavaInterface.getInstance().onTouch(event);
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
	
	private native void ActivityOnCreate(
			String luaCore, String luaUpdate, String luaRender);
	private native void ActivityOnDestroy();
	private native void ActivityOnPause();
	private native void ActivityOnResume();
	
	static {
		System.loadLibrary("gaoframework");
	}
}
