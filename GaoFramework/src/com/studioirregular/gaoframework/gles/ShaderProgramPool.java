package com.studioirregular.gaoframework.gles;

import java.util.HashMap;
import java.util.Map;


/*
 * We need this pool to hold shader programs because they need to be invalidated after 
 * GL surface changed (such as when screen rotated).
 * 
 * Assumption: one class can has one shader program.
 * Because I use class as key to index shader program. Certainly I loose the restriction 
 * by using arbitrary string as the key but this implies name collision problem.
 * 
 * TODO: generalize this class to hold any GL context session objects.
 */
public class ShaderProgramPool {

	// Singleton.
	public static ShaderProgramPool getInstance() {
		return InstanceHolder.instance;
	}
	
	private static class InstanceHolder {
		public static final ShaderProgramPool instance = new ShaderProgramPool();
	}
	
	private Map<Class<?>, ShaderProgram> pool = new HashMap<Class<?>, ShaderProgram>();
	private ShaderProgramPool() {}
	
	public void add(Class<?> key, ShaderProgram value) {
		pool.put(key, value);
	}
	
	public ShaderProgram get(Class<?> key) {
		return pool.get(key);
	}
	
	// I leave the decision about when to clean pool to user of this class.
	public void clear() {
		pool.clear();
	}
}
