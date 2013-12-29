package com.studioirregular.gaoframework.gles;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

import android.opengl.GLES20;

public class Vertex {

	public Vertex(int vertexCount, int elementPerVertex) {
		
		ELEMENT_PER_VERTEX = elementPerVertex;
		VERTEX_STRIDE = elementPerVertex * BYTES_PER_ELEMENT;
		
		vertexBuffer = initBuffer(vertexCount, elementPerVertex);
	}
	
	public Vertex put(int i, float value) {
		vertexBuffer.put(i, value);
		return this;
	}
	
	public void finishPut() {
		vertexBuffer.position(0);
	}
	
	public void bindValueToAttribute(int shaderProgram, String attrName) {
		
		attributeIndex = GLES20.glGetAttribLocation(shaderProgram, attrName);
		
		GLES20.glEnableVertexAttribArray(attributeIndex);
		
		GLES20.glVertexAttribPointer(attributeIndex, ELEMENT_PER_VERTEX,
				GLES20.GL_FLOAT, false, VERTEX_STRIDE, vertexBuffer);
	}
	
	public void unbindValueToAttribute() {
		
		GLES20.glDisableVertexAttribArray(attributeIndex);
		
		attributeIndex = INVALID_ATTRIBUTE_INDEX;
	}
	
	protected FloatBuffer initBuffer(int vertexCount, int elementPerVertex) {
		
		FloatBuffer buf = ByteBuffer
				.allocateDirect(vertexCount * elementPerVertex * BYTES_PER_ELEMENT)
				.order(ByteOrder.nativeOrder())
				.asFloatBuffer();
		buf.position(0);
		return buf;
	}
	
	private static final int BYTES_PER_ELEMENT = 4;
	private static final int INVALID_ATTRIBUTE_INDEX = -1;
	
	private final int ELEMENT_PER_VERTEX;
	private final int VERTEX_STRIDE;
	
	private FloatBuffer vertexBuffer;
	private int attributeIndex = INVALID_ATTRIBUTE_INDEX;
}
