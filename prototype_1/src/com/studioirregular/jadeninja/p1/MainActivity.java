package com.studioirregular.jadeninja.p1;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;

public class MainActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		System.loadLibrary("jadeninja");
		nativeCreate();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		nativeDestroy();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	private native void nativeCreate();
	private native void nativeDestroy();

}
