package com.studioirregular.gaoframework.gles;

import java.nio.IntBuffer;

import android.graphics.Bitmap;
import android.opengl.GLES20;
import android.opengl.GLUtils;
import android.util.Log;

import com.studioirregular.gaoframework.BuildConfig;
import com.studioirregular.gaoframework.TextureImageLoader;

public class Texture {

	private static final String TAG = "java-Texture";
	private static final boolean DEBUG_LOG = false;
	
	public Texture() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Texture");
		}
	}
	
	public boolean Create(String path, boolean filtered) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Create path:" + path + ",filtered:" + filtered);
		}
		
		this.path = path;
		this.filtered = filtered;
		
		workingBuf.position(0);
		GLES20.glGenTextures(1, workingBuf);
		
		if (glError.hasError(TAG, "glGenTextures failed.")) {
			name = INVALID_NAME;
			return false;
		}
		
		this.name = workingBuf.get(0);
		
		TextureImageLoader loader = new TextureImageLoader();
		
		Bitmap bmp = null;
		if (path.startsWith("/")) {
			bmp = loader.loadFromStorage(path);
		} else {
			bmp = loader.loadFromAsset(path);
		}
		
		if (bmp == null) {
			Log.e(TAG, "Failed to load bitmap:" + path);
			workingBuf.put(0, this.name);
			GLES20.glDeleteTextures(1, workingBuf);
			this.name = INVALID_NAME;
			return false;
		}
		
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, name);
		
		if (filtered) {
			GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_NEAREST);
			GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_NEAREST);
		} else {
			GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_LINEAR);
			GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_LINEAR);
		}
		
		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_S, GLES20.GL_CLAMP_TO_EDGE);
		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_T, GLES20.GL_CLAMP_TO_EDGE);
		
		GLUtils.texImage2D(GLES20.GL_TEXTURE_2D, 0, bmp, 0);
		
		if (glError.hasError(TAG, "texImage2D failed.")) {
			workingBuf.put(0, this.name);
			GLES20.glDeleteTextures(1, workingBuf);
			this.name = INVALID_NAME;
			bmp.recycle();
			return false;
		}
		
		bmp.recycle();
		return true;
	}
	
	public boolean Reload() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Reload");
		}
		
		if (path == null) {
			if (BuildConfig.DEBUG) {
				Log.e(TAG, "Reload failed, invalid path:" + path);
			}
			return false;
		}
		
		return Create(path, filtered);
	}
	
	public void Unload() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Unload");
		}
		
		if (name != INVALID_NAME) {
			workingBuf.put(0, name);
			
			GLES20.glDeleteTextures(1, workingBuf);
			name = INVALID_NAME;
			
			glError.hasError(TAG, "glDeleteTextures failed.");
		}
	}
	
	public void draw(ShaderProgram shaderProgram, 
			String textureUniform, String textureCoordinateAttribute, 
			float u0, float v0, float u1, float v1, 
			float u2, float v2, float u3, float v3) {
		
		if (name == INVALID_NAME) {
			if (BuildConfig.DEBUG) {
				Log.e(TAG, "draw invalid texture name:" + name);
			}
			return;
		}
		
		coords.set(u0, v0, u1, v1, u2, v2, u3, v3);
		
		final int program = shaderProgram.getName();
		
		final int coordinateIndex = GLES20.glGetAttribLocation(program, textureCoordinateAttribute);
		glError.hasError(TAG, "glGetAttribLocation with " + textureCoordinateAttribute);
		final int textureIndex  = GLES20.glGetUniformLocation(program, textureUniform);
		glError.hasError(TAG, "glGetUniformLocation with " + textureUniform);
		
		GLES20.glVertexAttribPointer(coordinateIndex,
				TextureCoordinates.COMPONENTS_PER_POINT, GLES20.GL_FLOAT,
				false, 0, coords.get());
		glError.hasError(TAG, "glVertexAttribPointer");
		
		GLES20.glEnableVertexAttribArray(coordinateIndex);
		glError.hasError(TAG, "glEnableVertexAttribArray");
		
		GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
		glError.hasError(TAG, "glActiveTexture");
		
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, name);
		glError.hasError(TAG, "glBindTexture name:" + name);
		
		GLES20.glUniform1i(textureIndex, 0);
		glError.hasError(TAG, "glUniform1i textureIndex:" + textureIndex);
	}
	
	@Override
	public String toString() {
		
		return "Texture name:" + name + "\n\tpath:" + path + "\n\tcoords:" + coords;
	}
	
	private static final int INVALID_NAME = 0;
	
	private int name = INVALID_NAME;
	private String path;
	private TextureCoordinates coords = new TextureCoordinates();
	private boolean filtered;
	
	private IntBuffer workingBuf = IntBuffer.allocate(1);
	private GLError glError = new GLError(DEBUG_LOG);
}
