package com.studioirregular.gaoframework;

import android.view.MotionEvent;

public class TouchEvent {

	public float x;
	public float y;
	public int action;
	
	public TouchEvent(MotionEvent ev) {
		x = ev.getRawX();
		y = ev.getRawY();
		action = ev.getAction();
	}
}
