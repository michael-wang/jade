#ifndef RECTANGLE_H_
#define RECTANGLE_H_

#include <Framework/Texture.hpp>
#include "Java/JavaObject.h"
#include "AndroidLogger.h"


class Rectangle {

public:
	Rectangle();
	Rectangle(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom,
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);
	virtual ~Rectangle();

	jobject GetJavaRef() {
		return jobj.GetJavaRef();
	}

	GaoVoid SetBound(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom);
	GaoVoid SetColor(GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);
	GaoVoid SetTexture(Gao::Framework::Texture* texture);

	GaoBool IsHit(GaoReal32 x, GaoReal32 y);
	GaoVoid MoveTo(GaoReal32 x, GaoReal32 y);

	GaoReal32 GetLeft() {
		return left;
	}

	GaoReal32 GetTop() {
		return top;
	}

	GaoReal32 GetRight() {
		return right;
	}

	GaoReal32 GetBottom() {
		return bottom;
	}

private:
	void init(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom,
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

private:
	JavaObject jobj;
	GaoReal32 left, top, right, bottom;
	AndroidLogger log;
};

#endif // RECTANGLE_H_
