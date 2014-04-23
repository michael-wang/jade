package com.studioirregular.gaoframework.functional;

import android.support.v4.app.DialogFragment;

import com.studioirregular.gaoframework.AbsGameActivity;
import com.studioirregular.gaoframework.ConnectGooglePlayGamesDialog;
import com.studioirregular.gaoframework.GameServices;

public class ShowLeaderboard extends Operation_2V<AbsGameActivity, String> {

	public ShowLeaderboard(AbsGameActivity activity, String id) {
		super(activity, id);
	}

	@Override
	public void run() {
		
		final AbsGameActivity activity = arg1;
		final String leaderboardId = arg2;
		
		if (GameServices.getInstance().isConnected()) {
			GameServices.getInstance().ShowLeaderboard(leaderboardId);
		} else {
			DialogFragment dialog = ConnectGooglePlayGamesDialog.newInstance(ShowLeaderboard.this);
			dialog.show(activity.getSupportFragmentManager(), "dialog");
		}
	}

}
