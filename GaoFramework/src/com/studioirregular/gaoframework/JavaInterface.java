package com.studioirregular.gaoframework;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.os.Environment;
import android.util.Log;
import android.view.MotionEvent;

import com.studioirregular.gaoframework.gles.Circle;


public class JavaInterface {

	private static final String TAG = "java-interface";
	private static final boolean DEBUG_LOG = false;
	
	// Singleton.
	public static JavaInterface getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final JavaInterface instance = new JavaInterface();
	}
	
	private JavaInterface() {
		if (DEBUG_LOG) {
			Log.d(TAG, "JavaInterface()");
		}
		
		touchEvents = new ArrayList<TouchEvent>();
	}
	
	// Java APIs for native code.
	public void draw(Rectangle rect) {
//		Log.d(TAG, "draw rect:" + rect);
		
		if (renderer != null) {
			renderer.draw(rect);
		}
	}
	
	public void DrawRectangle(int left, int top, int right, int bottom, 
			float red, float green, float blue, float alpha) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "DrawRectangle left:" + left + ",top:" + top + 
					",right:" + right + ",bottom:" + bottom + 
					",red:" + red + ",green:" + green + ",blue:" + blue + 
					",alpha:" + alpha);
		}
		
		if (renderer != null) {
			renderer.draw(
					new Rectangle(left, top, right, bottom, red, green, blue, alpha));
		}
	}
	
	public void DrawCircle(float x, float y, float radius,
			float red, float green, float blue, float alpha) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "DrawCircle x:" + x + ",y:" + y + ",radius:" + radius);
		}
		
		if (renderer != null) {
			renderer.draw(new Circle(x, y, radius, red, green, blue, alpha));
		}
	}
	
	public String GetAssetFileFolder() {
		
		if (context != null) {
			return context.getFilesDir().getAbsolutePath();
		}
		return "";
	}
	
	public String getLogFilePath() {
		
		File DOWNLOAD_FOLDER = Environment
				.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
		
		File log = new File(DOWNLOAD_FOLDER, "log.txt");
		
		if (!log.exists()) {
			try {
				log.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
				return null;
			}
		}
		
		return log.getAbsolutePath();
	}
	
	public TouchEvent[] popTouchEvents() {
		TouchEvent[] result = null;
		
		synchronized (touchEvents) {
			if (!touchEvents.isEmpty()) {
				result = new TouchEvent[touchEvents.size()];
				result = touchEvents.toArray(result);
				
				touchEvents.clear();
				if (DEBUG_LOG) {
					Log.d(TAG, "popTouchEvents #events:" + result.length);
				}
			} else {
				result = new TouchEvent[0];
			}
		}
		
		return result;
	}
	
	// For java layer, native code should not use.
	/* package */ void init(Context context, MyGLRenderer r) {
		this.context = context;
		this.renderer = r;
	}
	
	/* package */ void onTouch(MotionEvent motion) {
//		Log.d(TAG, "popTouchEvents event:" + event);
		
		synchronized (touchEvents) {
			touchEvents.add(new TouchEvent(motion));
		}
	}
	
	/* package */ Context getContext() {
		return context;
	}
	
	/* package */ MyGLRenderer getRenderer() {
		return renderer;
	}
	
	private Context context;
	private MyGLRenderer renderer;
	private List<TouchEvent> touchEvents;
}
