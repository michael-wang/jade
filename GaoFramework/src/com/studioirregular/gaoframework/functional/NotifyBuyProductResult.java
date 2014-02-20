package com.studioirregular.gaoframework.functional;

import android.util.Log;

import com.studioirregular.gaoframework.NativeInterface;

public class NotifyBuyProductResult implements Function_2V<String, Boolean> {

	private static final String TAG = "java-NotifyBuyProductResult";
	
	private final String id;
	private final Boolean success;
	
	public NotifyBuyProductResult(String id, Boolean success) {
		Log.d(TAG, "NotifyBuyProductResult id:" + id + ",success:" + success);
		this.id = id;
		this.success = success;
	}
	
	@Override
	public void run() {
		NativeInterface.getInstance().NotifyBuyResult(id, success);
	}

}
