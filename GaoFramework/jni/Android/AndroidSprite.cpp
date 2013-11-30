#include "AndroidSprite.h"
#include "AndroidTransform.h"
#include "GLTexture.h"


using namespace Gao::Framework;


AndroidSprite::AndroidSprite() :
	jobj ("com/studioirregular/gaoframework/AndroidSprite", "()V"),
	log ("native::framework::AndroidSpirte", false) {
}

AndroidSprite::~AndroidSprite() {
}

GaoBool AndroidSprite::Create(Transform* transform, Texture* texture) {

	LOGD(log, "Create: transform:%p, texture:%p", transform, texture);
	
	m_Transform = transform;
	m_Texture = texture;

	AndroidTransform* at = dynamic_cast<AndroidTransform* >(transform);
	GLTexture* gtx = dynamic_cast<GLTexture* >(texture);

	if (at == 0 || gtx == 0) {
		LOGE(log, "Create: transform or texture pointer cannot be cast to Android version.")
		return false;
	}

	jboolean result = jobj.CallBooleanMethod("Create", 
		"(Lcom/studioirregular/gaoframework/AndroidTransform;Lcom/studioirregular/gaoframework/GLTexture;)Z",
		at->GetJavaRef(), gtx->GetJavaRef());

	return result;
}

GaoVoid AndroidSprite::SetTransform(GaoInt16 coordX, GaoInt16 coordY) {

	LOGD(log, "SetTransform coordX:%d, coordX:%d", coordX, coordY);

	m_Transform->SetTranslate(coordX, coordY);
}

GaoVoid AndroidSprite::SetTexCoords(GaoReal32 u1, GaoReal32 v1, 
	GaoReal32 u2, GaoReal32 v2) {
	
	LOGD(log, "SetTexCoords u1:%f, v1:%f, u2:%f, v2:%f", u1, v1, u2, v2);

	SetTexCoordsU(u1, u2);
	SetTexCoordsV(v1, v2);
}

GaoVoid AndroidSprite::SetTexCoordsU(GaoReal32 u1, GaoReal32 u2) {
	
	LOGD(log, "SetTexCoordsU u1:%f, u2:%f", u1, u2);

	jobj.CallVoidMethod("SetTexCoordsU", "(FF)V", u1, u2);
}

GaoVoid AndroidSprite::SetTexCoordsV(GaoReal32 v1, GaoReal32 v2) {
	
	LOGD(log, "SetTexCoordsV v1:%f, v2:%f", v1, v2);

	jobj.CallVoidMethod("SetTexCoordsV", "(FF)V", v1, v2);
}

GaoVoid AndroidSprite::SetRenderSizeAndTexCoords(GaoInt16 width, GaoInt16 height, 
	GaoReal32 u1, GaoReal32 v1, GaoReal32 u2, GaoReal32 v2) {
	
	LOGD(log, 
		"SetRenderSizeAndTexCoords width:%d, height:%d, u1:%f, v1:%f, u2:%f, v2:%f", 
		width, height, u1, v1, u2, v2)

	jobj.CallVoidMethod("SetRenderSize", "(II)V", width, height);
	SetTexCoords(u1, v1, u2, v2);
}

GaoVoid AndroidSprite::Draw() {
	
	jobj.CallVoidMethod("Draw", "()V");
}
