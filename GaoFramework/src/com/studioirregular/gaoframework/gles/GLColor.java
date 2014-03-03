package com.studioirregular.gaoframework.gles;


public class GLColor {

	public static final int NUMBER_OF_COMPONENTS = 4;	// r,g,b,a
	
	private float[] values;
	
	private static final int RED   = 0;
	private static final int GREEN = 1;
	private static final int BLUE  = 2;
	private static final int ALPHA = 3;
	
	public GLColor() {
		values = new float[NUMBER_OF_COMPONENTS];
		for (int i = 0; i < NUMBER_OF_COMPONENTS; i++) {
			values[i] = 0;
		}
	}
	
	public void set(float red, float green, float blue, float alpha) {
		
		checkValue(red,   "set");
		checkValue(green, "set");
		checkValue(blue,  "set");
		checkValue(alpha, "set");
		
		values[RED]   = red;
		values[GREEN] = green;
		values[BLUE]  = blue;
		values[ALPHA] = alpha;
	}
	
	public void setAlpha(float value) {
		
		checkValue(value, "setAlpha");
		
		values[ALPHA] = value;
	}
	
	// This is NOT a copy, use it with caution.
	public float[] get() {
		return values;
	}
	
	private void checkValue(float value, String name) {
		
		if (value < 0 || 1.0f < value) {
			throw new IllegalArgumentException(name + " Invalid value:" + value + ", valid range: [0, 1]");
		}
	}
}
