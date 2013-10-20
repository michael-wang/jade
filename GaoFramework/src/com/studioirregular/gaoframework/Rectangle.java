package com.studioirregular.gaoframework;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.nio.ShortBuffer;

import android.opengl.GLES20;
import android.util.Log;

public class Rectangle {

	private static final String TAG = "rectangle";
	
	private static int loadShader(int type, String shaderCode){
//		Log.d(TAG, "loadShader type:" + type + ",code:" + shaderCode);

	    // create a vertex shader type (GLES20.GL_VERTEX_SHADER)
	    // or a fragment shader type (GLES20.GL_FRAGMENT_SHADER)
	    int shader = GLES20.glCreateShader(type);

	    // add the source code to the shader and compile it
	    GLES20.glShaderSource(shader, shaderCode);
	    GLES20.glCompileShader(shader);

	    IntBuffer intBuf = IntBuffer.allocate(1);
	    GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, intBuf);
	    final boolean compiled = (intBuf.get(0) == GLES20.GL_TRUE);
//	    Log.d(TAG, "loadShader compiled:" + compiled);
	    
	    if (!compiled) {
	    	String info = GLES20.glGetShaderInfoLog(shader);
	    	Log.e(TAG, "loadShader compile failed:" + info);

	    	GLES20.glDeleteShader(shader);
	    	return 0;
	    }

	    return shader;
	}
	
	private static final String vertexShaderCode =
			"uniform mat4 uMVPMatrix;" +
			"attribute vec4 vPosition;" +
			"void main() {" +
			"  gl_Position = vPosition * uMVPMatrix;" +
			"}";
	
	private static final String fragmentShaderCode =
		    "precision mediump float;" +
		    "uniform vec4 vColor;" +
		    "void main() {" +
		    "  gl_FragColor = vColor;" +
		    "}";
	
	private static int program = 0;
	
	private FloatBuffer vertexBuffer;
	private ShortBuffer drawListBuffer;

	static final int COORDS_PER_VERTEX = 3;
	
	private float[] rectCoords;
	private int positionHandle;
	private int colorHandle;
	private int MVPMatrixHandle;
	
	private final short drawOrder[] = { 0, 1, 2, 0, 2, 3 };
	private final int vertexStride = COORDS_PER_VERTEX * 4; // 4 bytes per vertex
	
	private float color[];
	
	public Rectangle(float left, float top, float right, float bottom, 
			float red, float green, float blue, float alpha) {
		
		rectCoords = new float[] {
				left,  top,    0.0f, 
				left,  bottom, 0.0f,
				right, bottom, 0.0f,
				right, top,    0.0f
		};
		
		ByteBuffer bb = ByteBuffer.allocateDirect(rectCoords.length * 4);
		bb.order(ByteOrder.nativeOrder());
		vertexBuffer = bb.asFloatBuffer();
		vertexBuffer.put(rectCoords);
		vertexBuffer.position(0);
		
		ByteBuffer dlb = ByteBuffer.allocateDirect(drawOrder.length * 2);
		dlb.order(ByteOrder.nativeOrder());
		drawListBuffer = dlb.asShortBuffer();
		drawListBuffer.put(drawOrder);
		drawListBuffer.position(0);
		
		color = new float[] {red, green, blue, alpha};
		
		int vertexShader = loadShader(GLES20.GL_VERTEX_SHADER, vertexShaderCode);
		int fragmentShader = loadShader(GLES20.GL_FRAGMENT_SHADER, fragmentShaderCode);
		
		program = GLES20.glCreateProgram();
		GLES20.glAttachShader(program, vertexShader);
		GLES20.glAttachShader(program, fragmentShader);
		
		GLES20.glBindAttribLocation(program, 0, "vPosition");
		
		GLES20.glLinkProgram(program);
		
		IntBuffer intBuf = IntBuffer.allocate(1);
		GLES20.glGetProgramiv(program, GLES20.GL_LINK_STATUS, intBuf);
		
		final boolean linked = intBuf.get(0) == GLES20.GL_TRUE;
		if (!linked) {
			Log.e(TAG, "Link failed:" + GLES20.glGetProgramInfoLog(program));
		}
	}
	
	public void draw(float[] mvpMatrix) {
		GLES20.glUseProgram(program);
		
		positionHandle = GLES20.glGetAttribLocation(program, "vPosition");
		
		GLES20.glEnableVertexAttribArray(positionHandle);
		
	    GLES20.glVertexAttribPointer(positionHandle, COORDS_PER_VERTEX,
                GLES20.GL_FLOAT, false,
                vertexStride, vertexBuffer);
	    
	    colorHandle = GLES20.glGetUniformLocation(program, "vColor");
	    
	    GLES20.glUniform4fv(colorHandle, 1, color, 0);
	    
	    MVPMatrixHandle = GLES20.glGetUniformLocation(program, "uMVPMatrix");
	    
	    GLES20.glUniformMatrix4fv(MVPMatrixHandle, 1, false, mvpMatrix, 0);
	    
	    GLES20.glDrawElements(GLES20.GL_TRIANGLES, drawOrder.length,
	    		GLES20.GL_UNSIGNED_SHORT, drawListBuffer);
	    
	    GLES20.glDisableVertexAttribArray(positionHandle);
	}
}
