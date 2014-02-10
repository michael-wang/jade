package com.studioirregular.gaoframework.functional;

import android.content.Context;
import android.widget.Toast;

/*
 * Run me on UI thread, please.
 */
public class ToastMessage implements Function_2V<Context, String> {

	private Context context;
	private String msg;
	
	public ToastMessage(Context context, String msg) {
		this.context = context;
		this.msg = msg;
	}
	
	@Override
	public void run() {
		Toast.makeText(context, msg, Toast.LENGTH_LONG).show();;
	}

}
