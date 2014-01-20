package com.studioirregular.gaoframework;

import java.io.File;

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
		
		private static String ASSET_PATH = null;
		private static String IMAGE_PATH = null;
		private static String SOUND_PATH = null;
		
		private static String GetAssetPath() {
			
			if (ASSET_PATH != null) {
				return ASSET_PATH;
			}
			
			if (BuildConfig.DEBUG) {
				// On debug mode, asset files are pushed to SD card,
				// so APK is smaller to faster debug iteration.
				ASSET_PATH = Environment.getExternalStoragePublicDirectory(
						Environment.DIRECTORY_DOWNLOADS).getAbsolutePath();
			} else {
				ASSET_PATH = "";
			}
			
			return ASSET_PATH;
		}
		
		public static String GetImagePath() {
			
			if (IMAGE_PATH != null) {
				return IMAGE_PATH;
			}
			
			if (BuildConfig.DEBUG) {
				IMAGE_PATH = GetAssetPath() + File.separator + "Image" + File.separator;
			} else {
				IMAGE_PATH = GetAssetPath();
			}
			
			return IMAGE_PATH;
		}
		
		public static String GetSoundPath() {
			
			if (SOUND_PATH != null) {
				return SOUND_PATH;
			}
			
			if (BuildConfig.DEBUG) {
				SOUND_PATH = GetAssetPath() + File.separator + "Sound" + File.separator;
			} else {
				SOUND_PATH = GetAssetPath();
			}
			
			return SOUND_PATH;
		}
		
		public static String CopyLuaScriptFolderTo(Context context) {
			
			if (BuildConfig.DEBUG) {
				// On debug mode, lua files are saved to SD card,
				// so I can modify lua and push it without rebuild APK.
				return Environment.getExternalStoragePublicDirectory(
						Environment.DIRECTORY_DOWNLOADS).getAbsolutePath();
			} else {
				if (context != null) {
					return context.getFilesDir().getAbsolutePath();
				} else {
					throw new RuntimeException("Cannot decide where to put lua scripts.");
				}
			}
		}
		
		public static final String LUA_SCRIPT_FOLDER = "LuaScript";
		
		public static String GetLuaScriptPath(Context context) {
			
			return CopyLuaScriptFolderTo(context) + File.separator
					+ LUA_SCRIPT_FOLDER + File.separator;
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
