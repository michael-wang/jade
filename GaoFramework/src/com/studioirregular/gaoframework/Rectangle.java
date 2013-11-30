package com.studioirregular.gaoframework;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.nio.ShortBuffer;

import android.opengl.GLES20;
import android.util.Log;

public class Rectangle {

	private static final String TAG = "java-rectangle";
	private static final boolean DEBUG_LOG = false;
	
	private static int loadShader(int type, String shaderCode){
		if (DEBUG_LOG) {
			Log.d(TAG, "loadShader type:" + type + ",code:" + shaderCode);
		}

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
			"attribute vec2 a_TexCoordinate;" +
			"varying vec2 v_TexCoordinate;" +
			"void main() {" +
			"  v_TexCoordinate = a_TexCoordinate;" +
			"  gl_Position = vPosition * uMVPMatrix;" +
			"}";
	
	private static final String fragmentShaderCode =
		    "precision mediump float;" +
		    "uniform vec4 vColor;" +
		    "varying vec2 v_TexCoordinate;" +
		    "uniform sampler2D u_Texture;" +
		    "void main() {" +
		    "  gl_FragColor = vColor + texture2D(u_Texture,v_TexCoordinate);" +
		    "}";
	
	private static int program = 0;
	
	private FloatBuffer vertexBuffer;
	private ShortBuffer drawListBuffer;

	private static final int VERTEXT_COUNT = 4;
	private static final int COORDS_PER_VERTEX = 3;
	private static final int BYTES_PER_VERTEX = 4;
	private static final int DRAW_ORDER_VERTEX_COUNT = 6;
	private static final int BYTES_OF_SHORT = 2;
	
	private int positionHandle;
	private int colorHandle;
	private int MVPMatrixHandle;
	
	private final int vertexStride = COORDS_PER_VERTEX * BYTES_PER_VERTEX;
	
	private static final int COLOR_ELEMENTS = 4;
	private float[] color = new float[COLOR_ELEMENTS];
	
	public Rectangle(float left, float top, float right, float bottom, 
			float red, float green, float blue, float alpha) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Rectangle left:" + left + ",top:" + top + ",right:" + right
				+ ",bottom:" + bottom + ",red:" + red + ",green:" + green
				+ ",blue:" + blue + ",alpha:" + alpha);
		}
		
		setBound(left, top, right, bottom);
		setColor(red, green, blue, alpha);
		
		ByteBuffer dlb = ByteBuffer.allocateDirect(DRAW_ORDER_VERTEX_COUNT * BYTES_OF_SHORT);
		dlb.order(ByteOrder.nativeOrder());
		drawListBuffer = dlb.asShortBuffer();
		drawListBuffer.put(0, (short)0);
		drawListBuffer.put(1, (short)1);
		drawListBuffer.put(2, (short)2);
		drawListBuffer.put(3, (short)0);
		drawListBuffer.put(4, (short)2);
		drawListBuffer.put(5, (short)3);
		drawListBuffer.position(0);
		
		int vertexShader = loadShader(GLES20.GL_VERTEX_SHADER, vertexShaderCode);
		int fragmentShader = loadShader(GLES20.GL_FRAGMENT_SHADER, fragmentShaderCode);
		
		program = GLES20.glCreateProgram();
		GLES20.glAttachShader(program, vertexShader);
		GLES20.glAttachShader(program, fragmentShader);
		
		GLES20.glBindAttribLocation(program, 0, "vPosition");
		GLES20.glBindAttribLocation(program, 1, "a_TexCoordinate");
		
		GLES20.glLinkProgram(program);
		
		IntBuffer intBuf = IntBuffer.allocate(1);
		GLES20.glGetProgramiv(program, GLES20.GL_LINK_STATUS, intBuf);
		
		final boolean linked = intBuf.get(0) == GLES20.GL_TRUE;
		if (!linked) {
			Log.e(TAG, "Link failed:" + GLES20.glGetProgramInfoLog(program));
		}
	}
	
	public void setBound(float left, float top, float right, float bottom) {
		if (DEBUG_LOG) {
			Log.d(TAG, "setBound left:" + left + ",top:" + top + ",right:" + right
				+ ",bottom:" + bottom);
		}
		
		FloatBuffer buf = ByteBuffer
				.allocateDirect(VERTEXT_COUNT * COORDS_PER_VERTEX * BYTES_PER_VERTEX)
				.order(ByteOrder.nativeOrder())
				.asFloatBuffer();
		
		buf.put(0, left).put(  1,  top).put(   2, 0);
		buf.put(3, left).put(  4,  bottom).put(5, 0);
		buf.put(6, right).put( 7,  bottom).put(8, 0);
		buf.put(9, right).put(10,  top).put(  11, 0);
		buf.position(0);
		
		vertexBuffer = buf;
	}
	
	public void setColor(float red, float green, float blue, float alpha) {
		if (DEBUG_LOG) {
			Log.d(TAG, "setColor red:" + red + ",green:" + green + ",blue:" + blue
					+ ",alpha:" + alpha);
		}
		
		color[0] = red;
		color[1] = green;
		color[2] = blue;
		color[3] = alpha;
	}
	
	public void setTexture(GLTexture t) {
		this.texture = t;
	}
	
	public void draw(float[] mvpMatrix) {
		if (DEBUG_LOG) {
			Util.log(TAG, "draw: mvpMatrix:", mvpMatrix, 4, 4);
		}
		
		GLES20.glUseProgram(program);
		
		positionHandle = GLES20.glGetAttribLocation(program, "vPosition");
		
		GLES20.glEnableVertexAttribArray(positionHandle);
		
	    GLES20.glVertexAttribPointer(positionHandle, COORDS_PER_VERTEX,
                GLES20.GL_FLOAT, false,
                vertexStride, vertexBuffer);
	    
	    colorHandle = GLES20.glGetUniformLocation(program, "vColor");
	    
	    GLES20.glUniform4fv(colorHandle, 1, color, 0);
	    
	    if (texture != null) {
	    	texture.draw(program, 0.0f, 0.0f, 1.0f, 1.0f);
	    }
	    
	    MVPMatrixHandle = GLES20.glGetUniformLocation(program, "uMVPMatrix");
	    
	    GLES20.glUniformMatrix4fv(MVPMatrixHandle, 1, false, mvpMatrix, 0);
	    
	    GLES20.glDrawElements(GLES20.GL_TRIANGLES, DRAW_ORDER_VERTEX_COUNT,
	    		GLES20.GL_UNSIGNED_SHORT, drawListBuffer);
	    
	    GLES20.glDisableVertexAttribArray(positionHandle);
	}
	
	private GLTexture texture;
}
