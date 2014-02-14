package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.NativeInterface;

public class NotifyPlayMovieResult implements Function_1V<Boolean> {

	public NotifyPlayMovieResult(boolean success) {
		// Lua don't care success or not, just needs to know it can keep moving.
	}
	
	@Override
	public void run() {
		
		NativeInterface.getInstance().NotifyPlayMovieComplete();
	}

}
