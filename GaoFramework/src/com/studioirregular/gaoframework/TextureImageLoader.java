package com.studioirregular.gaoframework;

import java.io.IOException;
import java.io.InputStream;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

/*
 * This class hide details of image loading from texture.
 * Details including image are loaded from asset or resource.
 */
public class TextureImageLoader {

	private static final String TAG = "java-TextureImageLoader";
	private static final boolean DEBUG_LOG = false;
	
	public Bitmap loadFromAsset(String path) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "loadFromAsset path:" + path);
		}
		
		AssetManager am = JavaInterface.getInstance().getContext().getAssets();
		
		InputStream is = null;
		try {
			is = am.open(path);
		} catch (IOException e) {
			if (BuildConfig.DEBUG) {
				e.printStackTrace();
			}
			return null;
		}
		
		Bitmap bmp = null;
		try {
			bmp = BitmapFactory.decodeStream(is);
		} catch (OutOfMemoryError e) {
			if (BuildConfig.DEBUG) {
				e.printStackTrace();
			}
			return null;
		}
		
		return bmp;
	}
	
	public Bitmap loadFromStorage(String path) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "loadFromStorage path:" + path);
		}
		
		return BitmapFactory.decodeFile(path);
	}
}
