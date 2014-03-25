package com.monkeypotion.jadeninja;

import android.os.Bundle;
import android.view.Menu;
import com.monkeypotion.jadeninja.R;
import com.studioirregular.gaoframework.AbsGameActivity;
import com.studioirregular.gaoframework.GameProducts;

/*
 * Notice: do not use activity request code between: 
 * [Global.FRAMEWORK_ACTIVITY_CODE_START, Global.FRAMEWORK_ACTIVITY_CODE_END].
 */
public class MainActivity extends AbsGameActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	@Override
	protected GameProducts getGameProducts() {
		return new JadeNinjaGameProducts();
	}
	
	@Override
	protected String getPublicKey() {
		return "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm0w8J+/+vL9EPy1fnNDAYFWv9CQeic9Yzw45ITKprz28tCG/Rz2wQKcg4APU0X+EKrrrhJazN1D1Suykl36FLfXELSLQYUXTVSq4Bnn1ZfJqL3vTL+OfHg25D101PPe73qbCOjUQAJBzbzLOTnx3P54mAn2FfpKWTAF/wc9YJXD8Y3zVjPHjn/GBM+uEgtRpX8B4fYGSEpo56x69Ag/u90Yh/ZaQFCJoJoo0BpHinjKjSEheKB8Nn1EcDKJesxUWzMo5faeUi4T2vbdXfFEpFByDcLGVRIUGsfOVUxZRCrzB0h5GztaW8HWA7h1l1t/LmkEAURBfLY4gjCv+WfdQDQIDAQAB";
	}
	
	@Override
	protected int getSplashImageResource() {
		return R.drawable.splash;
	}
}
