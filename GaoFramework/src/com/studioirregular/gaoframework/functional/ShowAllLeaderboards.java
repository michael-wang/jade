package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.GameServices;

public class ShowAllLeaderboards implements Function_0V {

	@Override
	public void run() {
		GameServices.getInstance().ShowAllLeaderboards();
	}

}
