package com.studioirregular.gaoframework;

public interface AbsAudioResource {

	public static final int NON_STREAMING = 0;
	public static final int STREAMING = 1;
	
	public boolean Create(String path, boolean loop);
	public boolean Play();
	public void    Stop();
	public void    Pause();
	public boolean IsPlaying();
}
