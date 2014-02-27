package com.studioirregular.gaoframework;

import java.io.IOException;
import java.io.RandomAccessFile;

import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentActivity;
import android.util.Log;

import com.google.android.gms.appstate.AppStateManager;
import com.google.android.gms.appstate.AppStateManager.StateResult;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.GamesActivityResultCodes;
import com.studioirregular.gaoframework.functional.NotifyStateLoadedFromCloud;
import com.studioirregular.gaoframework.gles.GLThread;


public class GameServices {

	private static final String TAG = "java-" + GameServices.class.getSimpleName();
	private static final boolean DEBUG_LOG = false;
	
	// Singleton.
	public static GameServices getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final GameServices instance = new GameServices();
	}
	
	private GameServices() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Constructor");
		}
	}
	
	public void onCreate(FragmentActivity activity) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "onCreate");
		}
		
		this.activity = activity;
		
		apiClient = new GoogleApiClient.Builder(activity)
			.addApi(Games.API)				// for leader board and achievements.
			.addScope(Games.SCOPE_GAMES)
			.addApi(AppStateManager.API)	// for cloud save.
			.addScope(AppStateManager.SCOPE_APP_STATE)
			.addConnectionCallbacks(googleApiConnectionCallback)
			.addOnConnectionFailedListener(googleApiConnectionFailedListener)
			.build();
	}
	
	public void onStart(int activityRequestCode, int achievementsRequestCode, int leaderboardsRequestCode) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "onStart");
		}
		
		this.connectionRequestCode = activityRequestCode;
		this.achievementsRequestCode = achievementsRequestCode;
		this.leaderboardsRequestCode = leaderboardsRequestCode;
		
		final int SERVICE_AVAILABLE_STATUS = GooglePlayServicesUtil.isGooglePlayServicesAvailable(activity);
		if (SERVICE_AVAILABLE_STATUS != ConnectionResult.SUCCESS) {
			Log.w(TAG, "Google Play service not ready, status:" + SERVICE_AVAILABLE_STATUS);
			isConnected = false;
			return;
		}
		
		if (!apiClient.isConnecting() && !apiClient.isConnected()) {
			apiClient.connect();
		}
	}
	
	public void onStop() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "onStop");
		}
		
		if (apiClient != null && apiClient.isConnected()) {
			apiClient.disconnect();
		}
		
		isConnected = false;
	}
	
	public boolean isConnected() {
		
		final boolean result = isConnected;
		
		if (DEBUG_LOG) {
			Log.d(TAG, "isConnected:" + result);
		}
		return result;
	}
	
	// Return true if consumed.
	public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "onActivityResult requestCode:" + requestCode + ",resultCode:" + resultCode + ",data:" + data);
		}
		
		if (requestCode == connectionRequestCode) {
			handleConnectionActivity(resultCode);
			return true;
			
		} else if (requestCode == achievementsRequestCode) {
			handleShowAchievements(resultCode);
			return true;
			
		} else if (requestCode == leaderboardsRequestCode) {
			handleShowLeaderboards(resultCode);
			return true;
		}
		
		return false;
	}
	
	private void handleConnectionActivity(int resultCode) {
		
		fixingError = false;
		
		if (resultCode == Activity.RESULT_OK) {
			if (!apiClient.isConnecting() && !apiClient.isConnected()) {
				apiClient.connect();
			}
		} else {
			if (DEBUG_LOG) {
				Log.w(TAG, "User canceled trying to resolve activity.");
			}
		}
	}
	
	private void handleShowAchievements(int resultCode) {
		
		if (resultCode == GamesActivityResultCodes.RESULT_RECONNECT_REQUIRED) {
			apiClient.connect();
		}
	}
	
	private void handleShowLeaderboards(int resultCode) {
		
		if (resultCode == GamesActivityResultCodes.RESULT_RECONNECT_REQUIRED) {
			apiClient.connect();
		}
	}
	
	/*
	 * Achievement API.
	 */
	public void ShowAchievements() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowAchievements");
		}
		
		Intent showAchievements = Games.Achievements.getAchievementsIntent(apiClient);
		activity.startActivityForResult(showAchievements, achievementsRequestCode);
	}
	
	/*
	 * Leaderboard API.
	 */
	public void ShowLeaderboards() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "ShowLeaderboards");
		}
		
		Intent showLeaderboards = Games.Leaderboards.getAllLeaderboardsIntent(apiClient);
		activity.startActivityForResult(showLeaderboards, leaderboardsRequestCode);
	}
	
	/*
	 * Restriction: length of state must < 256 KB.
	 */
	private final int APP_STATE_KEY = 0;	// For now one state slot is enough.
	
	public void SaveStateToCloud(String fileName) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SaveStateToCloud fileName:" + fileName);
		}
		
		if (!isConnected) {
			Log.w(TAG, "SaveStateToCloud: Google Play Game service NOT connected.");
			return;
		}
		
		final String path = AndroidFileSystem.MakeDocumentPath(fileName);
		
		byte[] data = null;
		try {
			data = readFile(path);
			
		} catch (IOException e) {
			
			Log.e(TAG, "saveStateToCloud path:" + path + "\nFailed with exception:" + e);
			if (DEBUG_LOG) {
				e.printStackTrace();
			}
			return;
		}
		
		if (data != null) {
			
			if (DEBUG_LOG) {
				Log.d(TAG, "SaveStateToCloud #data:" + data.length);
				log(data, 10);
			}
			
			AppStateManager.update(apiClient, APP_STATE_KEY, data);
		}
	}
	
	private static final String TEMP_GAME_STATE_FILE_NAME = "cloud.sav";
	
	public void LoadStateFromCloud() {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "LoadStateFromCloud");
		}
		
		if (!isConnected) {
			Log.w(TAG, "LoadStateFromCloud: Google Play Game service NOT connected.");
			return;
		}
		
		PendingResult<AppStateManager.StateResult> pending = AppStateManager.load(apiClient, APP_STATE_KEY);
		
		// Don't block, let it callback.
		pending.setResultCallback(loadGameStateCallback);
	}
	
	private ResultCallback<AppStateManager.StateResult> loadGameStateCallback = new ResultCallback<AppStateManager.StateResult> () {

		@Override
		public void onResult(StateResult result) {
			
			if (DEBUG_LOG) {
				Log.d(TAG, "loadGameStateCallback::onResult result:" + result);
			}
			
			Status status = result.getStatus();
			if (!status.isSuccess()) {
				Log.e(TAG, "load game state failed, status:" + status.getStatusCode());
				return;
			}
			
			AppStateManager.StateLoadedResult loadResult = result.getLoadedResult();
			
			byte[] data = loadResult.getLocalData();
			
			final String path = AndroidFileSystem.MakeDocumentPath(TEMP_GAME_STATE_FILE_NAME);
			if (DEBUG_LOG) {
				Log.d(TAG, "SyncFromCloudSave save state to path:" + path);
				log(data, 10);
			}
			
			try {
				writeFile(path, data);
				
			} catch (IOException e) {
				
				Log.e(TAG, "syncFromCloudSave path:" + path + "\nFailed with exception:" + e);
				
				if (DEBUG_LOG) {
					e.printStackTrace();
				}
				return;
			}
			
			GLThread.getInstance().scheduleFunction(new NotifyStateLoadedFromCloud(path));
		}
		
	};
	
	private byte[] readFile(String path) throws IOException {
		
		RandomAccessFile file = new RandomAccessFile(path, "r");
		
		byte[] result = new byte[(int) file.length()];
		file.read(result);
		
		file.close();
		return result;
	}
	
	private void writeFile(String path, byte[] data) throws IOException {
		
		RandomAccessFile file = new RandomAccessFile(path, "rwd");
		
		file.write(data);
		
		file.close();
	}
	
	private void log(byte[] data, int count) {
		
		StringBuilder msg = new StringBuilder("data:");
		for (int i = 0; i < count; i++) {
			msg.append(data[i]).append(',');
		}
		Log.d(TAG, msg.toString());
	}
	
	private GoogleApiClient.ConnectionCallbacks googleApiConnectionCallback = new GoogleApiClient.ConnectionCallbacks() {

		@Override
		public void onConnected(Bundle connectionHint) {
			
			if (DEBUG_LOG) {
				Log.d(TAG, "onConnected connectionHint:" + connectionHint);
			}
			
			isConnected = true;
		}

		@Override
		public void onConnectionSuspended(int cause) {
			
			if (DEBUG_LOG) {
				Log.d(TAG, "onConnectionSuspended cause:" + cause);
			}
			
			isConnected = false;
		}
		
	};
	
	private GoogleApiClient.OnConnectionFailedListener googleApiConnectionFailedListener = new GoogleApiClient.OnConnectionFailedListener() {

		@Override
		public void onConnectionFailed(ConnectionResult result) {
			
			if (DEBUG_LOG) {
				Log.d(TAG, "onConnectionFailed result:" + result);
			}
			
			if (fixingError) {
				Log.e(TAG, "Connection failed: already tried to resolve the error, but still failed.");
				return;
				
			} else if (result.hasResolution()) {
				fixingError = true;
				try {
					result.startResolutionForResult(activity, connectionRequestCode);
				} catch (SendIntentException e) {
					// There was an error with the resolution intent. Try again.
					apiClient.connect();
				}
			} else {
				showErrorDialog(result.getErrorCode());
			}
		}
		
	};
	
	private void showErrorDialog(int errorCode) {
		
		if (DEBUG_LOG) {
			Log.w(TAG, "showErrorDialog errorCode:" + errorCode);
		}
		
		ErrorDialogFragment dialogFragment = new ErrorDialogFragment();
		
		Bundle args = new Bundle();
		args.putInt(ErrorDialogFragment.ERROR_CODE, errorCode);
		args.putInt(ErrorDialogFragment.ACTIVITY_REQUEST_CODE, connectionRequestCode);
		dialogFragment.setArguments(args);
		dialogFragment.show(activity.getSupportFragmentManager(), "errordialog");
	}
	
	public void onErrorDialogDismiss() {
		fixingError = false;
	}
	
	public static class ErrorDialogFragment extends DialogFragment {
		
		static final String ERROR_CODE = "error_code";
		static final String ACTIVITY_REQUEST_CODE = "req_code";
		
		public ErrorDialogFragment() { }

		@Override
		public Dialog onCreateDialog(Bundle savedInstanceState) {
			
			final int errorCode = this.getArguments().getInt(ERROR_CODE);
			final int reqCode = this.getArguments().getInt(ACTIVITY_REQUEST_CODE);
			
			if (DEBUG_LOG) {
				Log.d(TAG, "ErrorDialogFragment err_code:" + errorCode);
			}
			
			return GooglePlayServicesUtil.getErrorDialog(errorCode,
					this.getActivity(), reqCode);
		}

		@Override
		public void onDismiss(DialogInterface dialog) {
			
			if (DEBUG_LOG) {
				Log.d(TAG, "ErrorDialogFragment::onDismiss");
			}
			GameServices.getInstance().onErrorDialogDismiss();
		}
		
	}
	
	private boolean isConnected = false;
	
	private GoogleApiClient apiClient;
	private boolean fixingError = false;
	
	private FragmentActivity activity;
	private int connectionRequestCode;
	private int achievementsRequestCode;
	private int leaderboardsRequestCode;
}
