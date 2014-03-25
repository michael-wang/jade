package com.studioirregular.gaoframework;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

public class LaunchSplash {

	public void setMinimumDuration(int millis) {
		
		this.minDurationMS = millis;
	}
	
	public boolean showSplash(Activity activity, int splashDrawableId, int imageViewId) {
		
		View v = activity.findViewById(imageViewId);
		
		if (v == null || !(v instanceof ImageView)) {
			return false;
		}
		
		splashView = (ImageView)v;
		splashView.setImageResource(splashDrawableId);
		
		startTime = System.currentTimeMillis();
		
		return true;
	}
	
	public void hideSplash(Activity activity, int containerViewId) {
		
		splashViewContainer = findContainer(activity, containerViewId);
		
		if (splashView == null || splashViewContainer == null) {
			return;
		}
		
		final long duration = System.currentTimeMillis() - startTime;
		
		if (duration >= minDurationMS) {
			splashView.post(hide);
			
		} else {
			final long delay = (long)minDurationMS - duration;
			splashView.postDelayed(hide, delay);
		}
	}
	
	private ViewGroup findContainer(Activity activity, int containerViewId) {
		
		View container = activity.findViewById(containerViewId);
		
		if (container == null || !(container instanceof ViewGroup)) {
			return null;
		}
		
		return (ViewGroup)container;
	}
	
	private Runnable hide = new  Runnable() {
		
		@Override
		public void run() {
			
			if (splashViewContainer != null) {
				splashView.setImageBitmap(null);
				splashViewContainer.removeView(splashView);
			}
			
			splashViewContainer = null;
			splashView = null;
		}
	};
	
	private ImageView splashView;
	private ViewGroup splashViewContainer;
	
	private int minDurationMS;
	private long startTime;
}
