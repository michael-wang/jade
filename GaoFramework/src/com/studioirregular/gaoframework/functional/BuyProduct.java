package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.AbsGameActivity;

public class BuyProduct implements Function_2V<String, AbsGameActivity> {

	private final String id;
	private final AbsGameActivity activity;
	
	public BuyProduct(String id, AbsGameActivity activity) {
		this.id = id;
		this.activity = activity;
	}
	
	@Override
	public void run() {
		
		activity.buyProduct(id);
	}

}
