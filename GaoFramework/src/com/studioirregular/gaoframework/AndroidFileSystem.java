package com.studioirregular.gaoframework;

import java.io.File;

import android.content.Context;
import android.os.Environment;
import android.util.Log;

public class AndroidFileSystem {

	private static final String TAG = "java-AndroidFileSystem";
	private static final boolean DEBUG_LOG = false;
	
	/*
	 * In my understanding, this path is for log file, so it should be easy for
	 * developer to access. Which is why I choose to use the download folder in
	 * SD card.
	 */
	public static String MakeFullPath(String filename) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "MakeFullPath filename:" + filename);
		}
		
		File DOWNLOAD_FOLDER = Environment
				.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
		
		File file = new File(DOWNLOAD_FOLDER, filename);
		
		String result = file.getAbsolutePath();
		
		if (DEBUG_LOG) {
			Log.d(TAG, "MakeFullPath result:" + result);
		}
		
		return result;
	}
	
	/*
	 * In my understanding, this path is used to save App private data, so its
	 * not supposed to be accessible by user. Which is why I choose application
	 * folder.
	 */
	public static String MakeDocumentPath(String filename) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "MakeDocumentPath filename:" + filename);
		}
		
		Context context = JavaInterface.getInstance().getContext();
		
		if (context == null) {
			Log.w(TAG, "MakeDocumentPath context == null");
			return filename;
		}
		
		String result = context.getFilesDir().getAbsolutePath() + File.separatorChar + filename;
		
		if (DEBUG_LOG) {
			Log.d(TAG, "MakeDocumentPath result:" + result);
		}
		
		return result;
	}
}
