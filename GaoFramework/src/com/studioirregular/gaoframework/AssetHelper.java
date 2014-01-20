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
	// This function copy files from
	//   "asset://fromAssetFolder/*"
	// to
	//   "toFolder/fromAssetFolder/*"
	// Recursively.
	public void copyAssetsToStorage(AssetManager am, String fromAssetFolder,
			File toFolder) throws IOException {
		if (DEBUG_LOG) {
			Log.d(TAG, "copyAssetsToStorage fromAssetFolder:" + fromAssetFolder
					+ ",toFolder:" + toFolder.getAbsolutePath());
		}
		
		File from = new File(fromAssetFolder);
		File to = new File(toFolder, fromAssetFolder);
		
		copyFolder(am, from, to);
	}
	
	private void copyFolder(AssetManager am, File from, File to) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "copyFolder from:" + from.getAbsolutePath() + ",to:"
					+ to.getAbsolutePath());
		}
		
		String[] assetList = listFilesUnderFolder(am, from);
		final boolean isFolder = assetList != null && (assetList.length > 0);
		
		if (isFolder) {
			if (!to.exists()) {
				to.mkdir();
			}
			
			for (String asset : assetList) {
				File nextFrom = new File(from, asset);
				File nextTo = new File(to, asset);
				
				copyFolder(am, nextFrom, nextTo);
			}
		} else {
			try {
				copyFile(am, from, to);
			} catch (IOException e) {
				if (DEBUG_LOG) {
					e.printStackTrace();
				}
			}
		}
	}
	
	private String[] listFilesUnderFolder(AssetManager am, File absolutePath) {
		
		final String relativePath = absolutePath.getAbsolutePath().substring(1);
		try {
			return am.list(relativePath);
		} catch (IOException e) {
			if (DEBUG_LOG) {
				e.printStackTrace();
			}
		}
		return new String[0];
	}
	
	private void copyFile(AssetManager am, File from, File to) throws IOException {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "copyFile from:" + from.getAbsolutePath() + ",to:" + to.getAbsolutePath());
		}
		
//		if (!to.exists()) {
//			to.createNewFile();
//		}
		
		final String relativePath = from.getAbsolutePath().substring(1);
		InputStream is = am.open(relativePath, AssetManager.ACCESS_BUFFER);
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
