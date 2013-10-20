package com.studioirregular.gaoframework;

import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.CharBuffer;

import android.content.Context;

public class AssetHelper {

	public String getFileContent(Context context, String filename) {
		
		InputStreamReader reader = null;
		try {
			reader = new InputStreamReader(
					context.getAssets().open(filename));
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		
		StringBuilder result = new StringBuilder();
		CharBuffer buf = CharBuffer.allocate(1024);
		
		try {
			int count = reader.read(buf);
			while (count >= 0) {
				result.append(buf.array(), 0, count);
	
				count = reader.read(buf);
			}
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}

		return result.toString();
	}
}
