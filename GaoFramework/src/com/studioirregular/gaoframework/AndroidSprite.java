package com.studioirregular.gaoframework;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.nio.ShortBuffer;

import android.opengl.GLES20;
import android.opengl.Matrix;
import android.util.Log;

public class AndroidSprite {

	private static final String TAG = "java-Sprite";
	private static final boolean DEBUG_LOG = false;
	
	// Assume rectangle shape.
	private static final int VERTEXT_COUNT = 4;
	private static final int COORDS_PER_VERTEX = 3;
	private static final int COORD_BYTES = 4;
	private static final int BYTES_OF_SHORT = 2;
	private static final int VERTEX_STRIDE = COORDS_PER_VERTEX * COORD_BYTES;
	private static final int DRAW_ORDER_LENGTH = 6;
	
	private static final String VERTEX_SHADER_CODE =
			"uniform mat4 uMVPMatrix;" +
			"attribute vec4 vPosition;" +
			"attribute vec2 a_TexCoordinate;" +
			"varying vec2 v_TexCoordinate;" +
			"void main() {" +
			"  v_TexCoordinate = a_TexCoordinate;" +
			"  gl_Position = vPosition * uMVPMatrix;" +
			"}";
	
	private static final String FRAGMENT_SHADER_CODE =
		    "precision mediump float;" +
		    "uniform vec4 vColor;" +
		    "varying vec2 v_TexCoordinate;" +
		    "uniform sampler2D u_Texture;" +
		    "void main() {" +
		    "  gl_FragColor = vColor + texture2D(u_Texture,v_TexCoordinate);" +
		    "}";
	
	private AndroidTransform transform;
	private GLTexture texture;
	
	private float halfWidth, halfHeight;
	private float texU1, texV1, texU2, texV2;
	
	private int shaderProgram;
	private FloatBuffer vertexBuffer;
	private ShortBuffer drawOrderBuffer;
	
	private int positionHandle;
	private int colorHandle;
	private final float[] color = new float[4];
	private int MVPMatrixHandle;
	private final float[] modelMatrix = new float[16];
	private final float[] mMVPMatrix = new float[16];
	
	public AndroidSprite() {
		
		setupVertexBuffer();
		setupDrawOrder();
		setupShaderProgram();
		
		color[0] = 0;
		color[1] = 0;
		color[2] = 0;
		color[3] = 0;
	}
	
	public boolean Create(AndroidTransform transform, GLTexture texture) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "Create: transform:" + transform + ",texture:" + texture);
		}
		
		this.transform = transform;
		this.texture = texture;
		
		return true;
	}
	
	public void SetRenderSize(int width, int height) {
		
		final float hw = width / 2;
		final float hh = height / 2;
		
		this.halfWidth = hw;
		this.halfHeight = hh;
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetRenderSize: hw:" + halfWidth + ",hh:" + halfHeight);
		}
		
		vertexBuffer.put(0, -hw).put(1,  hh).put(2, 0);
		vertexBuffer.put(3, -hw).put(4, -hh).put(5, 0);
		vertexBuffer.put(6,  hw).put(7, -hh).put(8, 0);
		vertexBuffer.put(9,  hw).put(10, hh).put(11, 0);
		
		vertexBuffer.position(0);
	}
	
	public void SetTexCoordsU(float u1, float u2) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetTexCoordU: u1: " + u1 + ",u2: " + u2);
		}
		
		texU1 = u1;
		texU2 = u2;
	}
	
	public void SetTexCoordsV(float v1, float v2) {
		
		if (DEBUG_LOG) {
			Log.d(TAG, "SetTexCoordV: v1: " + v1 + ",v2: " + v2);
		}
		
		texV1 = v1;
		texV2 = v2;
	}
	
	public void Draw() {
		if (DEBUG_LOG) {
			Log.d(TAG, "=============== Draw ==============");
			Log.d(TAG, "hw:" + halfWidth + "hh:" + halfHeight);
			Log.d(TAG, "transform:" + transform);
		}
		
		GLES20.glUseProgram(shaderProgram);
		
		positionHandle = GLES20.glGetAttribLocation(shaderProgram, "vPosition");
		
		GLES20.glEnableVertexAttribArray(positionHandle);
		
	    GLES20.glVertexAttribPointer(positionHandle, COORDS_PER_VERTEX,
                GLES20.GL_FLOAT, false,
                VERTEX_STRIDE, vertexBuffer);
	    
	    if (texture != null) {
	    	texture.draw(shaderProgram, texV1, texU1, texV2, texU2);
	    }
	    
	    colorHandle = GLES20.glGetUniformLocation(shaderProgram, "vColor");
	    GLES20.glUniform4fv(colorHandle, 1, color, 0);
	    
	    Matrix.setIdentityM(modelMatrix, 0);
	    Matrix.translateM(modelMatrix, 0, transform.GetTranslateX() + halfWidth, 
	    		transform.GetTranslateY() + halfHeight, 0);
	    Matrix.rotateM(modelMatrix, 0, transform.GetRotateByRadian(), 0, 0, 1);
	    Matrix.scaleM(modelMatrix, 0, transform.GetScale(), transform.GetScale(), 1);
	    Util.fixTranslation(modelMatrix);
	    if (DEBUG_LOG) Util.log(TAG, "model", modelMatrix, 4, 4);
	    
	    float[] mvp = JavaInterface.getInstance().getRenderer().GetMVPMatrix();
//	    if (DEBUG_LOG) Util.log(TAG, "view-projection", mvp, 4, 4);
	    
	    Matrix.multiplyMM(mMVPMatrix, 0, modelMatrix, 0, mvp, 0);
	    
	    if (DEBUG_LOG) Util.log(TAG, "MVP:", mMVPMatrix, 4, 4);
	    
	    MVPMatrixHandle = GLES20.glGetUniformLocation(shaderProgram, "uMVPMatrix");
	    GLES20.glUniformMatrix4fv(MVPMatrixHandle, 1, false, mMVPMatrix, 0);
	    
	    GLES20.glDrawElements(GLES20.GL_TRIANGLES, DRAW_ORDER_LENGTH,
	    		GLES20.GL_UNSIGNED_SHORT, drawOrderBuffer);
	    
	    GLES20.glDisableVertexAttribArray(positionHandle);
	}
	
	private void setupVertexBuffer() {
		
		ByteBuffer bb = ByteBuffer.allocateDirect(
				VERTEXT_COUNT * COORDS_PER_VERTEX * COORD_BYTES);
		bb.order(ByteOrder.nativeOrder());
		vertexBuffer = bb.asFloatBuffer();
		vertexBuffer.position(0);
	}
	
	private void setupDrawOrder() {
		
		ShortBuffer buf = ByteBuffer
				.allocateDirect(DRAW_ORDER_LENGTH * BYTES_OF_SHORT)
				.order(ByteOrder.nativeOrder())
				.asShortBuffer();
		
		buf.put(0, (short)0);
		buf.put(1, (short)1);
		buf.put(2, (short)2);
		buf.put(3, (short)0);
		buf.put(4, (short)2);
		buf.put(5, (short)3);
		buf.position(0);
		
		drawOrderBuffer = buf;
	}
	
	private void setupShaderProgram() {
		
		final int vertexShader = loadShader(
				GLES20.GL_VERTEX_SHADER, VERTEX_SHADER_CODE);
		final int fragmentShader = loadShader(
				GLES20.GL_FRAGMENT_SHADER, FRAGMENT_SHADER_CODE);
		
		if (vertexShader != 0 && fragmentShader != 0) {
			
			shaderProgram = GLES20.glCreateProgram();
			
			GLES20.glAttachShader(shaderProgram, vertexShader);
			GLES20.glAttachShader(shaderProgram, fragmentShader);
			
			GLES20.glBindAttribLocation(shaderProgram, 0, "vPosition");
			GLES20.glBindAttribLocation(shaderProgram, 1, "a_TexCoordinate");
			
			GLES20.glLinkProgram(shaderProgram);
			
			IntBuffer intBuf = IntBuffer.allocate(1);
			GLES20.glGetProgramiv(shaderProgram, GLES20.GL_LINK_STATUS, intBuf);
			
			final boolean linked = intBuf.get(0) == GLES20.GL_TRUE;
			if (!linked) {
				Log.e(TAG, "setupShaderProgram: Link failed:" + 
					GLES20.glGetProgramInfoLog(shaderProgram));
			}
		} else {
			Log.e(TAG, "setupShaderProgram: invalid shader vertexShader:" + 
				vertexShader + ",fragmentShader:" + fragmentShader);
		}
	}
	
	private static int loadShader(int type, String shaderCode){
//		if (DEBUG_LOG) {
//			Log.d(TAG, "loadShader type:" + type + ",code:" + shaderCode);
//		}

	    // create a vertex shader type (GLES20.GL_VERTEX_SHADER)
	    // or a fragment shader type (GLES20.GL_FRAGMENT_SHADER)
	    int shader = GLES20.glCreateShader(type);

	    // add the source code to the shader and compile it
	    GLES20.glShaderSource(shader, shaderCode);
	    GLES20.glCompileShader(shader);

	    IntBuffer intBuf = IntBuffer.allocate(1);
	    GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, intBuf);
	    final boolean compiled = (intBuf.get(0) == GLES20.GL_TRUE);
//	    if (DEBUG_LOG) {
//	    	Log.d(TAG, "loadShader compiled:" + compiled);
//	    }
	    
	    if (!compiled) {
	    	String info = GLES20.glGetShaderInfoLog(shader);
	    	Log.e(TAG, "loadShader compile failed:" + info);

	    	GLES20.glDeleteShader(shader);
	    	return 0;
	    }

	    return shader;
	}
}
