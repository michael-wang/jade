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
}
