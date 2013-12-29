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
	protected String VERTEX_SHADER_CODE() {
		return DEFAULT_VERTEX_SHADER;
	}
	
	@Override
	protected String FRAGMENT_SHADER_CODE() {
		return DEFAULT_FRAGMENT_SHADER;
	}
	
	@Override
	public void setVertex(float... values) {
		
		assert(values.length == 3);
		final float left   = values[0];
		final float top    = values[1];
		final float right  = values[2];
		final float bottom = values[3];
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "setVertex left:" + left + ",top:" + top + ",right:"
					+ right + ",bottom:" + bottom);
		}
		
		vertex.put(0, left) .put( 1,  top)   .put( 2, 0);
		vertex.put(3, left) .put( 4,  bottom).put( 5, 0);
		vertex.put(6, right).put( 7,  top)   .put( 8, 0);
		vertex.put(9, right).put(10,  bottom).put(11, 0);
		
		vertex.finishPut();
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
