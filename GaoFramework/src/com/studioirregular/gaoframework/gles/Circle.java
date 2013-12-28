package com.studioirregular.gaoframework.gles;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

import android.opengl.GLES20;
import android.util.Log;

public class Circle {

	private static final String TAG = "Circle";
	private static final boolean DEBUG_LOG = false;
	
	public Circle(float x, float y, float radius, 
			float red, float green, float blue, float alpha) {

		if (DEBUG_LOG) {
			Log.d(TAG, "Circle x:" + x + ",y:" + y + ",radius:" + radius);
			Log.d(TAG, "       r:" + red + ",g:" + green + ",b:" + blue + ",a:" + alpha);
		}
		
		if (ShaderProgramPool.getInstance().get(this.getClass()) == null) {
			ShaderProgramPool.getInstance().add(this.getClass(), buildShaderProgram());
		}
		
		vertexBuffer = buildVerteces(x, y, radius);
		color = buildColor(red, green, blue, alpha);
	}
	
	public void draw(float[] mvpMatrix) {
		
		ShaderProgram shaderProgram = ShaderProgramPool.getInstance().get(
				this.getClass());
		if (shaderProgram == null) {
			return;
		}
		
		final int program = shaderProgram.getName();
		
		GLES20.glUseProgram(program);
		
		final int positionLoc = GLES20.glGetAttribLocation(program, "vPosition");
		
		GLES20.glEnableVertexAttribArray(positionLoc);
		
		GLES20.glVertexAttribPointer(positionLoc, ELEMENT_PER_VERTEX,
				GLES20.GL_FLOAT, false, VERTEX_STRIDE, vertexBuffer);
		
		final int colorLoc = GLES20.glGetUniformLocation(program, "vColor");
		
		GLES20.glUniform4fv(colorLoc, 1, color, 0);
		
		final int MVPMatrixLoc = GLES20.glGetUniformLocation(program, "uMVPMatrix");
		
		GLES20.glUniformMatrix4fv(MVPMatrixLoc, 1, false, mvpMatrix, 0);
		
		GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, VERTEX_COUNT);
		
		GLES20.glDisableVertexAttribArray(positionLoc);
	}
	
	private static final int VERTEX_COUNT = 64;
	private static final int ELEMENT_PER_VERTEX = 3;
	private static final int BYTES_PER_ELEMENT = 4;
	private static final int VERTEX_STRIDE = ELEMENT_PER_VERTEX * BYTES_PER_ELEMENT;
	private FloatBuffer vertexBuffer;
	private FloatBuffer buildVerteces(float x, float y, float radius) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "buildVerteces x:" + x + ",y:" + y + ",r:" + radius);
		}
		
		FloatBuffer buf = ByteBuffer
				.allocateDirect(
						VERTEX_COUNT * ELEMENT_PER_VERTEX * BYTES_PER_ELEMENT)
				.order(ByteOrder.nativeOrder())
				.asFloatBuffer();
		
		int idx = 0;
		// center
		buf.put(idx++, x).put(idx++, y).put(idx++, 0);
		
		// vertex on circumference.
		final int CIRCUM_VERTEX_COUNT = VERTEX_COUNT - 1;
		for (int i = 0; i < CIRCUM_VERTEX_COUNT; i++) {
			
			double percent = (i / (double) (CIRCUM_VERTEX_COUNT - 1));
			double radian = percent * 2 * Math.PI;
			
			float outer_x = (float) (x + radius * Math.cos(radian));
			float outer_y = (float) (y + radius * Math.sin(radian));
			if (DEBUG_LOG) {
				Log.d(TAG, "i:" + i + ",outer_x:" + outer_x + ",outer_y:" + outer_y);
			}
			
			buf.put(idx++, outer_x).put(idx++, outer_y).put(idx++, 0);
		}
		
		buf.position(0);
		return buf;
	}
	
	private static final int COLOR_ELEMENTS = 4;
	private float[] color;
	private float[] buildColor(float red, float green, float blue, float alpha) {
		
		float[] result = new float[COLOR_ELEMENTS];
		
		result[0] = red;
		result[1] = green;
		result[2] = blue;
		result[3] = alpha;
		
		return result;
	}
	
	private static final String VERTEX_SHADER =
			"uniform mat4 uMVPMatrix;" +
			"attribute vec4 vPosition;" +
			"void main() {" +
			"  gl_Position = uMVPMatrix * vPosition;" +
			"}";
	
	private static final String FRAGMENT_SHADER =
		    "precision mediump float;" +
		    "uniform vec4 vColor;" +
		    "void main() {" +
		    "  gl_FragColor = vColor;" +
		    "}";
	
	private static ShaderProgram buildShaderProgram() {
		
		ShaderSource vertexShader = new ShaderSource(
				GLES20.GL_VERTEX_SHADER, VERTEX_SHADER);
		ShaderSource fragmentShader = new ShaderSource(
				GLES20.GL_FRAGMENT_SHADER, FRAGMENT_SHADER);

		ShaderProgram result = new ShaderProgram();

		result.attach(vertexShader);
		result.attach(fragmentShader);

		GLES20.glBindAttribLocation(result.getName(), 0, "vPosition");

		result.link();
		
		return result;
	}
}
