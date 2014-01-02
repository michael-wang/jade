package com.studioirregular.gaoframework.gles;

import java.util.ArrayList;
import java.util.List;

import android.opengl.GLES20;
import android.opengl.Matrix;
import android.util.Log;

import com.studioirregular.gaoframework.AndroidTransform;
import com.studioirregular.gaoframework.JavaInterface;

public class Sprite extends Shape {

	@Override
	protected String TAG() {
		return "java-Sprite";
	}

	@Override
	protected boolean DEBUG_LOG() {
		return false;
	}
	
	public Sprite() {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "Sprite");
		}
	}
	
	public boolean Create(AndroidTransform transform, Texture texture) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "Create transform:" + transform + ",texture:" + texture);
		}
		
		this.transform = transform;
		this.texture = texture;
		
		return true;
	}
	
	public void SetRenderSize(int width, int height) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetRenderSize: w:" + width + ",h:" + height);
		}
		
		final float hw = width / 2;
		final float hh = height / 2;
		
		setVertex(
				-hw, -hh, 
				-hw,  hh,
				 hw, -hh,
				 hw,  hh);
		
		this.halfWidth = hw;
		this.halfHeight = hh;
	}
	
	public void SetTexCoordsU(float left, float right) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetTexCoordsU left:" + left + ",right:" + right);
		}
		
		u0 = left; u1 = left;
		u2 = right; u3 = right;
	}
	
	public void SetTexCoordsV(float bottom, float top) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetTexCoordsV bottom:" + bottom + ",top:" + top);
		}
		
		v0 = bottom; v3 = bottom;
		v1 = top;    v2 = top;
	}
	
	public void Draw() {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "Draw");
		}
		
		float[] mvp = JavaInterface.getInstance().getRenderer().GetMVPMatrix();
		draw(mvp);
	}
	
	private static final String UNIFORM_TEXTURE = "u_Texture";
	private static final String ATTRIBUTE_TEXTURE_COORDINATE = "a_TexCoordinate";
	
	@Override
	protected List<ShaderSource> SHADER_SOURCES() {
		
		List<ShaderSource> result = new ArrayList<ShaderSource>();
		
		final String VERTEX_SHADER_CODE =
				"uniform mat4 uMVPMatrix;" +
				"attribute vec4 vPosition;" +
				"attribute vec2 a_TexCoordinate;" +
				"varying vec2 v_TexCoordinate;" +
				"void main() {" +
				"  v_TexCoordinate = a_TexCoordinate;" +
				"  gl_Position = uMVPMatrix * vPosition;" +
				"}";
		
		result.add(new ShaderSource(GLES20.GL_VERTEX_SHADER,
				VERTEX_SHADER_CODE, DEFAULT_ATTR_POSITION, ATTRIBUTE_TEXTURE_COORDINATE));
		
		final String FRAGMENT_SHADER_CODE =
			    "precision mediump float;" +
			    "uniform vec4 vColor;" +
			    "varying vec2 v_TexCoordinate;" +
			    "uniform sampler2D u_Texture;" +
			    "void main() {" +
			    "  gl_FragColor = vColor + texture2D(u_Texture,v_TexCoordinate);" +
			    "}";
		
		result.add(new ShaderSource(GLES20.GL_FRAGMENT_SHADER,
				FRAGMENT_SHADER_CODE));
		
		return result;
	}

	@Override
	public void setVertex(float... values) {
		
		vertex.set(values);
	}
	
	@Override
	protected void setUniformMVP(int program, String uniformName, float[] value) {
		
		Matrix.setIdentityM(modelMatrix, 0);
		Matrix.scaleM(modelMatrix, 0, transform.GetScale(), transform.GetScale(), 1);
		Matrix.rotateM(modelMatrix, 0, transform.GetRotateByRadian(), 0, 0, 1);
		Matrix.translateM(modelMatrix, 0, transform.GetTranslateX() + halfWidth,
				transform.GetTranslateY() + halfHeight, 0);
		
		Matrix.multiplyMM(mvpMatrix, 0, value, 0, modelMatrix, 0);
		
		final int MVPMatrixIndex = GLES20.glGetUniformLocation(program, uniformName);
		GLES20.glUniformMatrix4fv(MVPMatrixIndex, 1, false, mvpMatrix, 0);
	}
	
	@Override
	protected void onDraw() {
		
		if (texture != null) {
			texture.draw(getShaderProgram(), 
					UNIFORM_TEXTURE, ATTRIBUTE_TEXTURE_COORDINATE, 
					u0, v0, u1, v1, u3, v3, u2, v2);
		}
		
		GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, VERTEX_COUNT());
	}
	
	@Override
	protected int VERTEX_COUNT() {
		return 4;
	}
	
	private Texture texture;
	// texture coordinates
	private float u0, v0, u1, v1, u2, v2, u3, v3;
	private AndroidTransform transform;
	
	private float halfWidth, halfHeight;
	private final float[] modelMatrix = new float[16];
	private final float[] mvpMatrix = new float[16];
}
