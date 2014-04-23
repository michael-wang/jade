package com.studioirregular.gaoframework;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;

public class ConnectGooglePlayGamesDialog extends DialogFragment {

	public static ConnectGooglePlayGamesDialog newInstance(Runnable pendingActionAfterConnection) {
		
		ConnectGooglePlayGamesDialog result = new ConnectGooglePlayGamesDialog();
		result.setPendingAction(pendingActionAfterConnection);
		return result;
	}
	
	private Runnable pendingActionAfterConnection;
	
	public void setPendingAction(Runnable pendingActionAfterConnection) {
		this.pendingActionAfterConnection = pendingActionAfterConnection;
	}
	
	@Override
	public Dialog onCreateDialog(Bundle savedInstanceState) {
		
		AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
		
		builder.setIcon(R.drawable.btn_gplus);
		builder.setTitle(JavaInterface.getInstance().GetString("signin_google_play_title"));
		builder.setMessage(JavaInterface.getInstance().GetString("signin_google_play_message"));
		
		builder.setPositiveButton(JavaInterface.getInstance().GetString("signin_google_play_positive"), 
				new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				
				if (pendingActionAfterConnection != null) {
					GameServices.getInstance().connect(pendingActionAfterConnection);
				} else {
					GameServices.getInstance().connect();
				}
			}
		});
		
		builder.setNegativeButton(JavaInterface.getInstance().GetString("signin_google_play_negative"), null);
		
		return builder.create();
	}
	
}
