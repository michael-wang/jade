package com.studioirregular.gaoframework;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.opengl.GLES20;
import android.opengl.GLSurfaceView.Renderer;
import android.opengl.Matrix;
import android.util.Log;

import com.studioirregular.gaoframework.gles.Circle;

public class MyGLRenderer implements Renderer {

	private static final String TAG = "my-glrenderer";
	private static final boolean DEBUG_LOG = false;
	
	@Override
	public void onSurfaceCreated(GL10 gl, EGLConfig config) {
		GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	}
	
	@Override
	public void onSurfaceChanged(GL10 gl, int surfaceWidth, int surfaceHeight) {
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onSurfaceChanged surfaceWidth:" + surfaceWidth
					+ ",surfaceHeight:" + surfaceHeight);
		}
		
		Global.initWorld2ViewMapping(surfaceWidth, surfaceHeight);
		Global.World2ViewMapping world2View = Global.getWorld2ViewMapping();
		
		Matrix.orthoM(mMVPMatrix, 0, 
				0, world2View.worldWidth, world2View.worldHeight, 0, 1, -1);
		Util.log(TAG, "after orthoM", mMVPMatrix, 4, 4);
		
		GLES20.glViewport(
				Math.round(world2View.viewOffsetX), 
				Math.round(world2View.viewOffsetY),
				Math.round(world2View.viewWidth), 
				Math.round(world2View.viewHeight));
		
		GLES20.glClearColor(1, 0, 0, 1);
		
		RendererOnSurfaceChanged(surfaceWidth, surfaceHeight, 
				JavaInterface.getInstance().GetAssetFileFolder());
	}
	
	@Override
	public void onDrawFrame(GL10 gl) {
		GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT);
		
		GLES20.glEnable(GLES20.GL_BLEND);
		GLES20.glBlendFunc(GLES20.GL_SRC_ALPHA, GLES20.GL_ONE_MINUS_SRC_ALPHA);
		
		RendererOnDrawFrame();
		
		GLES20.glDisable(GLES20.GL_BLEND);
		
		if (fps != null) {
			fps.addFrame();
		}
	}
	
	public float[] GetMVPMatrix() {
		return mMVPMatrix;
	}
	
	void calculateFrameRate(FrameRateCalculator fps) {
		this.fps = fps;
		fps.start();
	}

	void draw(Rectangle rect) {
		rect.draw(mMVPMatrix);
	}
	
	void draw(Circle circle) {
		circle.draw(mMVPMatrix);
	}
	
	private native void RendererOnSurfaceChanged(int w, int h, String assetFolder);
	private native void RendererOnDrawFrame();
	
	private final float[] mMVPMatrix = new float[16];
	
	private FrameRateCalculator fps;
}
