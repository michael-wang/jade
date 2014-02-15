package com.studioirregular.gaoframework;

import java.util.ArrayDeque;
import java.util.Queue;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.opengl.GLES20;
import android.opengl.GLSurfaceView.Renderer;
import android.opengl.Matrix;
import android.util.Log;

import com.studioirregular.gaoframework.gles.GLThread;
import com.studioirregular.gaoframework.gles.ShaderProgramPool;
import com.studioirregular.gaoframework.gles.Shape;

public class MyGLRenderer implements Renderer {

	private static final String TAG = "java-MyGLRenderer";
	private static final boolean DEBUG_LOG = false;
	
	@Override
	public void onSurfaceCreated(GL10 gl, EGLConfig config) {
		
		if (DEBUG_LOG) {
			Log.w(TAG, "onSurfaceCreated");
		}
		
		RendererOnSurfaceCreated();
		
		GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		
		ShaderProgramPool.getInstance().clear();
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
		if (DEBUG_LOG) {
			Util.log(TAG, "after orthoM", mMVPMatrix, 4, 4);
		}
		
		GLES20.glViewport(
				Math.round(world2View.viewOffsetX), 
				Math.round(world2View.viewOffsetY),
				Math.round(world2View.viewWidth), 
				Math.round(world2View.viewHeight));
		
		GLES20.glClearColor(0, 0, 0, 1);
		
		RendererOnSurfaceChanged(surfaceWidth, surfaceHeight);
	}
	
	@Override
	public void onDrawFrame(GL10 gl) {
		
		// Some functions need to be performed in GL thread.
		// Let's do it here.
		handlePendingFunctions();
		
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
	
	void draw(Shape shape) {
		shape.draw(mMVPMatrix);
	}
	
	private void handlePendingFunctions() {
		
		GLThread.getInstance().popPendingFunctions(pendingFunctions);
		
		while (!pendingFunctions.isEmpty()) {
			Runnable op = pendingFunctions.remove();
			if (op != null) {
				op.run();
			}
		}
	}
	
	private native void RendererOnSurfaceCreated();
	private native void RendererOnSurfaceChanged(int w, int h);
	private native void RendererOnDrawFrame();
	
	private final float[] mMVPMatrix = new float[16];
	
	private FrameRateCalculator fps;
	private Queue<Runnable> pendingFunctions = new ArrayDeque<Runnable>();
}
