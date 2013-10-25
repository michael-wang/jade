package com.studioirregular.gaoframework;

import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.opengl.GLES20;
import android.opengl.GLUtils;
import android.util.Log;

public class GLTexture {

	public static final int INVALID_TEXTURE_NAME = 0;
	
	private static final String TAG = "gltexture";
	
	private static final float[] TEXTURE_COORDINATE_VALUES = {
			0.0f, 0.0f,
			0.0f, 1.0f,
			1.0f, 1.0f,
			1.0f, 0.0f,
	};
	private static final int COORDINATE_VALUE_BYTES = 4;
	
	private static final int COORDS_PER_VERTEX = 2;
	
	public GLTexture(AssetManager am) {
		this.am = am;
		this.name = INVALID_TEXTURE_NAME;
		
		textureCoordinates = ByteBuffer
				.allocateDirect(TEXTURE_COORDINATE_VALUES.length * COORDINATE_VALUE_BYTES)
				.order(ByteOrder.nativeOrder())
				.asFloatBuffer();
		textureCoordinates.put(TEXTURE_COORDINATE_VALUES);
		textureCoordinates.position(0);
	}
	
	// return texture name.
	public boolean load(String fileName) {
		Log.w(TAG, "load:" + fileName);
		
		final int[] nameBuf = new int[1];
		GLES20.glGenTextures(1, nameBuf, 0);
		Log.w(TAG, "texture name:" + nameBuf[0]);
		
		if (nameBuf[0] == 0) {
			final int error = GLES20.glGetError();
			Log.e(TAG, "glGenTextures error:" + error);
			
			this.name = INVALID_TEXTURE_NAME;
			return false;
		}
		
		this.name = nameBuf[0];
		
		Bitmap bmp = loadAssetImage(fileName);
		
		if (bmp == null) {
			Log.e(TAG, "loadAssetImage failed");
			
			this.name = INVALID_TEXTURE_NAME;
			return false;
		}
		Log.w(TAG, "bmp w:" + bmp.getWidth() + ",h:" + bmp.getHeight());
		
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, name);
		
		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_NEAREST);
		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_NEAREST);
		
		GLUtils.texImage2D(GLES20.GL_TEXTURE_2D, 0, bmp, 0);
		final int error = GLES20.glGetError();
		if (error != GLES20.GL_NO_ERROR) {
			Log.e(TAG, "OpenGL ES API error:" + error);
		}
		
		bmp.recycle();
		
		return true;
	}
	
	public void unload() {
		if (name != INVALID_TEXTURE_NAME) {
			IntBuffer nameBuf = IntBuffer.allocate(1);
			nameBuf.position(0);
			nameBuf.put(name);
			
			GLES20.glDeleteTextures(1, nameBuf);
			name = INVALID_TEXTURE_NAME;
		}
	}
	
	public void draw(int shaderProgram) {
		textureHandle = GLES20.glGetUniformLocation(shaderProgram, "u_Texture");
		checkIfNoGLError("glGetUniformLocation");
		coordinateHandle = GLES20.glGetAttribLocation(shaderProgram, "a_TexCoordinate");
		checkIfNoGLError("glGetAttribLocation");
		
		textureCoordinates.position(0);
		GLES20.glVertexAttribPointer(coordinateHandle, COORDS_PER_VERTEX,
				GLES20.GL_FLOAT, false, 0, textureCoordinates);
		checkIfNoGLError("glVertexAttribPointer");
		
		GLES20.glEnableVertexAttribArray(coordinateHandle);
		
		GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
		checkIfNoGLError("glActiveTexture");
		
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, name);
		checkIfNoGLError("glBindTexture");
		
		GLES20.glUniform1i(textureHandle, 0);
		checkIfNoGLError("glUniform1i");
	}
	
	private Bitmap loadAssetImage(String fileName) {
		InputStream is = null;
		try {
			is = am.open(fileName);
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		
		Bitmap bmp = null;
		try {
			bmp = BitmapFactory.decodeStream(is);
		} catch (OutOfMemoryError e) {
			e.printStackTrace();
			return null;
		}
		
		return bmp;
	}
	
	private boolean checkIfNoGLError(String msg) {
		final int error = GLES20.glGetError();
		if (error != GLES20.GL_NO_ERROR) {
			Log.e(TAG, msg + ":got GL error:" + error);
			return false;
		}
		return true;
	}
	
	protected AssetManager am;
	protected int name;
	
	protected int textureHandle;
	protected int coordinateHandle;
	private FloatBuffer textureCoordinates;
}
