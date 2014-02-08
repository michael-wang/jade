package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.gles.GLThread;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;

public class PresentAlertDialog implements Function_4V<Context, String, String, String> {

	private Context context;
	private String title;
	private String message;
	private String positiveButton;
	
	public PresentAlertDialog(Context context, String title, String message, String positiveButton) {
		this.context = context;
		this.title = title;
		this.message = message;
		this.positiveButton = positiveButton;
	}

	@Override
	public void run() {
		
		AlertDialog.Builder builder = new AlertDialog.Builder(context);
		builder.setTitle(title).setMessage(message).setCancelable(true);
		builder.setOnCancelListener(new DialogInterface.OnCancelListener() {
			
			@Override
			public void onCancel(DialogInterface dialog) {
				notifyResult(false);
			}
		});
		
		if (positiveButton != null) {
			builder.setPositiveButton(positiveButton, new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					notifyResult(true);
				}
			});
		}
		
		final AlertDialog dialog = builder.create();
		dialog.show();
	}
	
	private void notifyResult(boolean positiveConfirmed) {
		
		Function_1V<Boolean> notifyOperation = new NotifyAlertDialogResult(positiveConfirmed);
		
		GLThread.getInstance().scheduleOperation(notifyOperation);
	}

}
