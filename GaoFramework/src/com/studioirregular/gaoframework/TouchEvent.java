package com.studioirregular.gaoframework;

import android.view.MotionEvent;

public class TouchEvent {

	public float x;
	public float y;
	public int action;
	
	public TouchEvent(MotionEvent motion) {
		this.x = motion.getX();
		this.y = motion.getY();
		this.action = motion.getAction();
	}
}
