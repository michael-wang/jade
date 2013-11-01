#ifndef TOUCHEVENT_H_
#define TOUCHEVENT_H_

#include <jni.h>
#include <Framework/Array.hpp>

class TouchEvent {

public:
	TouchEvent(jobject);
	virtual ~TouchEvent();

	float GetX() {
		return x;
	}

	float GetY() {
		return y;
	}

	int GetAction() {
		return action;
	}

	GaoBool IS_ACTION_DOWN() {
		return action == 0x00;
	}

	GaoBool IS_ACTION_MOVE() {
		return action == 0x02;
	}

	GaoBool IS_ACTION_UP() {
		return action == 0x01;
	}

private:
	float x;
	float y;
	int action;
};

typedef Gao::Framework::Array<TouchEvent*,FALSE> TouchEventArray;

#endif // TOUCHEVENT_H_
