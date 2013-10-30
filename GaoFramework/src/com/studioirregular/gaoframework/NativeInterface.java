package com.studioirregular.gaoframework;

import android.util.Log;

public class NativeInterface {

	private static final String TAG = "native-interface";
	
	// Singleton.
	public static NativeInterface getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final NativeInterface instance = new NativeInterface();
	}
	
	private NativeInterface() {
		Log.w(TAG, "NativeInterface");
	}
	
}
