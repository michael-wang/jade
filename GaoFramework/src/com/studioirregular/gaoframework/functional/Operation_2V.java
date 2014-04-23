package com.studioirregular.gaoframework.functional;

public abstract class Operation_2V<A1, A2> extends Operation_1V<A1> {

	protected A2 arg2;
	
	public Operation_2V(A1 arg1, A2 arg2) {
		super(arg1);
		
		this.arg2 = arg2;
	}

}
