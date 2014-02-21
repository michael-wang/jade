package com.studioirregular.gaoframework;

import java.io.File;
import java.io.IOException;

import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.util.Log;
import android.widget.Toast;

import com.studioirregular.gaoframework.functional.BuyProduct;
import com.studioirregular.gaoframework.functional.NotifyPlayMovieResult;
import com.studioirregular.gaoframework.functional.NotifySendMailResult;
import com.studioirregular.gaoframework.functional.NotifyUIPresented;
import com.studioirregular.gaoframework.functional.PlayMovie;
import com.studioirregular.gaoframework.functional.PresentAlertDialog;
import com.studioirregular.gaoframework.functional.RestorePurchases;
import com.studioirregular.gaoframework.functional.ToastMessage;
import com.studioirregular.gaoframework.gles.Circle;
import com.studioirregular.gaoframework.gles.GLThread;
import com.studioirregular.gaoframework.gles.Rectangle;
import com.testflightapp.lib.TestFlight;


public class JavaInterface {

	private static final String TAG = "java-JavaInterface";
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
	}
	
	// Java APIs for native code.
	public void DrawRectangle(int left, int top, int right, int bottom, 
			float red, float green, float blue, float alpha) {
		
//		if (DEBUG_LOG) {
//			Log.d(TAG, "DrawRectangle left:" + left + ",top:" + top + 
//					",right:" + right + ",bottom:" + bottom + 
//					",red:" + red + ",green:" + green + ",blue:" + blue + 
//					",alpha:" + alpha);
//		}
		
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
	
	public String GetString(String name) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetString name:" + name);
		}
		
		if (name == null || name.isEmpty()) {
			return name;
		}
		
		if (context == null) {
			if (BuildConfig.DEBUG) {
				throw new RuntimeException(TAG + ":GetString context == null.");
			}
			return name;
		}
		
		Resources res = context.getResources();
		final int id = res.getIdentifier(name, "string", context.getPackageName());
		
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
	
	public void ShowDialog(String title, String msg, String yes, String no) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowDialog title:" + title + ",msg:" + msg + ",yes:" + yes + ",no:" + no);
		}
		
		// The title/msg/ok are string resource id, not localized string.
		title = GetString(title);
		msg = GetString(msg);
		yes = yes != null ? GetString(yes) : null;
		no = no != null ? GetString(no) : null;
		
		PresentAlertDialog operation = new PresentAlertDialog(context, title, msg, yes, no);
		
		((AbsGameActivity)context).runOnUiThread(operation);
	}
	
	public void ShowDialogWithFormat(String title, String yes, String no, String format, String[] formatValues) {
		
//		if (DEBUG_LOG) {
		Log.d(TAG, "ShowDialogWithFormat title:" + title + ",yes:" + yes
				+ ",no:" + no + ",format:" + format + ",#values"
				+ formatValues.length);
		//		}
		
		title = GetString(title);
		yes = yes != null ? GetString(yes) : null;
		no = no != null ? GetString(no) : null;
		
		String[] values = new String[formatValues.length];
		for (int i = 0; i < formatValues.length; i++) {
			final String id = formatValues[i];
			values[i] = GetString(id);
		}
		
		final String msg = String.format(format, (Object[])values);
		
		PresentAlertDialog operation = new PresentAlertDialog(context, title, msg, yes, no);
		
		((AbsGameActivity)context).runOnUiThread(operation);
	}
	
	public void ToastMessage(String msg) {
		if (DEBUG_LOG) {
			Log.d(TAG, "ToastMessage msg:" + msg);
		}
		
		// The title/msg/ok are string resource id, not localized string.
		msg = GetString(msg);
		
		ToastMessage operation = new ToastMessage(context, msg);
		
		((AbsGameActivity)context).runOnUiThread(operation);
	}
	
	public boolean IsFileExist(String path) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "IsFileExist path:" + path);
		}
		
		File file = new File(path);
		return file.exists();
	}
	
	public boolean RemoveFile(String path) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "RemoveFile path:" + path);
		}
		
		File file = new File(path);
		if (!file.exists()) {
			if (DEBUG_LOG) {
				Log.w(TAG, "RemoveFile: file does not exists:" + path);
			}
			return false;
		}
		
		return file.delete();
	}
	
	// Return seconds passed since 1 January 1970, GMT, in string format.
	public String GetCurrentSystemTime() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetCurrentSystemTime");
		}
		
		long inMillis = System.currentTimeMillis();
		Long inSeconds = inMillis / 1000L;
		final String result = inSeconds.toString();
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetCurrentSystemTime result:" + result);
		}
		return result;
	}
	
	// Assume called by GL thread.
	public void PlayMovie(String filename) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "PlayMovie:" + filename);
		}
		
		if (context != null) {
			PlayMovie op = new PlayMovie((AbsGameActivity)context, filename);
			((AbsGameActivity)context).runOnUiThread(op);
		} else {
			NotifyPlayMovieResult op = new NotifyPlayMovieResult(false);
			GLThread.getInstance().scheduleFunction(op);
		}
	}
	
	public void SendEmail(String subject, String recipient, String text) {
		SendEmail(subject, recipient, text, true);
	}
	
	public void SendEmail(String subject, String recipient, String text, boolean callback) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SendEmail\n\tsubject:" + subject + "\n\trecipient:"
					+ recipient + "\n\ttext:" + text + "\n\tcallback:"
					+ callback);
		}
		
		Intent i = new Intent(Intent.ACTION_SEND);
		i.setType("message/rfc822");
		i.putExtra(Intent.EXTRA_EMAIL  , new String[]{GetString(recipient)});
		i.putExtra(Intent.EXTRA_SUBJECT, GetString(subject));
		i.putExtra(Intent.EXTRA_TEXT   , GetString(text));
		
		Intent chooseEmailApp = Intent.createChooser(i, GetString("debug_cannot_test_iap_ok"));
		AbsGameActivity activity = (AbsGameActivity)context;
		try {
			activity.startActivity(chooseEmailApp);
			
			if (callback) {
				GLThread.getInstance().scheduleFunction(new NotifyUIPresented());
				GLThread.getInstance().scheduleFunction(new NotifySendMailResult(true));
			}
		} catch (android.content.ActivityNotFoundException ex) {
		    Toast.makeText(activity, GetString("debug_choose_mail_client_failed"), Toast.LENGTH_LONG).show();
		    
			if (callback) {
				GLThread.getInstance().scheduleFunction(new NotifySendMailResult(false));
			}
		}
	}
	
	public void ShowLeaderboard(String id) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowLeaderboard id:" + id);
		}
		
		ToastMessage("debug_function_not_ready");
		
		GLThread.getInstance().scheduleFunction(new NotifyUIPresented());
	}
	
	public void ShowAchievements() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowAchievements");
		}
		
		ToastMessage("debug_function_not_ready");
		
		GLThread.getInstance().scheduleFunction(new NotifyUIPresented());
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
	
	// In App Billing
	public void BuyProduct(String id) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "BuyProduct id:" + id);
		}
		
		AbsGameActivity activity = (AbsGameActivity)context;
		BuyProduct buy = new BuyProduct(id, activity);
		activity.runOnUiThread(buy);
	}
	
	public void RestorePurchases() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "RestorePurchases");
		}
		
		AbsGameActivity activity = (AbsGameActivity)context;
		RestorePurchases restore = new RestorePurchases(activity);
		activity.runOnUiThread(restore);
	}
	
	// For java layer, native code should not use.
	/* package */ void init(Context context, MyGLRenderer r) {
		if (DEBUG_LOG) {
			Log.w(TAG, "init");
		}
		
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
