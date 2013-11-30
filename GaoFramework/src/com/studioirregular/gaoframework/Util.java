package com.studioirregular.gaoframework;

import java.nio.FloatBuffer;

import android.util.Log;

public class Util {

	public static void log(String tag, String bufName, FloatBuffer buf) {
		
		StringBuilder msg = new StringBuilder(bufName).append(" : ");
		
		while (buf.hasRemaining()) {
			msg.append(buf.get()).append(",");
		}
		buf.rewind();
		
		Log.d(tag, msg.toString());
	}
	
	public static void log(String tag, String matrixName, float[] matrix, final int M, final int N) {
		
		StringBuilder msg = new StringBuilder(matrixName);
		
		for (int y = 0; y < N; y++) {
			msg.append("\n\t");
			for (int x = 0; x < M; x++) {
				final String entry = String.format("%1$ 4.4f", matrix[x*4 + y]);
				msg.append(entry).append("\t");
			}
		}
		msg.append("\n");
		
		Log.d(tag, msg.toString());
	}
	
	/*
	 * Switch row with column of a matrix.
	 * When I GLES20.glUniformMatrix4fv with this matrix:
	 *   [ 1 0 0 dx ]
	 *   [ 0 1 0 dy ]
	 *   [ 0 0 1 0  ]
	 *   [ 0 0 0 1  ]
	 * There is a rotation effect. 
	 * And I found if I swith row/column of dx, dy, it works:
	 *   [ 1  0 0 0 ]
	 *   [ 0  1 0 0 ]
	 *   [ 0  0 1 0 ]
	 *   [dx dy 0 1 ]
	 * TODO: do the math to find out what happened.
	 */
	public static void fixTranslation(float[] matrix) {
	    float tmp = matrix[3]; matrix[3] = matrix[12]; matrix[12] = tmp;
	    tmp = matrix[7]; matrix[7] = matrix[13]; matrix[13] = tmp;
	}
}
