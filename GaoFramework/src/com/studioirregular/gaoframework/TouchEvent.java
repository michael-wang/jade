package com.studioirregular.gaoframework;

import android.view.MotionEvent;

public class TouchEvent {

	public float x;
	public float y;
	public int action;
	
	public TouchEvent(MotionEvent motion) throws RuntimeException {
		
		Global.World2ViewMapping w2v = Global.getWorld2ViewMapping();
		if (w2v == null) {
			throw new RuntimeException("Need game world to view transform.");
		}
		
		this.x = (motion.getX() - w2v.viewOffsetX) * w2v.worldWidth / w2v.viewWidth;
		this.y = (motion.getY() - w2v.viewOffsetY) * w2v.worldHeight / w2v.viewHeight;
		
		this.action = motion.getAction();
	}
}
