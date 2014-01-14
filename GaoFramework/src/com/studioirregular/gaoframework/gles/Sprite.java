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
	
	public void SetTexture(Texture texture) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetTexture texture:" + texture);
		}
		
		this.texture = texture;
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
		
		u1 = left; u3 = right;
		u0 = left; u2 = right;
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetTexCoordsU"
					+ "\n\tu0:" + u0 + "\tv0:" + v0
					+ "\n\tu1:" + u1 + "\tv1:" + v1
					+ "\n\tu2:" + u2 + "\tv2:" + v2
					+ "\n\tu3:" + u3 + "\tv3:" + v3);
		}
	}
	
	public void SetTexCoordsV(float bottom, float top) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetTexCoordsV bottom:" + bottom + ",top:" + top);
		}
		
		v1 = top;    v3 = top;
		v0 = bottom; v2 = bottom;
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetTexCoordsV"
					+ "\n\tu0:" + u0 + "\tv0:" + v0
					+ "\n\tu1:" + u1 + "\tv1:" + v1
					+ "\n\tu2:" + u2 + "\tv2:" + v2
					+ "\n\tu3:" + u3 + "\tv3:" + v3);
		}
	}
	
	public void SetQuadTexCoords(
			float u0, float v0, float u1, float v1, 
			float u2, float v2, float u3, float v3) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetQuadTexCoords"
					+ "\n\tu0:" + u0 + "\tv0:" + v0
					+ "\n\tu1:" + u1 + "\tv1:" + v1
					+ "\n\tu2:" + u2 + "\tv2:" + v2
					+ "\n\tu3:" + u3 + "\tv3:" + v3);
		}
		
		this.u0 = u0; this.v0 = v0;
		this.u1 = u1; this.v1 = v1;
		this.u2 = u2; this.v2 = v2;
		this.u3 = u3; this.v3 = v3;
	}
	
	// index: [1, 4].
	public void SetVertexData(int index, float x, float y, float u, float v) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetVertexData index:" + index + ",x:" + x + ",y:" + y
					+ ",u:" + u + ",v:" + v);
		}
		
		assert(1 <= index);
		assert(index <= VERTEX_COUNT());
		
		final int vertexIndex = index - 1;
		vertex.set(vertexIndex, x, y);
		
		switch (index) {
		case 1:
			u0 = u; v0 = v;
			break;
		case 2:
			u1 = u; v1 = 1;
			break;
		case 3:
			u2 = u; v2 = v;
			break;
		case 4:
			u3 = u; v3 = v;
			break;
		}
	}
	
	public void SetQuadVertices(
			float x0, float y0, float x1, float y1,
			float x2, float y2, float x3, float y3) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetQuadVertices x0:" + x0 + ",y0:" + y0 + ",x1:" + x1
					+ ",y1:" + y1 + ",x2:" + x2 + ",y2" + y2 + ",x3:" + x3
					+ ",y3:" + y3);
		}
		
		vertex.set(x0, y0, x1, y1, x2, y2, x3, y3);
	}
	
	public void SetOffset(float dx, float dy) {
		
		if (DEBUG_LOG()) {
			Log.d(TAG(), "SetOffset dx:" + dx + ",dy:" + dy);
		}
		
		this.dx = dx;
		this.dy = dy;
	}
	
	public void Draw() {
		
		this.dxDraw = 0;
		this.dyDraw = 0;
		float[] mvp = JavaInterface.getInstance().getRenderer().GetMVPMatrix();
		
		draw(mvp);
	}
	
	public void DrawOffset(int dx, int dy) {
		
		this.dxDraw = dx;
		this.dyDraw = dy;
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
		Matrix.translateM(modelMatrix, 0, 
				transform.GetTranslateX() + halfWidth + dx + dxDraw,
				transform.GetTranslateY() + halfHeight + dy + dyDraw, 
				0);
		Matrix.rotateM(modelMatrix, 0, transform.GetRotateByRadian(), 0, 0, 1);
		Matrix.scaleM(modelMatrix, 0, transform.GetScale(), transform.GetScale(), 1);
		
		Matrix.multiplyMM(mvpMatrix, 0, value, 0, modelMatrix, 0);
		
		final int MVPMatrixIndex = GLES20.glGetUniformLocation(program, uniformName);
		GLES20.glUniformMatrix4fv(MVPMatrixIndex, 1, false, mvpMatrix, 0);
	}
	
	@Override
	protected void onDraw() {
		
		if (texture != null) {
			texture.draw(getShaderProgram(), 
					UNIFORM_TEXTURE, ATTRIBUTE_TEXTURE_COORDINATE, 
					u0, v0, u1, v1, u2, v2, u3, v3);
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
	
	private float dx, dy;
	// Only given when Draw function called.
	private float dxDraw, dyDraw;
}
