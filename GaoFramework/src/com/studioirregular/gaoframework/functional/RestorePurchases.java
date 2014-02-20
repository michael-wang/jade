package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.AbsGameActivity;

public class RestorePurchases implements Function_1V<AbsGameActivity> {

	private final AbsGameActivity activity;
	
	public RestorePurchases(AbsGameActivity activity) {
		this.activity = activity;
	}
	
	@Override
	public void run() {
		
		if (activity != null) {
			activity.restorePurchases();
		}
	}

}
