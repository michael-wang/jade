package com.studioirregular.gaoframework;

import java.io.File;
import java.io.IOException;

import android.app.AlertDialog;
import android.content.Context;
import android.content.res.Resources;
import android.util.Log;

import com.studioirregular.gaoframework.gles.Circle;
import com.studioirregular.gaoframework.gles.Rectangle;
import com.testflightapp.lib.TestFlight;


public class JavaInterface {

	private static final String TAG = "java-interface";
	private static final boolean DEBUG_LOG = true;
	
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
	}
	
	// Java APIs for native code.
	public void DrawRectangle(int left, int top, int right, int bottom, 
			float red, float green, float blue, float alpha) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "DrawRectangle left:" + left + ",top:" + top + 
					",right:" + right + ",bottom:" + bottom + 
					",red:" + red + ",green:" + green + ",blue:" + blue + 
					",alpha:" + alpha);
		}
		
		if (rectangle == null) {
			rectangle = new Rectangle();
		}
		rectangle.setVertex(left, top, right, bottom);
		rectangle.setColor(red, green, blue, alpha);
		
		if (renderer != null) {
			renderer.draw(rectangle);
		}
	}
	
	public void DrawCircle(float x, float y, float radius,
			float red, float green, float blue, float alpha) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "DrawCircle x:" + x + ",y:" + y + ",radius:" + radius);
		}
		
		if (circle == null) {
			circle = new Circle();
		}
		circle.setVertex(x, y, radius);
		circle.setColor(red, green, blue, alpha);
		
		if (renderer != null) {
			renderer.draw(circle);
		}
	}
	
	public String getLogFilePath() {
		
		// Put log to where lua scripts goes.
		final String folder = Config.Asset.CopyLuaScriptFolderTo(getContext());
		File log = new File(folder, "log.txt");
		
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
		
		return InputSystem.getInstance().popTouchEvents();
	}
	
	public void NotifyBackProcessResult(boolean consumed) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "NotifyBackProcessResult consumed:" + consumed);
		}
		
		if (!consumed && context != null) {
			((AbsGameActivity)context).toFinishOnUiThread();
		}
	}
	
	public String GetString(String name) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetString name:" + name);
		}
		
		if (context == null) {
			if (BuildConfig.DEBUG) {
				throw new RuntimeException(TAG + ":GetString context == null.");
			}
			return name;
		}
		
		Resources res = context.getResources();
		final int id = res.getIdentifier(name, "name", context.getPackageName());
		
		if (id == 0) {
			if (BuildConfig.DEBUG) {
				throw new RuntimeException(TAG + ":GetString cannot find string for name:" + name);
			}
			return name;
		}
		
		try {
			return res.getString(id);
		} catch (Resources.NotFoundException e) {
			if (BuildConfig.DEBUG) {
				throw e;
			}
			return name;
		}
	}
	
	public void ShowDialog(final String title, final String msg, final String ok) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowDialog title:" + title + ",msg:" + msg + ",button:" + ok);
		}
		
		((AbsGameActivity)context).runOnUiThread(new Runnable() {

			@Override
			public void run() {
				
				AlertDialog.Builder builder = new AlertDialog.Builder(context);
				builder.setTitle(title).setMessage(msg);
				if (ok != null) {
					builder.setPositiveButton(ok, null);
				}
				
				final AlertDialog dialog = builder.create();
				dialog.show();
			}
			
		});
	}
	
	// TestFlight
	public void TestFlightPassCheckpoint(String msg) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "TestFlightPassCheckpoint msg:" + msg);
		}
		
		if (TestFlight.isActive()) {
			TestFlight.passCheckpoint(msg);
		}
	}
	
	// For java layer, native code should not use.
	/* package */ void init(Context context, MyGLRenderer r) {
		this.context = context;
		this.renderer = r;
	}
	
	/* package */ Context getContext() {
		return context;
	}
	
	public MyGLRenderer getRenderer() {
		return renderer;
	}
	
	private Context context;
	private MyGLRenderer renderer;
	
	private Circle circle;
	private Rectangle rectangle;
}
