package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.NativeInterface;

public class NotifyPurchaseRestored implements Function_1V<String> {

	private final String id;
	
	public NotifyPurchaseRestored(String id) {
		this.id = id;
	}
	
	@Override
	public void run() {
		NativeInterface.getInstance().NotifyPurchaseRestored(id);
	}

}
