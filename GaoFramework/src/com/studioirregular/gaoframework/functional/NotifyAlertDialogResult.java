package com.studioirregular.gaoframework.functional;

import com.studioirregular.gaoframework.NativeInterface;

public class NotifyAlertDialogResult implements Function_1V<Boolean> {

	private Boolean positiveConfirmed;
	
	/**
	 * @param arg: TRUE if user click positive button, FALSE for other cases.
	 */
	public NotifyAlertDialogResult(Boolean arg) {
		positiveConfirmed = arg;
	}

	@Override
	public void run() {
		
		NativeInterface.getInstance().NotifyAlertDialogResult(positiveConfirmed);
	}

	@Override
	public String toString() {
		return super.toString() + ", positiveConfirmed:" + positiveConfirmed;
	}

}
