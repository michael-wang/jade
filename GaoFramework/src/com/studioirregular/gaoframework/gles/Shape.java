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
		color = new GLColor();
		color.set(1, 1, 1, 1);
		
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
		
		ShaderProgram program = getShaderProgram();
		if (program == null) {
			if (DEBUG_LOG()) {
				Log.w(TAG(), "draw: shader program gone, recreate one.");
			}
			
			program = buildShaderProgram();
			ShaderProgramPool.getInstance().add(getClass(), program);
		}
		
		final int shaderProgram = program.getName();
		
		useShaderProgram(program);
		
		vertex.bindValueToAttribute(shaderProgram, DEFAULT_ATTR_POSITION);
		
		setUniformColor(shaderProgram, DEFAULT_UNIFORM_COLOR, color.get());
		
		setUniformMVP(shaderProgram, DEFAULT_UNIFORM_MVP, mvpMatrix);
		
		onDraw();
		
		postDraw();
	}
	
	protected abstract void onDraw();
	
	protected void useShaderProgram(ShaderProgram shaderProgram) {
		
		final int program = shaderProgram.getName();
		
		GLES20.glUseProgram(program);
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
	
	protected GLColor color;
	
	public void setColor(float red, float green, float blue, float alpha) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "setColor r:" + red + ",g:" + green + ",b:" + blue + ",a:" + alpha);
		}
		
		color.set(red, green, blue, alpha);
	}
	
	protected ShaderProgram buildShaderProgram() {
		
		if (DEBUG_LOG()) {
			Log.w(TAG(), "buildShaderProgram");
		}
		
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
