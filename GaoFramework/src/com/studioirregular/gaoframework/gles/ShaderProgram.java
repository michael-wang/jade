package com.studioirregular.gaoframework.gles;

import java.nio.IntBuffer;

import android.opengl.GLES20;
import android.util.Log;

public class ShaderProgram {

	private static final String TAG = ShaderProgram.class.getSimpleName();
	private static final boolean DEBUG_LOG = false;
	
	public static final int INVALID_PROGRAM_NAME = 0;
	
	public ShaderProgram() throws RuntimeException {
		
		name = GLES20.glCreateProgram();
		
		if (name == INVALID_PROGRAM_NAME) {
			throw new RuntimeException("Failed to create shader program.");
		}
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShaderProgram name:" + name);
		}
	}
	
	public void delete() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "delete name:" + name);
		}
		
		if (!deleted && name != INVALID_PROGRAM_NAME) {
			GLES20.glDeleteProgram(name);
			deleted = true;
		}
	}
	
	public void attach(ShaderSource shader) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "attach shader:" + shader.getName());
		}
		
		GLES20.glAttachShader(name, shader.getName());
	}
	
	public void detach(ShaderSource shader) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "detach shader:" + shader.getName());
		}
		
		GLES20.glDetachShader(name, shader.getName());
	}
	
	public void link() throws RuntimeException {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "link name:" + name);
		}
		
		GLES20.glLinkProgram(name);
		
		if (!isLinkSuccess(name)) {
			
			String log = GLES20.glGetShaderInfoLog(name);
			throw new RuntimeException(
					"Shader program link failed, error log:" + log);
		}
	}
	
	public int getName() {
		
		if (deleted) {
			return INVALID_PROGRAM_NAME;
		}
		
		return name;
	}
	
	private boolean isLinkSuccess(int program) {
		
		IntBuffer intBuf = IntBuffer.allocate(1);
		GLES20.glGetProgramiv(program, GLES20.GL_LINK_STATUS, intBuf);
		final boolean success = (intBuf.get(0) == GLES20.GL_TRUE);
		
		return success;
	}
	
	private final int name;
	private boolean deleted = false;
}
