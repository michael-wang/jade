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
	
	/*
	 * Unless specify otherwise, following functions should be called in GL thread.
	 */
	// return true if back key consumed.
	public native boolean ProcessBackKey();
	public native void NotifyAlertDialogResult(boolean positiveButtonClicked);
	public native void NotifyPlayMovieComplete();
	public native void NotifyBuyResult(String id, boolean success);
	public native void NotifyPurchaseRestored(String id);
	public native void NotifyUIPresented();
	public native void NotifySendMailResult(boolean success);
	public native void NotifyStateLoadedFromCloud();
	public native void NotifyGameServiceConnectionStatus(boolean connected);
	public native boolean CallBooleanLuaFunction(String name);
}
