package com.studioirregular.gaoframework.gles;

import java.nio.IntBuffer;
import java.util.ArrayList;
import java.util.List;

import android.opengl.GLES20;
import android.util.Log;

public class ShaderSource {

	private static final String TAG = ShaderSource.class.getSimpleName();
	private static final boolean DEBUG_LOG = false;
	
	public static final int INVALID_SHADER_NAME = 0;
	
	/**
	 * Create shader source and compile it.
	 * 
	 * @param type GL_VERTEX_SHADER or GL_FRAGMENT_SHADER
	 * @param code
	 */
	public ShaderSource(int type, String code, String... attributes) throws RuntimeException {
		
		if (DEBUG_LOG) {
			StringBuilder attrs = new StringBuilder(",attributes:");
			for (String a : attributes) {
				attrs.append(a).append(",");
			}
			Log.d(TAG, "ShaderSource type:" + type + ",code:\n" + code
					+ "\nattributes:" + attrs.toString());
		}
		
		this.sourceCode = code;
		for (String attr : attributes) {
			this.attributes.add(attr);
		}
		
		name = GLES20.glCreateShader(type);
		if (name == INVALID_SHADER_NAME) {
			throw new RuntimeException(
					"ShaderProgram failed to create shader of type:" + type);
		}
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShaderSource name:" + name);
		}
		
		GLES20.glShaderSource(name, code);
		
		GLES20.glCompileShader(name);
		if (!isCompileSuccess(name)) {
			
			String log = GLES20.glGetShaderInfoLog(name);
			throw new RuntimeException(
					"Shader compilation failed, error log:" + log);
		}
	}
	
	public List<String> getAttributes() {
		
		return attributes;
	}
	
	public void delete() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "delete name:" + name);
		}
		
		if (!deleted && name != INVALID_SHADER_NAME) {
			GLES20.glDeleteShader(name);
			deleted = true;
		}
	}
	
	/* package */ int getName() {
		
		if (deleted) {
			return INVALID_SHADER_NAME;
		}
		
		return name;
	}
	
	/* package */ String getSource() {
		return sourceCode;
	}
	
	private boolean isCompileSuccess(int shader) {
		
		IntBuffer intBuf = IntBuffer.allocate(1);
		GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, intBuf);
		final boolean success = (intBuf.get(0) == GLES20.GL_TRUE);
		
		return success;
	}
	
	private final int name;
	private boolean deleted = false;
	private final String sourceCode;
	private List<String> attributes = new ArrayList<String>();
}
