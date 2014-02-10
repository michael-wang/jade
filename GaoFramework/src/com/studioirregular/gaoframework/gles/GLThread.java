package com.studioirregular.gaoframework.gles;

import java.util.ArrayDeque;
import java.util.Queue;

import android.util.Log;

public class GLThread {

	private static final String TAG = "java-GLThread";
	private static final boolean DEBUG_LOG = false;
	
	// Singleton.
	public static GLThread getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final GLThread instance = new GLThread();
	}
	
	private GLThread() {
		if (DEBUG_LOG) {
			Log.d(TAG, "GLThread");
		}
	}
	
	public void scheduleOperation(Runnable op) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "scheduleOperation:" + op);
		}
		
		options.add(op);
	}
	
	public boolean hasPendingOperation() {
		return !options.isEmpty();
	}
	
	public Runnable nextPendingOperation() {
		return options.remove();
	}
	
	private Queue<Runnable> options = new ArrayDeque<Runnable>();
}
