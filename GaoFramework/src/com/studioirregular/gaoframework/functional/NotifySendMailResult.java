package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.NativeInterface;

public class NotifySendMailResult implements Function_1V<Boolean> {

	private final boolean success;
	
	public NotifySendMailResult(boolean success) {
		this.success = success;
	}
	
	@Override
	public void run() {
		
		NativeInterface.getInstance().NotifySendMailResult(success);
	}
}
