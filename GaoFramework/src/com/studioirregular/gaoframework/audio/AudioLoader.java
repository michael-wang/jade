package com.studioirregular.gaoframework.audio;

import java.util.ArrayDeque;
import java.util.Queue;

import android.util.Log;
import android.os.Process;

public class AudioLoader {

	private static final String TAG = "java-AudioLoader";
	
	// Singleton.
	public static AudioLoader getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final AudioLoader instance = new AudioLoader();
	}
	
	private AudioLoader() {
	}
	
	Queue<AbsAudioResource> waiting = new ArrayDeque<AbsAudioResource>();
	
	private Thread worker;
	
	public void scheduleLoad(NonStreamingAudio audio) {
		
		Log.d(TAG, "scheduleLoad:" + audio);
		
		synchronized (waiting) {
			waiting.add(audio);
		}
		
		kickOffIfNotWorking();
	}
	
	// No need to load other audio if App destroyed.
	public void cleanRemainingTasks() {
		synchronized (waiting) {
			Log.w(TAG, "cleanRemainingTasks #tasks:" + waiting.size());
			waiting.clear();
		}
	}
	
	private synchronized void kickOffIfNotWorking() {
		
		if (worker != null) {
			return;
		}
		
		worker = new Thread() {

			@Override
			public void run() {
				
				Log.w(TAG, "new thread running:" + this.getName());
				
				while (loadNext());
				
				Log.w(TAG, "thread about to end:" + this.getName());
			}
			
		};
		worker.setPriority(Process.THREAD_PRIORITY_BACKGROUND);
		worker.start();
	}
	
	private boolean loadNext() {
		
		AbsAudioResource next = null;
		
		synchronized (AudioLoader.this) {
			
			if (waiting.isEmpty()) {
				retire();
				return false;
			} else {
				next = waiting.remove();
			}
		}
		
		if (next != null) {
			next.load();
		}
		return true;
	}
	
	private synchronized void retire() {
		worker = null;
	}
}
