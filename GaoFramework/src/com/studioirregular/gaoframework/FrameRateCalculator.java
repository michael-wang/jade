package com.studioirregular.gaoframework;

import java.util.Observable;

public class FrameRateCalculator extends Observable {

	private static final long DEFAULT_NOTIFY_INTERVAL = 1000L;
	
	public FrameRateCalculator() {
		this(DEFAULT_NOTIFY_INTERVAL);
	}
	
    public FrameRateCalculator(long notifyObserverIntervalInMs) {
    	NOTIFY_OBSERVER_INTERVAL = notifyObserverIntervalInMs;
    }
    
    public void start() {
        startTime = System.currentTimeMillis();
        count = 0;
    }
    
    public void addFrame() {
    	
        count++;
        
        final long now = System.currentTimeMillis();
        final long elapsed = now - startTime;
        
        if (elapsed > NOTIFY_OBSERVER_INTERVAL) {
        	final float fps = calculateFPS(elapsed, count);
        	
        	setChanged();
            notifyObservers(fps);
            
            start();
        }
    }
    
	private float calculateFPS(long duration, long frameCount) {
        return (frameCount * 1000L / duration);
    }
    
    private final long NOTIFY_OBSERVER_INTERVAL;
    
    private long startTime;
    private long count;
}