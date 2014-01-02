package com.studioirregular.gaoframework.gles;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

import android.opengl.GLES20;

public class Vertex {

	private static final String TAG = "java-Vertex";
	private static final boolean DEBUG_LOG = false;
	
	public Vertex(int vertexCount, int componentPerVertex) {
		
		VERTEX_COUNT = vertexCount;
		COMPONENT_PER_VERTEX = componentPerVertex;
		VERTEX_STRIDE = componentPerVertex * BYTES_PER_COMPONENT;
		
		fBuf = initBuffer(vertexCount, componentPerVertex);
	}
	
	public void set(float... values) {
		
		final int EXPECTED_LENGTH = VERTEX_COUNT * COMPONENT_PER_VERTEX;
		if (values.length != EXPECTED_LENGTH) {
			throw new IllegalArgumentException("Expect #values:"
					+ EXPECTED_LENGTH + ", but got:" + values.length);
		}
		
		fBuf.position(0);
		
		for (float v : values) {
			fBuf.put(v);
		}
		
		fBuf.position(0);
	}
	
	public void bindValueToAttribute(int shaderProgram, String attrName) {
		
		attributeIndex = GLES20.glGetAttribLocation(shaderProgram, attrName);
		errorChecker.hasError(TAG, "Failed when glGetAttribLocation attrName:" + attrName);
		
		GLES20.glEnableVertexAttribArray(attributeIndex);
		
		GLES20.glVertexAttribPointer(attributeIndex, COMPONENT_PER_VERTEX,
				GLES20.GL_FLOAT, false, VERTEX_STRIDE, fBuf);
		errorChecker.hasError(TAG, "Failed when glVertexAttribPointer");
	}
	
	public void unbindValueToAttribute() {
		
		GLES20.glDisableVertexAttribArray(attributeIndex);
		
		attributeIndex = INVALID_ATTRIBUTE_INDEX;
	}
	
	protected FloatBuffer initBuffer(int vertexCount, int elementPerVertex) {
		
		FloatBuffer buf = ByteBuffer
				.allocateDirect(vertexCount * elementPerVertex * BYTES_PER_COMPONENT)
				.order(ByteOrder.nativeOrder())
				.asFloatBuffer();
		buf.position(0);
		return buf;
	}
	
	protected static final int BYTES_PER_COMPONENT = 4;
	protected static final int INVALID_ATTRIBUTE_INDEX = -1;
	
	protected final int VERTEX_COUNT;
	protected final int COMPONENT_PER_VERTEX;
	protected final int VERTEX_STRIDE;
	
	protected FloatBuffer fBuf;
	protected int attributeIndex = INVALID_ATTRIBUTE_INDEX;
	
	protected GLError errorChecker = new GLError(DEBUG_LOG);
}
