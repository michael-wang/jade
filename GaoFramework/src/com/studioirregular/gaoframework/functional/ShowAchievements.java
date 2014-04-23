package com.studioirregular.gaoframework.functional;

import android.support.v4.app.DialogFragment;

import com.studioirregular.gaoframework.AbsGameActivity;
import com.studioirregular.gaoframework.ConnectGooglePlayGamesDialog;
import com.studioirregular.gaoframework.GameServices;

public class ShowAchievements extends Operation_1V<AbsGameActivity> {

	public ShowAchievements(AbsGameActivity activity) {
		super(activity);
	}

	@Override
	public void run() {
		
		final AbsGameActivity activity = arg1;
		
		if (GameServices.getInstance().isConnected()) {
			GameServices.getInstance().ShowAchievements();
		} else {
			DialogFragment dialog = ConnectGooglePlayGamesDialog.newInstance(ShowAchievements.this);
			dialog.show(activity.getSupportFragmentManager(), "dialog");
		}
	}

}
