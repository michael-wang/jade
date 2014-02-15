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
	
	public synchronized void scheduleFunction(Runnable op) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "scheduleOperation:" + op);
		}
		
		pendingFunctions.add(op);
	}
	
	public synchronized void popPendingFunctions(Queue<Runnable> container) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "popOperations");
		}
		
		if (pendingFunctions.isEmpty()) {
			return;
		}
		
		while (!pendingFunctions.isEmpty()) {
			container.add(pendingFunctions.poll());
		}
	}
	
	private Queue<Runnable> pendingFunctions = new ArrayDeque<Runnable>();
}
