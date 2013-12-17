package com.studioirregular.gaoframework;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.opengl.GLES20;
import android.opengl.GLSurfaceView.Renderer;
import android.opengl.Matrix;
import android.util.Log;

public class MyGLRenderer implements Renderer {

	private static final String TAG = "my-glrenderer";
	private static final boolean DEBUG_LOG = false;
	
	@Override
	public void onSurfaceCreated(GL10 gl, EGLConfig config) {
		GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	}
	
	@Override
	public void onSurfaceChanged(GL10 gl, int width, int height) {
		viewportWidth = width;
		viewportHeight = height;
		
		GLES20.glViewport(0, 0, width, height);
		
		Matrix.orthoM(mMVPMatrix, 0, 
				0, width, height, 0, 1, -1);
		Util.fixTranslation(mMVPMatrix);
//		Util.log(TAG, "mProjMatrix", mProjMatrix, 4, 4);
		
		RendererOnSurfaceChanged(width, height, 
				JavaInterface.getInstance().GetAssetFileFolder());
	}
	
	@Override
	public void onDrawFrame(GL10 gl) {
		GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT);
		
		RendererOnDrawFrame();
		
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

	void drawRectangle(int left, int top, int right, int bottom, 
		float red, float green, float blue, float alpha, GLTexture texture) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "drawRectangle left:" + left + ",top:" + top + 
					",right:" + right + ",bottom:" + bottom + ",red:" + red + 
					",green:" + green + ",blue:" + blue + ",alpha:" + alpha);
		}
		
		Rectangle rect = new Rectangle(left, top, right, bottom, red, green, blue, alpha);
		rect.setTexture(texture);
		rect.draw(mMVPMatrix);
	}
	
	void draw(Rectangle rect) {
		rect.draw(mMVPMatrix);
	}
	
	private native void RendererOnSurfaceChanged(int w, int h, String assetFolder);
	private native void RendererOnDrawFrame();
	
	private final float[] mMVPMatrix = new float[16];
	private final float[] mProjMatrix = new float[16];
	private final float[] mVMatrix = new float[16];
	
	private int viewportWidth, viewportHeight;
	private FrameRateCalculator fps;
}
