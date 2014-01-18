package com.studioirregular.gaoframework;

import android.content.Context;
import android.os.Environment;

/*
 * Game parameters you can change (on development time, not runtime).
 */
public class Config {

	public static class Asset {
		
		public static enum Type {
			Phone,
			Tablet,
		};
		
		public static final Type TYPE = Type.Phone;
		
		public static String GetAssetFileFolder(Context context) {
			if (BuildConfig.DEBUG) {
				// On debug mode, copy it to somewhere I can easily override the lua
				// files, to make debug easier.
				return Environment.getExternalStoragePublicDirectory(
						Environment.DIRECTORY_DOWNLOADS).getAbsolutePath();
			} else {
				if (context != null) {
					return context.getFilesDir().getAbsolutePath();
				} else {
					return "";
				}
			}
		}
	}
	
	public static final int PHONE_WORLD_LONG = 480;
	public static final int PHONE_WORLD_SHORT = 320;
	
	public static final int TABLET_WORLD_LONG = 960;
	public static final int TABLET_WORLD_SHORT = 640;
	
	public static final int WORLD_LONG_SIDE = 
			(Asset.TYPE == Asset.Type.Phone) ? 
					PHONE_WORLD_LONG : TABLET_WORLD_LONG;
	
	public static final int WORLD_SHORT_SIDE = 
			(Asset.TYPE == Asset.Type.Phone) ? 
					PHONE_WORLD_SHORT : TABLET_WORLD_SHORT;
}
