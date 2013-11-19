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
	
	/* texture coordinates:
	 * (left, upper) ---> (right, upper)
	 *       ^                   |
	 *       |                   v
	 * (left, lower)      (right, lower)
	 */
	private static final int COORDINATE_COMPONENTS = 4 * 2;	// 4 points, each has 2 items.
	private static final int COORDINATE_VALUE_IN_BYTES = 4;
	
	private static final int COORDS_PER_VERTEX = 2;
	
	public GLTexture() {
		this.name = INVALID_TEXTURE_NAME;
		
		textureCoordinates = ByteBuffer
				.allocateDirect(COORDINATE_COMPONENTS * COORDINATE_VALUE_IN_BYTES)
				.order(ByteOrder.nativeOrder())
				.asFloatBuffer();
	}
	
	public boolean Create(String fileName) {
		Log.w(TAG, "Create:" + fileName);
		
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
		
		AssetManager am = JavaInterface.getInstance().getContext().getAssets();
		Bitmap bmp = loadAssetImage(am, fileName);
		
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
	
	/**
	 * 
	 * @param shaderProgram
	 * @param lower, left, upper, right: texture coordinates.
	 */
	public void draw(int shaderProgram, float lower, float left, float upper,
			float right) {
		textureHandle = GLES20.glGetUniformLocation(shaderProgram, "u_Texture");
		checkIfNoGLError("glGetUniformLocation");
		coordinateHandle = GLES20.glGetAttribLocation(shaderProgram, "a_TexCoordinate");
		checkIfNoGLError("glGetAttribLocation");
		
		textureCoordinates.position(0);
		textureCoordinates.put(left).put(lower);
		textureCoordinates.put(left).put(upper);
		textureCoordinates.put(right).put(upper);
		textureCoordinates.put(right).put(lower);
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
	
	private Bitmap loadAssetImage(AssetManager am, String fileName) {
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
	
	protected int name;
	
	protected int textureHandle;
	protected int coordinateHandle;
	private FloatBuffer textureCoordinates;
}
