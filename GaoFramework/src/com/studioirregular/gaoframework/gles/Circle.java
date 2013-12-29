package com.studioirregular.gaoframework.gles;

import android.opengl.GLES20;
import android.util.Log;

public class Circle extends Shape {

	@Override
	protected String TAG() {
		return "java-Circle";
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
		final float x = values[0];
		final float y = values[1];
		final float radius = values[2];
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "setVertex x:" + x + ",y:" + y + ",r:" + radius);
		}
		
		int idx = 0;
		// center
		vertex.put(idx++, x).put(idx++, y).put(idx++, 0);
		
		// vertex on circumference.
		final int CIRCUM_VERTEX_COUNT = VERTEX_COUNT() - 1;
		for (int i = 0; i < CIRCUM_VERTEX_COUNT; i++) {
			
			double percent = (i / (double) (CIRCUM_VERTEX_COUNT - 1));
			double radian = percent * 2 * Math.PI;
			
			float outer_x = (float) (x + radius * Math.cos(radian));
			float outer_y = (float) (y + radius * Math.sin(radian));
			vertex.put(idx++, outer_x).put(idx++, outer_y).put(idx++, 0);
		}
		
		vertex.finishPut();
	}
	
	@Override
	protected void onDraw() {
		GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, VERTEX_COUNT());
	}

	@Override
	protected int VERTEX_COUNT() {
		return 64;
	}
}
