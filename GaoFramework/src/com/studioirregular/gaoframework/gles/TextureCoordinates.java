package com.studioirregular.gaoframework.gles;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

import android.util.Log;

/* Coordinate sequence:
 * (u1, v1) ---> (u2, v2)
 *    ^              |
 *    |              v
 * (u0, v0)      (u3, v3)
 */
public class TextureCoordinates {
	
	private static final String TAG = "java-TextureCoordinates";
	private static final boolean DEBUG_LOG = false;
	
	// Quad formed by 4 points, each has 2 components (U/V), each component is a
	// float.
	static final int POINTS = 4;
	static final int COMPONENTS_PER_POINT = 2;
	static final int BYTES_PER_COMPONENT = 4;
	
	public TextureCoordinates() {
		
		final int BUF_SIZE = POINTS * COMPONENTS_PER_POINT * BYTES_PER_COMPONENT;
		buf = ByteBuffer
				.allocateDirect(BUF_SIZE)
				.order(ByteOrder.nativeOrder())
				.asFloatBuffer();
		buf.position(0);
	}
	
	public void set(
			float u0, float v0, 
			float u1, float v1, 
			float u2, float v2, 
			float u3, float v3) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "set u0:" + u0 + ",v0:" + v0 + 
					"\n    u1:" + u1 + ",v1:" + v1 + 
					"\n    u2:" + u2 + ",v2:" + v2 + 
					"\n    u3:" + u3 + ",v3:" + v3);
		}
		
		buf.position(0);
		
		buf.put(u0).put(v0)
		   .put(u1).put(v1)
		   .put(u2).put(v2)
		   .put(u3).put(v3);
		
		buf.position(0);
	}
	
	public FloatBuffer get() {
		return buf;
	}
	
	@Override
	public String toString() {
		return "TextureCoordinates\n\tu0:" + buf.get(0) + ",v0:" + buf.get(1) + 
				"\n\tu1:" + buf.get(2) + ",v1:" + buf.get(3) + 
				"\n\tu2:" + buf.get(4) + ",v2:" + buf.get(5) + 
				"\n\tu3:" + buf.get(6) + ",v3:" + buf.get(7);
	}

	private FloatBuffer buf;
}
