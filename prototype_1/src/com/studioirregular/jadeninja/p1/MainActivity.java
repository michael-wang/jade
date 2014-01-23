package com.studioirregular.jadeninja.p1;

import android.os.Bundle;
import android.view.Menu;

import com.studioirregular.gaoframework.AbsGameActivity;

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
}
