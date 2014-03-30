package com.studioirregular.gaoframework;

import android.util.Log;

public class Global {

	// file name for shared preferences
	public static final String PREF_ASSET_FILE_COPY_STATE = "asset_file_copy_state";
	
	public static class World2ViewMapping {
		private static final String TAG = "java-Global::World2ViewMapping";
		private static final boolean DEBUG_LOG = false;
		
		// Game logic dealing with fixed game world size.
		public float worldWidth = -1;
		public float worldHeight = -1;
		
		/*
		 * Game world is scaling (up or down) to fit into OpenGL surface, which
		 * I call it a view. The view is centered on the GL surface, leaving a
		 * gap on X or Y axis, which is viewOffsetX/Y.
		 */
		public float viewOffsetX = -1;
		public float viewOffsetY = -1;
		public float viewWidth = -1;
		public float viewHeight= -1;
		
		private World2ViewMapping(float surfaceWidth, float surfaceHeight) {
			
			assert(surfaceWidth > 0);
			assert(surfaceHeight > 0);
			
			setupWorldDimension(surfaceWidth, surfaceHeight);
			assert(worldWidth != -1);
			assert(worldHeight != -1);
			
			setupViewDimension(surfaceWidth, surfaceHeight);
			assert(viewOffsetX != -1);
			assert(viewOffsetY != -1);
			assert(viewWidth != -1);
			assert(viewHeight != -1);
		}
		
		private void setupWorldDimension(float surfaceWidth, float surfaceHeight) {
			
			final boolean portrait = surfaceWidth <= surfaceHeight;
			
			worldWidth = portrait ? Config.WORLD_SHORT_SIDE
					: Config.WORLD_LONG_SIDE;
			worldHeight = portrait ? Config.WORLD_LONG_SIDE
					: Config.WORLD_SHORT_SIDE;
			if (DEBUG_LOG) {
				Log.d(TAG, "onSurfaceChanged worldWidth:" + worldWidth
						+ ",worldHeight:" + worldHeight);
			}
		}
		
		private void setupViewDimension(float surfaceWidth, float surfaceHeight) {
			
			final float sx = surfaceWidth / worldWidth;
			final float sy = surfaceHeight / worldHeight;
			final float scalingFactor = Math.min(sx, sy);
			if (DEBUG_LOG) {
				Log.d(TAG, "sx:" + sx + ",sy:" + sy + ",scalingFactor:" + scalingFactor);
			}
			
			viewWidth = worldWidth * scalingFactor;
			viewHeight = worldHeight * scalingFactor;
			if (DEBUG_LOG) {
				Log.d(TAG, "viewWidth:" + viewWidth + ",viewHeight:" + viewHeight);
			}
			
			viewOffsetX = (surfaceWidth - viewWidth) / 2;
			viewOffsetY = (surfaceHeight - viewHeight) / 2;
			if (DEBUG_LOG) {
				Log.d(TAG, "viewOffsetX:" + viewOffsetX + ",viewOffsetY:" + viewOffsetY);
			}
		}
	}
	
	private static World2ViewMapping world2ViewMapping;
	
	public static void initWorld2ViewMapping(float surfaceWidth,
			float surfaceHeight) {
		
		world2ViewMapping = new World2ViewMapping(surfaceWidth, surfaceHeight);
	}

	public static World2ViewMapping getWorld2ViewMapping() {
		return world2ViewMapping;
	}
	
	// Reserved activity request code used by framework, client activity should
	// NOT using values in the range.
	public static final int FRAMEWORK_ACTIVITY_CODE_START = 0x2A; // Ha! I got it, its 42. Now what's the question again...
	public static final int FRAMEWORK_ACTIVITY_CODE_END   = 0xFF;
	
	// Lua global function names.
	public static final String LUA_IS_SFX_ENABLED = "IsSfxEnabled";
	public static final String LUA_IS_BGM_ENABLED = "IsBgmEnabled";
}
