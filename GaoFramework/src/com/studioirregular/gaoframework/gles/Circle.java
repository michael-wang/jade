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
	public void setVertex(float... values) {
		
		vertex.set(values);
	}
	
	@Override
	protected void onDraw() {
		GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, VERTEX_COUNT());
	}

	@Override
	protected int VERTEX_COUNT() {
		return 64;
	}
	
	private class CircleVertex extends Vertex {

		public CircleVertex(int vertexCount, int elementPerVertex) {
			super(vertexCount, elementPerVertex);
		}

		@Override
		public void set(float... values) {
			
			if (values.length != 3) {
				throw new IllegalArgumentException("Expect #values == " + 3);
			}
			
			final float x = values[0];
			final float y = values[1];
			final float radius = values[2];
			
			if (DEBUG_LOG()) {
				Log.d(TAG(), "setVertex x:" + x + ",y:" + y + ",r:" + radius);
			}
			
			fBuf.position(0);
			
			// center
			fBuf.put(x).put(y);
			
			// vertex on circumference.
			final int CIRCUM_VERTEX_COUNT = VERTEX_COUNT() - 1;
			for (int i = 0; i < CIRCUM_VERTEX_COUNT; i++) {
				
				double percent = (i / (double) (CIRCUM_VERTEX_COUNT - 1));
				double radian = percent * 2 * Math.PI;
				
				float outer_x = (float) (x + radius * Math.cos(radian));
				float outer_y = (float) (y + radius * Math.sin(radian));
				fBuf.put(outer_x).put(outer_y);
			}
			
			fBuf.position(0);
		}
		
	}
	
	@Override
	protected Vertex initVertex() {
		return new CircleVertex(VERTEX_COUNT(), COMPONENT_PER_VERTEX());
	}
}
