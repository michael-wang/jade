package com.studioirregular.gaoframework;

import android.util.Log;

public class AndroidTransform {

	private static final String TAG = "java-AndroidTransform";
	private static final boolean DEBUG_LOG = false;
	
	private float translateX = 0;
	private float translateY = 0;
	private float rotationInRadian = 0;
	private float scale = 1;
	
	public AndroidTransform() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "AndroidTransform");
		}
	}
	
	public void SetTranslate(float x, float y) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetTranslate x:" + x + ",y:" + y);
		}
		
		this.translateX = x;
		this.translateY = y;
	}
	
	public void ModifyTranslate(float dx, float dy) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ModifyTranslate dx:" + dx + ",dy:" + dy);
		}
		
		this.translateX += dx;
		this.translateY += dy;
	}
	
	public float GetTranslateX() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetTranslateX:" + translateX);
		}
		
		return translateX;
	}
	
	public float GetTranslateY() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetTranslateY:" + translateY);
		}
		
		return translateY;
	}
	
	public void SetRotateByRadian(float value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetRotateByRadian value:" + value);
		}
		
		rotationInRadian = value;
	}
	
	public void SetRotateByDegree(int value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetRotateByDegree value:" + value);
		}
		
		rotationInRadian = (float) ((double)value * Math.PI / 180.0);
	}
	
	public void ModifyRotateByRadian(float value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ModifyRotateByRadian value:" + value);
		}
		
		rotationInRadian += value;
	}
	
	public void ModifyRotateByDegree(int value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ModifyRotateByDegree value:" + value);
		}
		
		float valueInRadian = (float) ((double)value * Math.PI / 180.0);
		rotationInRadian += valueInRadian;
	}
	
	public float GetRotateByRadian() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetRotateByRadian:" + rotationInRadian);
		}
		
		return rotationInRadian;
	}
	
	public float GetRotateByDegree() {
		
		final float result = (float) ((double) rotationInRadian * 180.0 / Math.PI);
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetRotateByDegree:" + result);
		}
		
		return result;
	}
	
	public void SetScale(float value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetScale value:" + value);
		}
		
		this.scale = value;
	}
	
	public void ModifyScale(float value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ModifyScale value:" + value);
		}
		
		this.scale += value;
	}
	
	public float GetScale() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetScale:" + scale);
		}
		
		return this.scale;
	}

	@Override
	public String toString() {
		StringBuilder result = new StringBuilder(getClass().getSimpleName());
		result.append("\n\ttranslate x:" + translateX + ",y:" + translateY);
		result.append("\n\trotation:" + GetRotateByDegree());
		result.append("\n\tscale:" + scale);
		return result.toString();
	}
	
}
