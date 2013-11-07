package com.studioirregular.gaoframework;

public interface AbsAudioResource {

	public static enum Type {
		NonStreaming,
		Streaming
	}
	
	public boolean Create(String assetFile, boolean loop);
	public boolean Play();
	public void    Stop();
	public void    Pause();
	public boolean IsPlaying();
}
