package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.NativeInterface;

public class NotifyStateLoadedFromCloud implements Function_1V<String> {

	public NotifyStateLoadedFromCloud(String path) {
	}
	
	@Override
	public void run() {
		
		NativeInterface.getInstance().NotifyStateLoadedFromCloud();
	}

}
