package com.studioirregular.gaoframework.functional;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.studioirregular.gaoframework.PlayMovieActivity;
import com.studioirregular.gaoframework.gles.GLThread;

/*
 * Please run me by UI (main) thread.
 */
public class PlayMovie implements Function_2V<Activity, String> {

	private static final String TAG = "java-PlayMovie";
	
	private Activity activity;
	private String filename;
	
	public PlayMovie(Activity activity, String filename) {
		this.activity = activity;
		this.filename = filename;
	}
	
	@Override
	public void run() {
		
		if (activity == null || filename == null) {
			Log.e(TAG, "invalid activity:" + activity + " or filename:" + filename);
			notifyResult(false);
		}
		
		Intent playMovie = new Intent(activity, PlayMovieActivity.class);
		playMovie.putExtra(PlayMovieActivity.BUNDLE_MOVIE_FILE, filename);
		activity.startActivity(playMovie);
	}
	
	private void notifyResult(boolean success) {
		
		NotifyPlayMovieResult op = new NotifyPlayMovieResult(success);
		GLThread.getInstance().scheduleFunction(op);
	}

}
