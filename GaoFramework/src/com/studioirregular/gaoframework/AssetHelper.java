package com.studioirregular.gaoframework;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.CharBuffer;

import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;

public class AssetHelper {

	private static final String TAG = "java-AssetHelper";
	private static final boolean DEBUG_LOG = false;
	
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
	
	// Asset files are in APK which cannot be use by native code as regular file.
	// A temporary solution is to move asset files into storage.
	public void copyAssetsToStorage(AssetManager am, String fromAssetFolder,
			File toPath) throws IOException {
		if (DEBUG_LOG) {
			Log.d(TAG, "copyAssetsToStorage fromAssetFolder:" + fromAssetFolder
					+ ", toPath:" + toPath.getAbsolutePath());
		}
		
		File toFolder = new File(toPath, fromAssetFolder);
		toFolder.mkdir();
		
		final String[] files = am.list(fromAssetFolder);
		if (files == null) {
			return;
		}
		
		for (final String fileName : files) {
			if (DEBUG_LOG) {
				Log.d(TAG, "try to copy asset file:" + fileName);
			}
			
			final String from = fromAssetFolder + File.separator + fileName;
			File to = new File(toFolder, fileName);
			copyFile(am, from, to);
		}
	}
	
	private void copyFile(AssetManager am, String assetFile,
			File toFile) throws IOException {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "copyfile assetFile:" + assetFile + ",toFile:"
				+ toFile.getAbsolutePath());
		}

		InputStream is = am.open(assetFile, AssetManager.ACCESS_BUFFER);
		copy(is, toFile);
		
		if (DEBUG_LOG) {
			Log.d(TAG, "#" + toFile.getName() + ":" + toFile.length());
		}
	}
	
	private void copy(InputStream is, File to) throws IOException {
		
		if (!to.exists()) {
			to.createNewFile();
		}
		
		OutputStream os = null;
		
		try {
			os = new FileOutputStream(to);
			
			byte[] buf = new byte[1024];
			int len;
			
			while ((len = is.read(buf)) > 0) {
				os.write(buf, 0, len);
			}
		} finally {
			if (is != null) is.close();
			if (os != null) os.close();
		}
	}
}
