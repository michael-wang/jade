package com.studioirregular.gaoframework;

import android.app.Activity;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;

public abstract class AbsGameActivity extends Activity {

	private static final String TAG = "abs-game-activity";
	
	// provide your lua script (in string for now) to be called on update game
	// logic.
	protected abstract String delegateUpdateLua();
	protected abstract String delegateRenderLua();
	
	protected AssetHelper assetHelper = new AssetHelper();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.w(TAG, "onCreate");
		
		ActivityOnCreate(
				assetHelper.getFileContent(this, "Core.lua"),
				delegateUpdateLua(),
				delegateRenderLua());
		
		surfaceView = new MyGLSurfaceView(AbsGameActivity.this);
		setContentView(surfaceView);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		ActivityOnDestroy();
	}

	private GLSurfaceView surfaceView;
	
	private native void ActivityOnCreate(String luaCore, String luaUpdate, String luaRender);
	private native void ActivityOnDestroy();
	static {
		System.loadLibrary("gaoframework");
	}
}
