package com.studioirregular.gaoframework.audio;

public interface AbsAudioResource {

	public static final int NON_STREAMING = 0;
	public static final int STREAMING = 1;
	
	public boolean Create(String path, boolean loop);
	public boolean Play();
	public void    Stop();
	public void    Pause();
	public void    Resume();
	public void    SetLoop(boolean loop);
	public void    SetVolume(float volume);
	public boolean IsPlaying();
	
	public boolean load();
}
