#ifndef RECTANGLE_H_
#define RECTANGLE_H_

#include <Android/GLTexture.h>

class Rectangle {

public:
	Rectangle();
	Rectangle(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom,
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);
	virtual ~Rectangle();

	GaoVoid SetBound(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom);
	GaoVoid SetColor(GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);
	GaoVoid SetTexture(Gao::Framework::Texture* texture);

	jobject GetJavaReference() {
		return javaRef;
	}

private:
	void init(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom,
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

private:
	jobject javaRef;
};

#endif // RECTANGLE_H_
