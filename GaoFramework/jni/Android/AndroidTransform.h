#ifndef TRANSFORM_H_
#define TRANSFORM_H_

#include <Framework/Transform.hpp>
#include "Java/JavaObject.h"
#include "AndroidLogger.h"


class AndroidTransform : public Gao::Framework::Transform {
	
public:
	AndroidTransform() :
		jobj ("com/studioirregular/gaoframework/AndroidTransform", "()V"),
		log ("native::framework::Transform", false) {

		LOGD(log, "Constructor")
	}

	virtual ~AndroidTransform() {

		LOGD(log, "Destructor")
	}

	jobject GetJavaRef() {
		return jobj.GetJavaRef();
	}

	//==========================================================
	// Translation
	//==========================================================

	GaoVoid SetTranslate(GaoReal32 x, GaoReal32 y) {

		LOGD(log, "SetTranslate x:%f, y:%f", x, y)

		jobj.CallVoidMethod("SetTranslate", "(FF)V", x, y);
	}

	GaoVoid ModifyTranslate(GaoReal32 x, GaoReal32 y) {

		LOGD(log, "ModifyTranslate x:%f, y:%f", x, y)

		jobj.CallVoidMethod("ModifyTranslate", "(FF)V", x, y);
	}

	GaoVoid ModifyTranslate(Gao::Framework::Vector2D& coord) {

		LOGD(log, "ModifyTranslate x:%f, y:%f", coord.X, coord.Y)

		this->ModifyTranslate(coord.X, coord.Y);
	}

	GaoReal32 GetTranslateX() const {

		LOGD(log, "GetTranslateX")

		return jobj.CallFloatMethod("GetTranslateX", "()F");
	}

	GaoReal32 GetTranslateY() const {

		LOGD(log, "GetTranslateY")

		return jobj.CallFloatMethod("GetTranslateY", "()F");
	}

	//==========================================================
	// Rotation
	//==========================================================

	GaoVoid SetRotateByRadian(GaoReal32 radian) {

		LOGD(log, "SetRotateByRadian radian:%f", radian)

		jobj.CallVoidMethod("SetRotateByRadian", "(F)V", radian);
	}

	GaoVoid SetRotateByDegree(GaoUInt32 degree) {

		LOGD(log, "SetRotateByDegree degree:%d", degree)

		jobj.CallVoidMethod("SetRotateByDegree", "(I)V", degree);
	}

	GaoVoid ModifyRotateByRadian(GaoReal32 radian) {

		LOGD(log, "ModifyRotateByRadian radian:%f", radian)

		jobj.CallVoidMethod("ModifyRotateByRadian", "(F)V", radian);
	}

	GaoVoid ModifyRotateByDegree(GaoUInt32 degree) {

		LOGD(log, "ModifyRotateByDegree degree:%d", degree)

		jobj.CallVoidMethod("ModifyRotateByDegree", "(I)V", degree);
	}

	GaoReal32 GetRotateByRadian() const {

		LOGD(log, "GetRotateByRadian")

		return jobj.CallFloatMethod("GetRotateByRadian", "()F");
	}

	GaoReal32 GetRotateByDegree() const {

		LOGD(log, "GetRotateByDegree")

		return jobj.CallFloatMethod("GetRotateByDegree", "()F");
	}

	//==========================================================
	// Scale
	//==========================================================

	GaoVoid SetScale(GaoReal32 scale) {

		LOGD(log, "SetScale scale:%f", scale)

		jobj.CallVoidMethod("SetScale", "(F)V", scale);
	}

	GaoVoid ModifyScale(GaoReal32 scale) {

		LOGD(log, "ModifyScale scale:%f", scale)

		jobj.CallVoidMethod("ModifyScale", "(F)V", scale);
	}

	GaoReal32 GetScale() const {

		LOGD(log, "GetScale")

		return jobj.CallFloatMethod("GetScale", "()F");
	}

protected:
	JavaObject jobj;
	AndroidLogger log;
};

#endif /* TRANSFORM_H_ */