package com.studioirregular.gaoframework;

import java.io.File;
import java.io.IOException;

import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.studioirregular.gaoframework.functional.BuyProduct;
import com.studioirregular.gaoframework.functional.NotifyPlayMovieResult;
import com.studioirregular.gaoframework.functional.NotifySendMailResult;
import com.studioirregular.gaoframework.functional.NotifyUIPresented;
import com.studioirregular.gaoframework.functional.PlayMovie;
import com.studioirregular.gaoframework.functional.PresentAlertDialog;
import com.studioirregular.gaoframework.functional.RestorePurchases;
import com.studioirregular.gaoframework.functional.ShowAchievements;
import com.studioirregular.gaoframework.functional.ShowAllLeaderboards;
import com.studioirregular.gaoframework.functional.ToastMessage;
import com.studioirregular.gaoframework.gles.Circle;
import com.studioirregular.gaoframework.gles.GLThread;
import com.studioirregular.gaoframework.gles.Rectangle;


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
	
	public void ShowMessage(String title, String message) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowMessage title:" + title + ",message:" + message);
		}
		
		message = GetString(message);
		
		// Let's use toast, for we don't want this kind of messages to interrupt user.
		// For those which need user attention, we use ShowDialogWithChoices.
		ToastMessage operation = new ToastMessage(context, message);
		((AbsGameActivity)context).runOnUiThread(operation);
	}
	
	public void ShowDialogWithChoices(String title, String msg, String yes, String no) {
		
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
	
	public void ShowDialogWithChoices(String title, String yes, String no, String format, String[] formatValues) {
		
		if (DEBUG_LOG) {
		Log.d(TAG, "ShowDialogWithFormat title:" + title + ",yes:" + yes
				+ ",no:" + no + ",format:" + format + ",#values"
				+ formatValues.length);
		}
		
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
		
		Intent sendMail = new Intent(Intent.ACTION_SEND);
		sendMail.setType("message/rfc822");
		
		if (!TextUtils.isEmpty(recipient)) {
			sendMail.putExtra(Intent.EXTRA_EMAIL  , new String[]{recipient});
		}
		if (!TextUtils.isEmpty(subject)) {
			sendMail.putExtra(Intent.EXTRA_SUBJECT, subject);
		}
		if (!TextUtils.isEmpty(text)) {
			sendMail.putExtra(Intent.EXTRA_TEXT   , text);
		}
		
		Intent chooseEmailApp = Intent.createChooser(sendMail, GetString("debug_cannot_test_iap_ok"));
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
	
	// In App Billing
	public void BuyProduct(String id) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "BuyProduct id:" + id);
		}
		
		AbsGameActivity activity = (AbsGameActivity)context;
		BuyProduct buy = new BuyProduct(id, activity);
		activity.runOnUiThread(buy);

		// For debug: send fake purchase success to lua.
//		NotifyBuyProductResult notify = new NotifyBuyProductResult(id, true);
//		GLThread.getInstance().scheduleFunction(notify);
	}
	
	public void RestorePurchases() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "RestorePurchases");
		}
		
		AbsGameActivity activity = (AbsGameActivity)context;
		RestorePurchases restore = new RestorePurchases(activity);
		activity.runOnUiThread(restore);
	}
	
	// Google Play Game service
	public void ShowLeaderboard(String id) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowLeaderboard id:" + id);
		}
		
		ShowAllLeaderboards show = new ShowAllLeaderboards();
		((AbsGameActivity)context).runOnUiThread(show);
		
		GLThread.getInstance().scheduleFunction(new NotifyUIPresented());
	}
	
	public void ShowAchievements() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowAchievements");
		}
		
		ShowAchievements show = new ShowAchievements();
		((AbsGameActivity)context).runOnUiThread(show);
		
		GLThread.getInstance().scheduleFunction(new NotifyUIPresented());
	}
	
	public boolean IsGooglePlayGameServiceReady() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "IsGooglePlayGameServiceReady");
		}
		
		return GameServices.getInstance().isConnected();
	}
	
	public void SubmitAchievement(String id, float value, boolean unlock) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SubmitAchievement id:" + id + ",value:" + value + ",unlock:" + unlock);
		}
		
		final String idValue = GetString(id);
		if (idValue.equals(id)) {
			throw new IllegalArgumentException("SubmitAchievement invalid id:" + id);
		}
		
		GameServices.getInstance().SubmitAchievement(idValue, value, unlock);
	}
	
	public void SubmitScore(String id, int value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SubmitScore id:" + id + ",value:" + value);
		}
		
		final String idValue = GetString(id);
		if (idValue.equals(id)) {
			throw new IllegalArgumentException("SubmitAchievement invalid id:" + id);
		}
		
		GameServices.getInstance().SubmitScore(idValue, value);
	}
	
	/*
	 * Cloud Save.
	 */
	public void SaveStateToCloud(String fileName) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SaveStateToCloud fileName:" + fileName);
		}
		
		GameServices.getInstance().SaveStateToCloud(fileName);
	}
	
	public void LoadStateFromCloud() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "LoadStateFromCloud");
		}
		
		GameServices.getInstance().LoadStateFromCloud();
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
