package com.studioirregular.gaoframework.gles;

import android.opengl.GLES20;
import android.util.Log;

public abstract class Shape {

	protected abstract String TAG();
	protected abstract boolean DEBUG_LOG();
	
	public Shape() {
		vertex = new Vertex(VERTEX_COUNT(), ELEMENT_PER_VERTEX);
		color = initColorBuffer();
		
		ShaderProgram shaderProgram = ShaderProgramPool.getInstance().get(getClass());
		if (shaderProgram == null) {
			shaderProgram = buildShaderProgram();
			ShaderProgramPool.getInstance().add(getClass(), shaderProgram);
		}
	}
	
	protected abstract String VERTEX_SHADER_CODE();
	protected abstract String FRAGMENT_SHADER_CODE();
	
	protected ShaderProgram getShaderProgram() {
		return ShaderProgramPool.getInstance().get(getClass());
	}
	
	public abstract void setVertex(float... values);
	
	public void draw(float[] mvpMatrix) {
		
		final int shaderProgram = useShaderProgram();
		if (shaderProgram == ShaderProgram.INVALID_PROGRAM_NAME) {
			if (DEBUG_LOG()) {
				Log.w(TAG(), "draw: Cannot find my shader program.");
			}
			return;
		}
		
		setAttributeVertex(shaderProgram, DEFAULT_ATTR_POSITION, vertex);
		
		setUniformColor(shaderProgram, DEFAULT_UNIFORM_COLOR, color);
		
		setUniformMVP(shaderProgram, DEFAULT_UNIFORM_MVP, mvpMatrix);
		
		onDraw();
		
		postDraw();
	}
	
	protected abstract void onDraw();
	
	protected int useShaderProgram() {
		
		ShaderProgram shaderProgram = getShaderProgram();
		if (shaderProgram == null) {
			return ShaderProgram.INVALID_PROGRAM_NAME;
		}
		
		final int program = shaderProgram.getName();
		
		GLES20.glUseProgram(program);
		
		return program;
	}
	
	protected void setAttributeVertex(int program, String attributeName, Vertex value) {
		value.bindValueToAttribute(program, attributeName);
	}
	
	protected void setUniformColor(int program, String uniformName, float[] value) {
		
		final int colorIndex = GLES20.glGetUniformLocation(program, uniformName);
		
		GLES20.glUniform4fv(colorIndex, 1, value, 0);
	}
	
	protected void setUniformMVP(int program, String uniformName, float[] value) {
		
		final int MVPMatrixIndex = GLES20.glGetUniformLocation(program, uniformName);
		
		GLES20.glUniformMatrix4fv(MVPMatrixIndex, 1, false, value, 0);
	}
	
	protected void postDraw() {
		vertex.unbindValueToAttribute();
	}
	
	protected Vertex vertex;
	protected abstract int VERTEX_COUNT();
	protected static final int ELEMENT_PER_VERTEX = 3;
	protected static final int BYTES_PER_ELEMENT = 4;
	protected static final int VERTEX_STRIDE = ELEMENT_PER_VERTEX * BYTES_PER_ELEMENT;
	
	protected float[] color;
	protected static final int COLOR_ELEMENT_COUNT = 4;
	
	private float[] initColorBuffer() {
		return new float[COLOR_ELEMENT_COUNT];
	}
	
	public void setColor(float red, float green, float blue, float alpha) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "setColor r:" + red + ",g:" + green + ",b:" + blue + ",a:" + alpha);
		}
		
		if (color != null && color.length == COLOR_ELEMENT_COUNT) {
			color[0] = red;
			color[1] = green;
			color[2] = blue;
			color[3] = alpha;
		}
	}
	
	protected ShaderProgram buildShaderProgram() {
		
		ShaderSource vertexShader = new ShaderSource(
				GLES20.GL_VERTEX_SHADER, VERTEX_SHADER_CODE());
		ShaderSource fragmentShader = new ShaderSource(
				GLES20.GL_FRAGMENT_SHADER, FRAGMENT_SHADER_CODE());

		ShaderProgram result = new ShaderProgram();

		result.attach(vertexShader);
		result.attach(fragmentShader);

		GLES20.glBindAttribLocation(result.getName(), 0, "vPosition");

		result.link();
		
		return result;
	}
	
	protected static final String DEFAULT_VERTEX_SHADER =
			"uniform mat4 uMVPMatrix;" +
			"attribute vec4 vPosition;" +
			"void main() {" +
			"  gl_Position = uMVPMatrix * vPosition;" +
			"}";
	
	protected static final String DEFAULT_FRAGMENT_SHADER =
		    "precision mediump float;" +
		    "uniform vec4 vColor;" +
		    "void main() {" +
		    "  gl_FragColor = vColor;" +
		    "}";
	
	private static final String DEFAULT_ATTR_POSITION = "vPosition";
	private static final String DEFAULT_UNIFORM_COLOR = "vColor";
	private static final String DEFAULT_UNIFORM_MVP   = "uMVPMatrix";
}
