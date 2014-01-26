package com.studioirregular.gaoframework;

import java.util.ArrayList;
import java.util.List;

import com.testflightapp.lib.TestFlight;

import android.util.Log;
import android.view.MotionEvent;


/*
 * UI component in lua code does not handle touch well: small moves before touch up 
 * will be recognized as slide, while player actually means tap.
 * 
 * Input system eats small moves based on predefined value: TOUCH_SLOP_SQUARE.
 * 
 * Notice: single touch only.
 */
public class InputSystem {

	private static final String TAG = "java-InputSystem";
	private static final boolean DEBUG_LOG = false;
	
	// Singleton.
	public static InputSystem getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final InputSystem instance = new InputSystem();
	}
	
	private InputSystem() {
		if (DEBUG_LOG) {
			Log.d(TAG, "InputSystem constructed.");
		}
		
		touchEvents = new ArrayList<TouchEvent>();
	}
	
	public void onTouch(MotionEvent motion) {
		
		final int action = motion.getAction();
		switch (action) {
		
		case MotionEvent.ACTION_DOWN:
			touchDown = MotionEvent.obtain(motion);
			alwaysInTapRegion = true;
			break;
			
		case MotionEvent.ACTION_MOVE:
			if (alwaysInTapRegion && stillInTapRegion(motion)) {
				// eat move event.
				return;
			}
			alwaysInTapRegion = false;
			break;
			
		case MotionEvent.ACTION_CANCEL:
		case MotionEvent.ACTION_UP:
			touchDown = null;
			alwaysInTapRegion = false;
			break;
		}
		
		addEvent(motion);
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
	
	private boolean stillInTapRegion(MotionEvent move) {
		
		if (touchDown == null) {
			return false;
		}
		
		final int dx = (int)(move.getX() - touchDown.getX());
		final int dy = (int)(move.getY() - touchDown.getY());
		final int distanceSquare = (dx * dx) + (dy * dy);
		
		if (distanceSquare <= TOUCH_SLOP_SQUARE) {
			if (DEBUG_LOG) {
				Log.w(TAG, "touch still in tap region: dx:" + dx + ",dy:" + dy);
			}
			return true;
		} else {
			return false;
		}
	}
	
	private void addEvent(MotionEvent motion) {
		
		try {
			final TouchEvent touch = new TouchEvent(motion);
			
			synchronized (touchEvents) {
				touchEvents.add(touch);
			}
		} catch (RuntimeException e) {
			if (BuildConfig.DEBUG) {
				Log.w(TAG, "addEvent exception:" + e);
			} else {
				TestFlight.log(TAG + ": add touch event exception: " + e);
			}
		}
	}
	
	private static final int TOUCH_SLOP_SQUARE = 8 * 8;
	
	private List<TouchEvent> touchEvents;
	private MotionEvent touchDown;
	private boolean alwaysInTapRegion;
}
