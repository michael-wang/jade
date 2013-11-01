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

public:
	static const int ACTION_DOWN = 0x00;
	static const int ACTION_MOVE = 0x02;
	static const int ACTION_UP   = 0x01;

private:
	float x;
	float y;
	int action;
};

typedef Gao::Framework::Array<TouchEvent*,FALSE> TouchEventArray;

#endif // TOUCHEVENT_H_
