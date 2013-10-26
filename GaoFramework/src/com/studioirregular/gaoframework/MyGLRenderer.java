package com.studioirregular.gaoframework;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.content.res.AssetManager;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView.Renderer;
import android.opengl.Matrix;

public class MyGLRenderer implements Renderer {

//	private static final String TAG = "my-glrenderer";
	
	@Override
	public void onSurfaceCreated(GL10 gl, EGLConfig config) {
		GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	}
	
	@Override
	public void onSurfaceChanged(GL10 gl, int width, int height) {
		viewportWidth = width;
		viewportHeight = height;
		
		GLES20.glViewport(0, 0, width, height);
		
		Matrix.frustumM(mProjMatrix, 0, 
				-width/2, width/2, -height/2, height/2, 3, 7);
		
		RendererOnSurfaceChanged(width, height);
	}
	
	@Override
	public void onDrawFrame(GL10 gl) {
		GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT);
		
		Matrix.setLookAtM(mVMatrix, 0, 
				0, 0, -3, 
				0f, 0f, 0f, 
				0f, 1.0f, 0.0f);
		
		Matrix.multiplyMM(mMVPMatrix, 0, mProjMatrix, 0, mVMatrix, 0);
		
		RendererOnDrawFrame(JavaInterface.getInstance());
	}

	void drawRectangle(int left, int top, int right, int bottom, 
		float red, float green, float blue, float alpha, GLTexture texture) {
//		Log.d(TAG, "drawRectangle left:" + left + ",top:" + top + ",right:" + right + ",bottom:" + bottom + ",red:" + red + ",green:" + green + ",blue:" + blue + ",alpha:" + alpha);
		
		Rectangle rect = new Rectangle(left, top, right, bottom, red, green, blue, alpha);
		rect.setTexture(texture);
		rect.draw(mMVPMatrix);
	}
	
	private final float[] mMVPMatrix = new float[16];
	private final float[] mProjMatrix = new float[16];
	private final float[] mVMatrix = new float[16];
	
	private int viewportWidth, viewportHeight;
	
	private native void RendererOnSurfaceChanged(int w, int h);
	private native void RendererOnDrawFrame(JavaInterface jInterface);
}
