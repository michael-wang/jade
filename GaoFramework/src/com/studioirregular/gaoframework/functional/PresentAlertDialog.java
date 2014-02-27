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
	private String negativeButton;
	private final boolean notifyResult;
	
	public PresentAlertDialog(Context context, String title, String message,
			String positiveButton) {
		
		this(context, title, message, positiveButton, null, false);
	}
	
	public PresentAlertDialog(Context context, String title, String message,
			String positiveButton, String negativeButton) {
		
		this(context, title, message, positiveButton, negativeButton, true);
	}
	
	public PresentAlertDialog(Context context, String title, String message,
			String positiveButton, String negativeButton, boolean notifyResult) {
		
		this.context = context;
		this.title = title;
		this.message = message;
		this.positiveButton = positiveButton;
		this.negativeButton = negativeButton;
		this.notifyResult = notifyResult;
	}

	@Override
	public void run() {
		
		AlertDialog.Builder builder = new AlertDialog.Builder(context);
		builder.setTitle(title).setMessage(message).setCancelable(true);
		
		if (positiveButton != null) {
			builder.setPositiveButton(positiveButton, new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					
					if (notifyResult) {
						notifyResult(true);
					}
				}
			});
		}
		
		if (negativeButton != null) {
			builder.setNegativeButton(negativeButton, new DialogInterface.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					
					if (notifyResult) {
						notifyResult(false);
					}
				}
			});
		}
		
		builder.setOnCancelListener(new DialogInterface.OnCancelListener() {
			
			@Override
			public void onCancel(DialogInterface dialog) {
				
				if (notifyResult) {
					notifyResult(false);
				}
			}
		});
		
		final AlertDialog dialog = builder.create();
		if (dialog != null) {
			dialog.show();
		}
	}
	
	private void notifyResult(boolean positiveConfirmed) {
		
		Function_1V<Boolean> notifyOperation = new NotifyAlertDialogResult(positiveConfirmed);
		
		GLThread.getInstance().scheduleFunction(notifyOperation);
	}

}
