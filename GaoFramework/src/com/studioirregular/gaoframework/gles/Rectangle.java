package com.studioirregular.gaoframework.gles;

import android.opengl.GLES20;
import android.util.Log;

public class Rectangle extends Shape {

	@Override
	protected String TAG() {
		return "java-Rectangle";
	}

	@Override
	protected boolean DEBUG_LOG() {
		return false;
	}
	
	@Override
	public void setVertex(float... values) {
		
		// Expect 2 points: top-left and bottom-right.
		final int EXPECTED_LENGTH = 2 * COMPONENT_PER_VERTEX();
		if (values.length != EXPECTED_LENGTH) {
			throw new IllegalArgumentException("Expect #values:"
					+ EXPECTED_LENGTH + ", but got:" + values.length);
		}
		
		final float left   = values[0];
		final float top    = values[1];
		final float right  = values[2];
		final float bottom = values[3];
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "setVertex left:" + left + ",top:" + top + ",right:"
					+ right + ",bottom:" + bottom);
		}
		
		final float args[] = {
				left,  top,
				left,  bottom,
				right, top,
				right, bottom,
			};
		vertex.set(args);
	}
	
	@Override
	protected void onDraw() {
		GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, VERTEX_COUNT());
	}
	
	@Override
	protected int VERTEX_COUNT() {
		return 4;
	}
}
