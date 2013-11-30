package com.studioirregular.gaoframework;

import android.util.Log;

public class AndroidTransform {

	private static final String TAG = "java-AndroidTransform";
	private static final boolean DEBUG_LOG = false;
	
	private float translateX = 0;
	private float translateY = 0;
	private float rotation = 0;
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
			Log.d(TAG, "GetTranslateX");
		}
		
		return translateX;
	}
	
	public float GetTranslateY() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetTranslateY");
		}
		
		return translateY;
	}
	
	public void SetRotateByRadian(float value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetRotateByRadian value:" + value);
		}
		
		rotation = value;
	}
	
	public void SetRotateByDegree(int value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetRotateByDegree value:" + value);
		}
		
		rotation = (float) ((double)value / 180.0 * Math.PI);
	}
	
	public void ModifyRotateByRadian(float value) {
		
		Log.d(TAG, "ModifyRotateByRadian value:" + value);
		
		rotation += value;
	}
	
	public void ModifyRotateByDegree(int value) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ModifyRotateByDegree value:" + value);
		}
		
		float valueInRadian = (float) ((double)value / 180.0 * Math.PI);
		rotation += valueInRadian;
	}
	
	public float GetRotateByRadian() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetRotateByRadian");
		}
		
		return rotation;
	}
	
	public float GetRotateByDegree() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "GetRotateByDegree");
		}
		
		return (float) ((double)rotation * 180.0 / Math.PI);
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
			Log.d(TAG, "GetScale");
		}
		
		return this.scale;
	}

	@Override
	public String toString() {
		StringBuilder result = new StringBuilder(getClass().getSimpleName());
		result.append("\n\ttranslate x:" + translateX + ",y:" + translateY);
		result.append("\n\trotation:" + rotation);
		result.append("\n\tscale:" + scale);
		return result.toString();
	}
	
}
