package com.studioirregular.gaoframework;

import android.util.Log;

public class NativeInterface {

	private static final String TAG = "java-NativeInterface";
	private static final boolean DEBUG_LOG = false;
	
	// Singleton.
	public static NativeInterface getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final NativeInterface instance = new NativeInterface();
	}
	
	private NativeInterface() {
		if (DEBUG_LOG) {
			Log.d(TAG, "NativeInterface");
		}
	}
	
	public native void NotifyBackPressed();
}
