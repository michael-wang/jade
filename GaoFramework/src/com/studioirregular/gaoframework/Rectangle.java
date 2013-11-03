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
		    "  gl_FragColor = texture2D(u_Texture,v_TexCoordinate);" +
		    "}";
	
	private static int program = 0;
	
	private float[] coordsValues;
	private FloatBuffer vertexBuffer;
	private ShortBuffer drawListBuffer;

	private static final int VERTEXT_COUNT = 4;
	private static final int COORDS_PER_VERTEX = 3;
	private static final int BYTES_PER_VERTEX = 4;
	private static final int BYTES_OF_SHORT = 2;
	
	private int positionHandle;
	private int colorHandle;
	private int MVPMatrixHandle;
	
	private final short drawOrder[] = { 0, 1, 2, 0, 2, 3 };
	private final int vertexStride = COORDS_PER_VERTEX * BYTES_PER_VERTEX;
	
	private static final int COLOR_ELEMENTS = 4;
	private float[] color = new float[COLOR_ELEMENTS];
	
	public Rectangle(float left, float top, float right, float bottom, 
			float red, float green, float blue, float alpha) {
		Log.d(TAG, "Rectangle left:" + left + ",top:" + top + ",right:" + right
				+ ",bottom:" + bottom + ",red:" + red + ",green:" + green
				+ ",blue:" + blue + ",alpha:" + alpha);
		
		setBound(left, top, right, bottom);
		setColor(red, green, blue, alpha);
		
		ByteBuffer dlb = ByteBuffer.allocateDirect(drawOrder.length * BYTES_OF_SHORT);
		dlb.order(ByteOrder.nativeOrder());
		drawListBuffer = dlb.asShortBuffer();
		drawListBuffer.put(drawOrder);
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
		Log.d(TAG, "setBound left:" + left + ",top:" + top + ",right:" + right
				+ ",bottom:" + bottom);
		
		if (coordsValues == null) {
			coordsValues = new float[VERTEXT_COUNT * COORDS_PER_VERTEX];
		}
		
		float[] coords = coordsValues;
		coords[0] = left;  coords[1] = top;    coords[2] = 0.0f;
		coords[3] = left;  coords[4] = bottom; coords[5] = 0.0f;
		coords[6] = right; coords[7] = bottom; coords[8] = 0.0f;
		coords[9] = right; coords[10] = top;   coords[11] = 0.0f;
		
		ByteBuffer bb = ByteBuffer.allocateDirect(coords.length * BYTES_PER_VERTEX);
		bb.order(ByteOrder.nativeOrder());
		vertexBuffer = bb.asFloatBuffer();
		vertexBuffer.put(coords);
		vertexBuffer.position(0);
	}
	
	public void setColor(float red, float green, float blue, float alpha) {
		Log.d(TAG, "setColor red:" + red + ",green:" + green + ",blue:" + blue
				+ ",alpha:" + alpha);
		
		color[0] = red;
		color[1] = green;
		color[2] = blue;
		color[3] = alpha;
	}
	
	public void setTexture(GLTexture t) {
		this.texture = t;
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
	    
	    if (texture != null) {
	    	texture.draw(program);
	    }
	    
	    MVPMatrixHandle = GLES20.glGetUniformLocation(program, "uMVPMatrix");
	    
	    GLES20.glUniformMatrix4fv(MVPMatrixHandle, 1, false, mvpMatrix, 0);
	    
	    GLES20.glDrawElements(GLES20.GL_TRIANGLES, drawOrder.length,
	    		GLES20.GL_UNSIGNED_SHORT, drawListBuffer);
	    
	    GLES20.glDisableVertexAttribArray(positionHandle);
	}
	
	private GLTexture texture;
}
