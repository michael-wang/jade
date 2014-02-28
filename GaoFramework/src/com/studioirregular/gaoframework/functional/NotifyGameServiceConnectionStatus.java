package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.NativeInterface;

public class NotifyGameServiceConnectionStatus implements Function_1V<Boolean> {
	
	private Boolean connected;
	
	public NotifyGameServiceConnectionStatus(Boolean connected) {
		this.connected = connected;
	}

	@Override
	public void run() {
		NativeInterface.getInstance().NotifyGameServiceConnectionStatus(connected);
	}

}
