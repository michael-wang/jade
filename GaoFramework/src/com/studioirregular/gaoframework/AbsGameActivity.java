package com.studioirregular.gaoframework;

import java.util.Observable;
import java.util.Observer;

import android.app.Activity;
import android.content.res.AssetManager;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public abstract class AbsGameActivity extends Activity {

	private static final String TAG = "abs-game-activity";
	
	// provide your lua script (in string for now) to be called on update game
	// logic.
	protected abstract String delegateUpdateLua();
	protected abstract String delegateRenderLua();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.w(TAG, "onCreate");
		
		SoundSystem.getInstance().init(AbsGameActivity.this);
		am = getAssets();
		
		ActivityOnCreate(
			JavaInterface.getInstance(),
			am,
			"Core.lua",
			delegateUpdateLua(),
			delegateRenderLua());
		
		surfaceView = new GLSurfaceView(AbsGameActivity.this);
		surfaceView.setEGLContextClientVersion(2);
		surfaceView.setOnTouchListener(surfaaceViewTouchListener);
		
		MyGLRenderer renderer = new MyGLRenderer();
		surfaceView.setRenderer(renderer);
		
		fps = new FrameRateCalculator();
		fps.addObserver(frameRateObserver);
		renderer.calculateFrameRate(fps);
		
		JavaInterface.getInstance().init(getAssets(), renderer);
		
		setContentView(R.layout.activity_main);
		fpsTextView = (TextView)findViewById(R.id.textview);
		
		ViewGroup contentView = (ViewGroup)findViewById(R.id.main_content);
		ViewGroup.LayoutParams lp = new ViewGroup.LayoutParams(
				ViewGroup.LayoutParams.MATCH_PARENT,
				ViewGroup.LayoutParams.MATCH_PARENT);
		// add surface view to bottom so text view can be seen.
		contentView.addView(surfaceView, 0, lp);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		ActivityOnDestroy();
		am = null;
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		if (surfaceView != null) {
			surfaceView.onResume();
		}
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		
		if (surfaceView != null) {
			surfaceView.onPause();
		}
	}
	
//	@Override
//	public boolean onTouchEvent(MotionEvent event) {
//		
//		JavaInterface.getInstance().onTouch(surfaceView, event);
//		
//		return true;
//	}
	
	private View.OnTouchListener surfaaceViewTouchListener = new View.OnTouchListener() {
		
		@Override
		public boolean onTouch(View v, MotionEvent event) {
			JavaInterface.getInstance().onTouch(event);
			return true;
		}
	};
	
	private AssetManager am;
	private GLSurfaceView surfaceView;
	
	private FrameRateCalculator fps;
	private TextView fpsTextView;
	private Observer frameRateObserver = new Observer() {

		@Override
		public void update(Observable observable, Object data) {
			
			if (observable == fps) {
				final Float value = (Float)data;
				Log.w(TAG, "fps:" + value);
				
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
	
	private native void ActivityOnCreate(JavaInterface ji, AssetManager am, String luaCore,
			String luaUpdate, String luaRender);
	private native void ActivityOnDestroy();
	
	static {
		System.loadLibrary("gaoframework");
	}
}
