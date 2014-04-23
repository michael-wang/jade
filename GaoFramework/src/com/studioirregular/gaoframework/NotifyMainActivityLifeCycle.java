package com.studioirregular.gaoframework;

import android.util.Log;

import com.studioirregular.gaoframework.NotifyMainActivityLifeCycle.LifeCycleEvent;
import com.studioirregular.gaoframework.functional.Operation_1V;

public class NotifyMainActivityLifeCycle extends Operation_1V<LifeCycleEvent> {
	
	private static final String TAG = "java-NotifyMainActivityLifeCycle";
	
	public static enum LifeCycleEvent {
		ON_START,
		ON_STOP,
		ON_RESUME,
		ON_PAUSE,
	}
	
	public NotifyMainActivityLifeCycle(LifeCycleEvent event) {
		super(event);
	}

	@Override
	public void run() {
		
		AbsGameActivity activity = JavaInterface.getInstance().getMainActivity();
		
		if (activity == null) {
			Log.e(TAG, "run: main activity from JavaInterface is null.");
		}
		
		final LifeCycleEvent event = arg1;
		
		if (event == LifeCycleEvent.ON_START) {
			activity.ActivityOnStart();
		} else if (event == LifeCycleEvent.ON_STOP) {
			activity.ActivityOnStop();
		} else if (event == LifeCycleEvent.ON_RESUME) {
			activity.ActivityOnResume();
		} else if (event == LifeCycleEvent.ON_PAUSE) {
			activity.ActivityOnPause();
		} else {
			Log.e(TAG, "Unknown life cycle event:" + event);
		}
	};

}
