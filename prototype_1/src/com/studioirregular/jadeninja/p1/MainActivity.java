package com.studioirregular.jadeninja.p1;

import android.os.Bundle;
import android.util.Log;
import android.view.Menu;

import com.studioirregular.gaoframework.AbsGameActivity;

public class MainActivity extends AbsGameActivity {

	private static final String TAG = "main-activity";
	
	protected String delegateUpdateLua() {
		return "lua/DelegateUpdate.lua";
	}
	
	protected String delegateRenderLua() {
		return "lua/DelegateRender.lua";
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.w(TAG, "onCreate");
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
}
