package com.studioirregular.gaoframework;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Build;
import android.util.Log;
import android.view.View;

public class ImmersiveMode {

	private static final String TAG = "java-" + ImmersiveMode.class.getSimpleName();
	
	private Activity host;
	
	public ImmersiveMode(Activity host) {
		this.host = host;
	}
	
	@SuppressLint("InlinedApi")
	public void setImmersiveMode() {
		
		if (host == null) {
			Log.e(TAG, "setImmersiveMode expect host != null");
			return;
		}
		
		View decorView = host.getWindow().getDecorView();
		if (decorView == null) {
			Log.e(TAG, "setImmersiveMode: cannot find content view.");
			return;
		}
		
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
			decorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
					| View.SYSTEM_UI_FLAG_FULLSCREEN
					| View.SYSTEM_UI_FLAG_HIDE_NAVIGATION);
		}
	}
	
	// If you start another activity and come back, immersive mode is gone. So
	// we monitor window focus and re-set immersive mode every time we have
	// focus.
	public void onWindowFocusChanged(boolean hasFocus) {
		
		if (hasFocus) {
			setImmersiveMode();
		}
	}
}
