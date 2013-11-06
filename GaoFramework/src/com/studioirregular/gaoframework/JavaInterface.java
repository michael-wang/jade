package com.studioirregular.gaoframework;

import java.util.ArrayList;
import java.util.List;

import android.content.res.AssetManager;
import android.util.Log;
import android.view.MotionEvent;


public class JavaInterface {

	private static final String TAG = "java-interface";
	
	// Singleton.
	public static JavaInterface getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final JavaInterface instance = new JavaInterface();
	}
	
	private JavaInterface() {
		Log.d(TAG, "JavaInterface()");
		touchEvents = new ArrayList<TouchEvent>();
	}
	
	// Java APIs for native code.
	public void drawRectangle(int left, int top, int right, int bottom,
			float red, float green, float blue, float alpha) {
		if (renderer != null) {
			renderer.drawRectangle(left, top, right, bottom, red, green, blue, alpha, null);
		}
	}
	
	public void drawRectangle(int left, int top, int right, int bottom,
			float red, float green, float blue, float alpha, GLTexture texture) {
//		Log.d(TAG, "drawRectangle texture:" + texture);
		
		if (renderer != null) {
			renderer.drawRectangle(left, top, right, bottom, red, green, blue, alpha, texture);
		}
	}
	
	public void draw(Rectangle rect) {
//		Log.d(TAG, "draw rect:" + rect);
		
		if (renderer != null) {
			renderer.draw(rect);
		}
	}
	
	public boolean loadTexture(GLTexture texture, String fileName) {
		Log.d(TAG, "loadTexture fileName:" + fileName);
		
		if (texture == null || fileName == null) {
			return false;
		}
		
		return texture.load(assetManager, fileName);
	}
	
	public TouchEvent[] popTouchEvents() {
		TouchEvent[] result = null;
		
		synchronized (touchEvents) {
			if (!touchEvents.isEmpty()) {
				result = new TouchEvent[touchEvents.size()];
				result = touchEvents.toArray(result);
				
				touchEvents.clear();
				Log.d(TAG, "popTouchEvents #events:" + result.length);
			} else {
				result = new TouchEvent[0];
			}
		}
		
		return result;
	}
	
	// For java layer, native code should not use.
	/* package */ void init(AssetManager am, MyGLRenderer r) {
		this.assetManager = am;
		this.renderer = r;
	}
	
	/* package */ void onTouch(MotionEvent motion) {
//		Log.d(TAG, "popTouchEvents event:" + event);
		
		synchronized (touchEvents) {
			touchEvents.add(new TouchEvent(motion));
		}
	}
	
	private AssetManager assetManager;
	private MyGLRenderer renderer;
	private List<TouchEvent> touchEvents;
}
