package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.AbsGameActivity;
import com.studioirregular.gaoframework.NativeInterface;

public class ProcessBackKeyPressed implements Function_1V<AbsGameActivity> {

	private AbsGameActivity activity;
	
	public ProcessBackKeyPressed(AbsGameActivity activity) {
		this.activity = activity;
	}
	
	@Override
	public void run() {
		
		final boolean consumed = NativeInterface.getInstance().ProcessBackKey();
		
		if (!consumed && activity != null) {
			activity.toFinishOnUiThread();
		}
	}

}
