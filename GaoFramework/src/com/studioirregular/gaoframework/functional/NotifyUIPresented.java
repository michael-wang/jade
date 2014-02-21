package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.NativeInterface;

/*
 * There are three Lua functions that need this callback when UI successfully presented:
 * - SendMail
 * - ShowLeaderboard
 * - ShowAchievements
 */
public class NotifyUIPresented implements Function_0V {

	@Override
	public void run() {
		
		NativeInterface.getInstance().NotifyUIPresented();
	}

}
