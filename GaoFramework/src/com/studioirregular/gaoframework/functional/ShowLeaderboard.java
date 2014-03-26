package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.GameServices;

public class ShowLeaderboard extends Operation_1V<String> {

	public ShowLeaderboard(String arg1) {
		super(arg1);
	}

	@Override
	public void run() {
		GameServices.getInstance().ShowLeaderboard(arg1);
	}

}
