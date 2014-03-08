package com.studioirregular.gaoframework;

import java.util.List;
import java.util.Observable;
import java.util.Observer;

import org.json.JSONException;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.content.res.AssetManager;
import android.graphics.Point;
import android.opengl.GLSurfaceView;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.Display;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;

import com.studioirregular.gaoframework.audio.SoundSystem;
import com.studioirregular.gaoframework.functional.NotifyBuyProductResult;
import com.studioirregular.gaoframework.functional.NotifyPurchaseRestored;
import com.studioirregular.gaoframework.functional.ProcessBackKeyPressed;
import com.studioirregular.gaoframework.gles.GLThread;
import com.studioirregular.libinappbilling.HandlePurchaseActivityResult;
import com.studioirregular.libinappbilling.IabException;
import com.studioirregular.libinappbilling.InAppBilling;
import com.studioirregular.libinappbilling.InAppBilling.NotSupportedException;
import com.studioirregular.libinappbilling.InAppBilling.ServiceNotReadyException;
import com.studioirregular.libinappbilling.Product;
import com.studioirregular.libinappbilling.PurchasedItem;
import com.studioirregular.libinappbilling.ServerResponseCode;
import com.studioirregular.libinappbilling.SignatureVerificationException;
import com.testflightapp.lib.TestFlight;

public abstract class AbsGameActivity extends FragmentActivity {

	private static final String TAG = "abs-game-activity";
	private static final boolean DEBUG_LOG = false;
	
	private static final int IN_APP_BILLING_REQUEST_CODE = Global.FRAMEWORK_ACTIVITY_CODE_START;
	private static final int GAME_SERVICES_REQUEST_CODE = Global.FRAMEWORK_ACTIVITY_CODE_START + 1;
	private static final int SHOW_ACHIEVEMENTS_REQUEST_CODE = Global.FRAMEWORK_ACTIVITY_CODE_START + 2;
	private static final int SHOW_LEADERBOARDS_REQUEST_CODE = Global.FRAMEWORK_ACTIVITY_CODE_START + 3;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (DEBUG_LOG) {
			Log.w(TAG, "onCreate");
		}
		
		TestFlight.takeOff(this.getApplication(), "e1d35c9d-3282-48a4-9ab6-2af2a52349d2");
		
		setContentView(R.layout.activity_main);
		fpsTextView = (TextView)findViewById(R.id.textview);
		
		View view = findViewById(R.id.surfaceview);
		if (view == null || !(view instanceof GLSurfaceView)) {
			throw new RuntimeException("onCreate: cannot find valid surfaceview:" + view);
		}
		
		surfaceView = (GLSurfaceView)view;
		surfaceView.setEGLContextClientVersion(2);
		surfaceView.setOnTouchListener(surfaaceViewTouchListener);
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			surfaceView.setPreserveEGLContextOnPause(true);
		}
		
		MyGLRenderer renderer = new MyGLRenderer();
		surfaceView.setRenderer(renderer);
		
		fps = new FrameRateCalculator();
		fps.addObserver(frameRateObserver);
		renderer.calculateFrameRate(fps);
		
		JavaInterface.getInstance().init(AbsGameActivity.this, renderer);
		
		SoundSystem.getInstance().onCreate(AbsGameActivity.this);
		
		if (isPortraitMode()) {
			ActivityOnCreate(
					Config.WORLD_SHORT_SIDE,
					Config.WORLD_LONG_SIDE, 
					Config.Asset.LUA_ASSET_PATH,
					getAssets());
		} else {
			ActivityOnCreate(
					Config.WORLD_LONG_SIDE,
					Config.WORLD_SHORT_SIDE, 
					Config.Asset.LUA_ASSET_PATH,
					getAssets());
		}
		
//		setContentView(R.layout.activity_main);
//		fpsTextView = (TextView)findViewById(R.id.textview);
//		
//		ViewGroup contentView = (ViewGroup)findViewById(R.id.main_content);
//		ViewGroup.LayoutParams lp = new ViewGroup.LayoutParams(
//				ViewGroup.LayoutParams.MATCH_PARENT,
//				ViewGroup.LayoutParams.MATCH_PARENT);
//		// add surface view to bottom so text view can be seen.
//		contentView.addView(surfaceView, 0, lp);
		
		iab = new InAppBilling(getPublicKey(), null);
		iab.open(AbsGameActivity.this);
		
		GameServices.getInstance().onCreate(this);
	}
	
	private boolean isPortraitMode() {
		Display display = getWindowManager().getDefaultDisplay();
		Point size = new Point();
		display.getSize(size);
		
		return size.x <= size.y;
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onDestroy");
		}
		
		if (iab != null) {
			iab.close();
		}
		
		ActivityOnDestroy();
		
		SoundSystem.getInstance().onDestroy();
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onResume");
		}
		
		if (surfaceView != null) {
			surfaceView.onResume();
		}
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onPause");
		}
		
		if (surfaceView != null) {
			surfaceView.onPause();
		}
	}
	
	@Override
	protected void onStart() {
		super.onStart();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onStart");
		}
		
		GameServices.getInstance().onStart(GAME_SERVICES_REQUEST_CODE,
				SHOW_ACHIEVEMENTS_REQUEST_CODE, SHOW_LEADERBOARDS_REQUEST_CODE);
		
		ActivityOnStart();
		
		SoundSystem.getInstance().onStart();
	}

	@Override
	protected void onStop() {
		
		GameServices.getInstance().onStop();
		
		super.onStop();
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onStop");
		}
		
		ActivityOnStop();
		
		SoundSystem.getInstance().onStop();
	}

	@Override
	public void onBackPressed() {
		
		GLThread.getInstance().scheduleFunction(new ProcessBackKeyPressed(this));
		
		// Native will handle back key on next update, and ask activity to
		// finish if native cannot consume this back.
	}
	
	public void toFinishOnUiThread() {
		
		if (DEBUG_LOG) {
			Log.w(TAG, "toFinishOnUiThread");
		}
		
		this.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				finish();
			}
			
		});
	}
	
	private View.OnTouchListener surfaaceViewTouchListener = new View.OnTouchListener() {
		
		@Override
		public boolean onTouch(View v, MotionEvent event) {
			InputSystem.getInstance().onTouch(event);
			return true;
		}
	};
	
	private GLSurfaceView surfaceView;
	
	private FrameRateCalculator fps;
	private TextView fpsTextView;
	private Observer frameRateObserver = new Observer() {

		@Override
		public void update(Observable observable, Object data) {
			
			if (observable == fps) {
				final Float value = (Float)data;
				if (DEBUG_LOG) {
					Log.w(TAG, "fps:" + value);
				}
				
				showFPS.setFPS(value);
				AbsGameActivity.this.runOnUiThread(showFPS);
			}
		}
		
	};
	private class ShowFPS implements Runnable {

		private float value = 0;
		
		public void setFPS(float value) {
			this.value = value;
		}
		
		@Override
		public void run() {
			if (fpsTextView != null) {
				fpsTextView.setText("fps:" + value);
			}
		}
		
	};
	private ShowFPS showFPS = new ShowFPS();
	
	private native void ActivityOnCreate(int worldWidth, int worldHeight, String luaScriptPath, AssetManager am);
	private native void ActivityOnDestroy();
	private native void ActivityOnStart();
	private native void ActivityOnStop();
	
	// On my Nexus S (running 4.1.2), it requires all dependent libs be loaded
	// in order, or UnsatisfiedLinkError is raised.
	static {
		System.loadLibrary("lua");
		System.loadLibrary("stlport_shared");
		System.loadLibrary("luabind");
		System.loadLibrary("luabins");
		System.loadLibrary("gaoframework");
	}
	
	// For In App Billing.
	private InAppBilling iab;
	
	protected abstract GameProducts getGameProducts();
	protected abstract String getPublicKey();
	// Let client decide purchase activity request code so we won't risk using same code.
	
	public void buyProduct(String id) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "buyProduct id:" + id);
		}
		
		buyingProductId = id;
		
		try {
			iab.purchase(Product.Type.ONE_TIME_PURCHASE, id,
					AbsGameActivity.this, IN_APP_BILLING_REQUEST_CODE);
			return;
		} catch (NotSupportedException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (ServiceNotReadyException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (SendIntentException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (RuntimeException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (IabException e) {
			if (DEBUG_LOG) e.printStackTrace();
			
			final int code = e.errorCode.value;
			if (code == ServerResponseCode.BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED) {
				if (consumeProduct(id)) {
					// Don't call buyProduct directly here, I saw Google Play
					// return with ITEM_ALREADY_OWNED (not consumed) if I do so.
					JavaInterface.getInstance().BuyProduct(id);
					return;
				}
			}
		}
		
		notifyBuyResult(id, false);
	}
	
	public boolean consumeProduct(String id) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "consumeProduct id:" + id);
		}
		
		try {
			iab.consume(Product.Type.ONE_TIME_PURCHASE, id);
			return true;
		} catch (NotSupportedException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (ServiceNotReadyException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (RuntimeException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (IabException e) {
			if (DEBUG_LOG) e.printStackTrace();
		}
		
		return false;
	}
	
	public void restorePurchases() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "restorePurchases");
		}
		
		List<PurchasedItem> items = iab.getPurchasedProducts(Product.Type.ONE_TIME_PURCHASE);
		
		for (PurchasedItem item : items) {
			
			if (DEBUG_LOG) {
				Log.d(TAG, "=================================");
				Log.d(TAG, item.toString());
			}
			
			final String id = item.productId;
			if (getGameProducts().consumeRightAfterBought(id)) {
				// For products that should consume right after purchase, they
				// shouldn't be restored. If we got here means something wrong
				// in the purchase flow, such as lost network before we got
				// chance to consume it. And it won't cause problem for next
				// time player purchase the same product, cause we can consume
				// it then.
				if (DEBUG_LOG) {
					Log.w(TAG, "Skip product restore for:" + id);
				}
				continue;
			}
			
			NotifyPurchaseRestored notify = new NotifyPurchaseRestored(id);
			GLThread.getInstance().scheduleFunction(notify);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		
		if (GameServices.getInstance().onActivityResult(requestCode, resultCode, data)) {
			return;
		}
		
		if (requestCode == IN_APP_BILLING_REQUEST_CODE) {
			handlePurchaseActivityResult(resultCode, data);
			return;
		} else {
			super.onActivityResult(requestCode, resultCode, data);
		}
	}
	
	// I know, such a dirty state variable...
	// But buy product is an atomic process, so its dirty, not harmful.
	private String buyingProductId;
	
	private void handlePurchaseActivityResult(int resultCode, Intent data) {
		
		if (resultCode != Activity.RESULT_OK) {
			if (DEBUG_LOG) {
				Log.w(TAG, "handlePurchaseActivityResult: result code not ok:" + resultCode);
			}
			
			HandlePurchaseActivityResult helper = new HandlePurchaseActivityResult(data);
			ServerResponseCode response = helper.getResponseCode();
			if (DEBUG_LOG) {
				Log.w(TAG, "Response code:" + response);
			}
			
			if (response.value == ServerResponseCode.BILLING_RESPONSE_RESULT_ERROR) {
				// May failed because user's gmail is not in tester list.
				// Ask they to send email to me now.
				this.runOnUiThread(new Runnable() {

					@Override
					public void run() {
						askPlayerGmailToEnableTestBuying();
					}
					
				});
			}
			
			notifyBuyResult(buyingProductId, false);
			return;
		}
		
		try {
			PurchasedItem item = iab.onPurchaseActivityResult(data);
			if (getGameProducts().consumeRightAfterBought(buyingProductId)) {
				consumeProduct(buyingProductId);
				// No mater consume success or not, we have to notify buy result
				// as success since player already bought it.
			}
			notifyBuyResult(item.productId, true);
			return;
		} catch (IabException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (SignatureVerificationException e) {
			if (DEBUG_LOG) e.printStackTrace();
		} catch (JSONException e) {
			if (DEBUG_LOG) e.printStackTrace();
		}
		
		notifyBuyResult(buyingProductId, false);
	}
	
	private void notifyBuyResult(String id, boolean success) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "notifyBuyResult id:" + id + ",success:" + success);
		}
		
		NotifyBuyProductResult notify = new NotifyBuyProductResult(id, success);
		GLThread.getInstance().scheduleFunction(notify);
	}
	
	private void askPlayerGmailToEnableTestBuying() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "askPlayerGmailToEnableTestBuying");
		}
		
		new AlertDialog.Builder(AbsGameActivity.this)
			.setTitle(JavaInterface.getInstance().GetString("debug_cannot_test_iap_title"))
			.setMessage(JavaInterface.getInstance().GetString("debug_cannot_test_iap_message"))
			.setPositiveButton(JavaInterface.getInstance().GetString("debug_cannot_test_iap_ok"), 
					new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					JavaInterface.getInstance().SendEmail(
							"debug_send_from_gmail_subject",
							"debug_send_from_gmail_recipient",
							"debug_send_from_gmail_message");
				}
			})
			.setNegativeButton(JavaInterface.getInstance().GetString("debug_cannot_test_iap_no"), null)
			.create()
			.show();
	}
	
}
