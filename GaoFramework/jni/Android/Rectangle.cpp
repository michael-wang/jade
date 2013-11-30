#include "Rectangle.h"
#include "GLTexture.h"


static const char JAVA_CLASS_PATH[]				= "com/studioirregular/gaoframework/Rectangle";
static const char JAVA_CONSTRUCTOR[]			= "(FFFFFFFF)V";
static const char JAVA_METHOD_SET_BOUND[]		= "setBound";
static const char JAVA_METHOD_SET_BOUND_DESC[]	= "(FFFF)V";
static const char JAVA_METHOD_SET_COLOR[]		= "setColor";
static const char JAVA_METHOD_SET_COLOR_DESC[]	= "(FFFF)V";
static const char JAVA_METHOD_SET_TEXTURE[]		= "setTexture";
static const char JAVA_METHOD_SET_TEXTURE_DESC[]= "(Lcom/studioirregular/gaoframework/GLTexture;)V";


Rectangle::Rectangle() :
	jobj (JAVA_CLASS_PATH, JAVA_CONSTRUCTOR, 0, 0, 0, 0, 0, 0, 0, 0),
	left (0),
	top (0),
	right (0),
	bottom (0),
	log ("native::framework::Rectangle", false) {
}

Rectangle::Rectangle(GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) :
	jobj (JAVA_CLASS_PATH, JAVA_CONSTRUCTOR, left, top, right, bottom, red, green, blue, alpha),
	left (left),
	top (top),
	right (right),
	bottom (bottom),
	log("native::framework::Rectangle") {
}

Rectangle::~Rectangle() {
}

GaoVoid Rectangle::SetBound(GaoReal32 l, GaoReal32 t, GaoReal32 r, GaoReal32 b) {

	left = l;
	top = t;
	right = r;
	bottom = b;

	jobj.CallVoidMethod(JAVA_METHOD_SET_BOUND, JAVA_METHOD_SET_BOUND_DESC, l, t, r, b);
}

GaoVoid Rectangle::SetColor(GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) {

	jobj.CallVoidMethod(JAVA_METHOD_SET_COLOR, JAVA_METHOD_SET_COLOR_DESC, 
		red, green, blue, alpha);
}

GaoVoid Rectangle::SetTexture(Gao::Framework::Texture* texture) {

	GLTexture* gltexture = dynamic_cast<GLTexture*>(texture);
	jobject javaGLTexture = gltexture->GetJavaRef();
	if (javaGLTexture != NULL) {
		jobj.CallVoidMethod(JAVA_METHOD_SET_TEXTURE, JAVA_METHOD_SET_TEXTURE_DESC, 
			javaGLTexture);
	} else {
		LOGE(log, "SetTexture: cannot find java reference for texture.")
	}
}

GaoBool Rectangle::IsHit(GaoReal32 x, GaoReal32 y) {

	// LOGD(log, "IsHit x:%f, y:%f, left:%f, top:%f, right:%f, bottom:%f", 
	// 	x, y, left, top, right, bottom)
	
	return (left <= x) && (x <= right) && (bottom <= y) && (y <= top);
}

GaoVoid Rectangle::MoveTo(GaoReal32 x, GaoReal32 y) {
	GaoReal32 newRight = x + right - left;
	GaoReal32 newBottom = y + bottom - top;
	SetBound(x, y, newRight, newBottom);
}
