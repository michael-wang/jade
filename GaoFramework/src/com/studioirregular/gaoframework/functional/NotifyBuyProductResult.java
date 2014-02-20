package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.NativeInterface;

public class NotifyBuyProductResult implements Function_2V<String, Boolean> {

	private final String id;
	private final Boolean success;
	
	public NotifyBuyProductResult(String id, Boolean success) {
		this.id = id;
		this.success = success;
	}
	
	@Override
	public void run() {
		NativeInterface.getInstance().NotifyBuyResult(id, success);
	}

}
