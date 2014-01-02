package com.studioirregular.gaoframework.gles;

import java.util.ArrayList;
import java.util.List;

import android.opengl.GLES20;
import android.util.Log;

public abstract class Shape {

	protected abstract String TAG();
	protected abstract boolean DEBUG_LOG();
	
	public Shape() {
		vertex = initVertex();
		color = initColorBuffer();
		
		ShaderProgram shaderProgram = ShaderProgramPool.getInstance().get(getClass());
		if (shaderProgram == null) {
			shaderProgram = buildShaderProgram();
			ShaderProgramPool.getInstance().add(getClass(), shaderProgram);
		}
	}
	
	protected static final String DEFAULT_ATTR_POSITION = "vPosition";
	protected static final String DEFAULT_UNIFORM_COLOR = "vColor";
	protected static final String DEFAULT_UNIFORM_MVP   = "uMVPMatrix";
	
	protected List<ShaderSource> SHADER_SOURCES() {
		
		List<ShaderSource> result = new ArrayList<ShaderSource>();
		
		final String VERTEX_SHADER =
				"uniform mat4 uMVPMatrix;" +
				"attribute vec4 vPosition;" +
				"void main() {" +
				"  gl_Position = uMVPMatrix * vPosition;" +
				"}";
		
		result.add(new ShaderSource(GLES20.GL_VERTEX_SHADER,
				VERTEX_SHADER, "vPosition", "a_TexCoordinate"));
		
		final String FRAGMENT_SHADER = 
				"precision mediump float;" +
				"uniform vec4 vColor;" +
				"void main() {" +
				"  gl_FragColor = vColor;" +
				"}";
		
		result.add(new ShaderSource(GLES20.GL_FRAGMENT_SHADER,
				FRAGMENT_SHADER));
		
		return result;
	}
	
	protected ShaderProgram getShaderProgram() {
		return ShaderProgramPool.getInstance().get(getClass());
	}
	
	public void setVertex(float... values) {
		
		vertex.set(values);
	}
	
	public void draw(float[] mvpMatrix) {
		
		final int shaderProgram = useShaderProgram();
		if (shaderProgram == ShaderProgram.INVALID_PROGRAM_NAME) {
			if (DEBUG_LOG()) {
				Log.w(TAG(), "draw: Cannot find my shader program.");
			}
			return;
		}
		
		vertex.bindValueToAttribute(shaderProgram, DEFAULT_ATTR_POSITION);
		
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
	protected int COMPONENT_PER_VERTEX() {
		return 2;
	}
	protected Vertex initVertex() {
		return new Vertex(VERTEX_COUNT(), COMPONENT_PER_VERTEX());
	}
	
	protected float[] color;
	protected static final int COLOR_ELEMENT_COUNT = 4;
	
	protected float[] initColorBuffer() {
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
		
		List<ShaderSource> shaderSources = SHADER_SOURCES();
		
		ShaderProgram program = new ShaderProgram();
		
		for (ShaderSource shader : shaderSources) {
			program.attach(shader);
		}
		
		program.bindAttributes();
		
		program.link();
		
		return program;
	}
}
