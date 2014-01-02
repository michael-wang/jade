package com.studioirregular.gaoframework.gles;

import android.opengl.GLES20;
import android.util.Log;

public class GLError {

	public GLError(boolean DO_LOG) {
		this.DO_LOG = DO_LOG;
	}
	
	// Return false if no error found.
	// Return true if found error, and error code is logged.
	public boolean hasError(String LOG_TAG, String LOG_PREFIX_MESSAGE) {
		
		final int code = GLES20.glGetError();
		if (code == GLES20.GL_NO_ERROR) {
			return false;
		}
		
		if (DO_LOG) {
			Log.e(LOG_TAG, LOG_PREFIX_MESSAGE + " error code:" + code);
		}
		return true;
	}
	
	private final boolean DO_LOG;
}
