package com.studioirregular.gaoframework;

/*
 * Game parameters you can change (on development time, not runtime).
 */
public class Config {

	public static enum AssetType {
		Phone,
		Tablet
	};
	public static final AssetType ASSET_TYPE = AssetType.Phone;
	
	public static final int PHONE_WORLD_LONG = 480;
	public static final int PHONE_WORLD_SHORT = 320;
	
	public static final int TABLET_WORLD_LONG = 960;
	public static final int TABLET_WORLD_SHORT = 640;
	
	public static final int WORLD_LONG_SIDE = 
			(ASSET_TYPE == AssetType.Phone) ? 
					PHONE_WORLD_LONG : TABLET_WORLD_LONG;
	
	public static final int WORLD_SHORT_SIDE = 
			(ASSET_TYPE == AssetType.Phone) ? 
					PHONE_WORLD_SHORT : TABLET_WORLD_SHORT;
}
