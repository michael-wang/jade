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
	
//	public void call_ActivityOnCreate() {
//		Log.w(TAG, "call_ActivityOnCreate");
//		RuntimeException e = new RuntimeException();
//		e.printStackTrace();
//		ActivityOnCreate();
//	}
//	
//	public void call_ActivityOnDestroy() {
//		Log.w(TAG, "call_ActivityOnDestroy");
//		ActivityOnDestroy();
//	}
//	
//	public void call_SetRenderLua(String code) {
//		Log.w(TAG, "call_SetRenderLua");
//		SetRenderLua(code);
//	}
//	
//	public void call_RendererOnSurfaceChanged(int w, int h) {
//		Log.w(TAG, "call_RendererOnSurfaceChanged");
//		RendererOnSurfaceChanged(w, h);
//	}
//	
//	public void call_RendererOnDrawFrame() {
//		Log.w(TAG, "call_RendererOnDrawFrame");
//		RendererOnDrawFrame();
//	}
	
	private NativeInterface() {
		Log.w(TAG, "NativeInterface");
	}
	
	// Native APIs.


}
