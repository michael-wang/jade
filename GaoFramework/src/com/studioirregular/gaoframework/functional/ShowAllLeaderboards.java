package com.studioirregular.gaoframework.functional;

import android.support.v4.app.DialogFragment;

import com.studioirregular.gaoframework.AbsGameActivity;
import com.studioirregular.gaoframework.ConnectGooglePlayGamesDialog;
import com.studioirregular.gaoframework.GameServices;

public class ShowAllLeaderboards extends Operation_1V<AbsGameActivity> {

	public ShowAllLeaderboards(AbsGameActivity arg1) {
		super(arg1);
	}

	@Override
	public void run() {
		
		final AbsGameActivity activity = arg1;
		
		if (GameServices.getInstance().isConnected()) {
			GameServices.getInstance().ShowAllLeaderboards();
		} else {
			DialogFragment dialog = ConnectGooglePlayGamesDialog.newInstance(ShowAllLeaderboards.this);
			dialog.show(activity.getSupportFragmentManager(), "dialog");
		}
	}

}
