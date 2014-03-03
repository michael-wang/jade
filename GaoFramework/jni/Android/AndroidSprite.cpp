#include "AndroidSprite.h"
#include "AndroidTransform.h"
#include "GLTexture.h"


using namespace Gao::Framework;


AndroidSprite::AndroidSprite() :
	jobj ("com/studioirregular/gaoframework/gles/Sprite", "()V"),
	log ("native::framework::AndroidSpirte", false) {
}

AndroidSprite::~AndroidSprite() {
}

GaoBool AndroidSprite::Create(Transform* transform, Texture* texture) {

	LOGD(log, "Create: transform:%p, texture:%p", transform, texture);

	if (transform == 0) {
		LOGE(log, "Create: expect transform NOT null.")
		return false;
	}

	m_Transform = transform;
	m_Texture = texture;

	AndroidTransform* at = dynamic_cast<AndroidTransform* >(transform);
	GLTexture* gtx = dynamic_cast<GLTexture* >(texture);

	if (at == 0) {
		LOGD(log, "Create: transform pointer cannot be cast to Android version.")
		return false;
	}

	jboolean result = jobj.CallBooleanMethod("Create", 
		"(Lcom/studioirregular/gaoframework/AndroidTransform;Lcom/studioirregular/gaoframework/gles/Texture;)Z",
		at->GetJavaRef(), gtx != 0 ? gtx->GetJavaRef() : 0);

	return result;
}

GaoVoid AndroidSprite::SetAlpha(GaoReal32 value) {

	LOGD(log, "SetAlpha value:%f", value)

	jobj.CallVoidMethod("SetAlpha", "(F)V", value);
}

GaoVoid AndroidSprite::SetBlendingMode(GaoInt32 mode) {

	LOGD(log, "SetBlendingMode mode:%d", mode)

	jobj.CallVoidMethod("SetBlendingMode", "(I)V", mode);
}

GaoVoid AndroidSprite::SetTransform(GaoInt16 coordX, GaoInt16 coordY) {

	LOGD(log, "SetTransform coordX:%d, coordX:%d", coordX, coordY);

	m_Transform->SetTranslate(coordX, coordY);
}

GaoVoid AndroidSprite::SetTexture(Texture* texture) {
	
	LOGD(log, "SetTexture: %p", texture)

	GLTexture* gtx = dynamic_cast<GLTexture* >(texture);

	if (gtx == 0) {
		LOGE(log, "SetTexture cannot cast texture to Android texture.")
		return;
	}

	jobj.CallVoidMethod("SetTexture", 
		"(Lcom/studioirregular/gaoframework/gles/Texture;)V", gtx->GetJavaRef());
}

GaoVoid AndroidSprite::SetTexCoords(GaoReal32 left, GaoReal32 top, 
	GaoReal32 right, GaoReal32 bottom) {
	
	LOGD(log, "SetTexCoords left:%f, top:%f, right:%f, bottom:%f", left, top, right, bottom);

	SetTexCoordsU(left, right);
	SetTexCoordsV(top, bottom);
}

GaoVoid AndroidSprite::SetTexCoordsU(GaoReal32 u1, GaoReal32 u2) {
	
	LOGD(log, "SetTexCoordsU u1:%f, u2:%f", u1, u2);

	jobj.CallVoidMethod("SetTexCoordsU", "(FF)V", u1, u2);
}

GaoVoid AndroidSprite::SetTexCoordsV(GaoReal32 top, GaoReal32 bottom) {
	
	LOGD(log, "SetTexCoordsV top:%f, bottom:%f", top, bottom);

	jobj.CallVoidMethod("SetTexCoordsV", "(FF)V", top, bottom);
}

GaoVoid AndroidSprite::SetRenderSizeAndTexCoords(GaoInt16 width, GaoInt16 height, 
	GaoReal32 left, GaoReal32 top, GaoReal32 right, GaoReal32 bottom) {
	
	LOGD(log, 
		"SetRenderSizeAndTexCoords width:%d, height:%d, left:%f, top:%f, right:%f, bottom:%f", 
		width, height, left, top, right, bottom)

	SetRenderSize(width, height);
	SetTexCoords(left, top, right, bottom);
}

GaoVoid AndroidSprite::SetRenderSizeAndRadius(GaoInt16 width, GaoInt16 height) {
	
	LOGD(log, "SetRenderSizeAndRadius w:%d, h:%d", width, height)

	// SetRenderSizeAndRadius is a special function for rotating non-square sprite.
	// Cannot apply SetRenderSize.
	//SetRenderSize(width, height);
	m_Radius[0] = 0;
	m_Radius[1] = 0;

	jobj.CallVoidMethod("SetRenderSizeAndRadius", "(II)V", width, height);
}

GaoVoid AndroidSprite::Draw() {
	
	jobj.CallVoidMethod("Draw", "()V");
}

GaoVoid AndroidSprite::DrawOffset(GaoInt16 dx, GaoInt16 dy) {
	
	jobj.CallVoidMethod("DrawOffset", "(II)V", dx, dy);
}

GaoVoid AndroidSprite::SetVertexData(GaoUInt16 index, 
	GaoReal32 x, GaoReal32 y, GaoReal32 u, GaoReal32 v) {

	LOGD(log, "SetVertexData index:%d, x:%f, y:%f, u:%f, v:%f", index, x, y, u, v)

	jobj.CallVoidMethod("SetVertexData", "(IFFFF)V", index, x, y, u, v);
}

GaoVoid AndroidSprite::SetQuadVertices(
	GaoReal32 x1, GaoReal32 y1, GaoReal32 x2, GaoReal32 y2, 
	GaoReal32 x3, GaoReal32 y3, GaoReal32 x4, GaoReal32 y4) {

	LOGD(log, "SetQuadVertices x1:%f, y1:%f, x2:%f, y2:%f, x3:%f, y3:%f, x4:%f, y4:%f", 
		x1, y1, x2, y2, x3, y3, x4, y4)

	jobj.CallVoidMethod("SetQuadVertices", "(FFFFFFFF)V", 
		x1, y1, x2, y2, x3, y3, x4, y4);
}

GaoVoid AndroidSprite::SetQuadTexCoords(
	GaoReal32 u1, GaoReal32 v1, GaoReal32 u2, GaoReal32 v2, 
	GaoReal32 u3, GaoReal32 v3, GaoReal32 u4, GaoReal32 v4) {

	LOGD(log, "SetQuadTexCoords u1:%f, v1:%f, u2:%f, v2:%f, u3:%f, v3:%f, u4:%f, v4:%f", 
		u1, v1, u2, v2, u3, v3, u4, v4)

	jobj.CallVoidMethod("SetQuadTexCoords", "(FFFFFFFF)V", 
		u1, v1, u2, v2, u3, v3, u4, v4);
}

GaoVoid AndroidSprite::SetOffset(GaoReal32 dx, GaoReal32 dy) {

	LOGD(log, "SetOffset dx:%f, dy:%f", dx, dy)

	m_Offset[0] = dx;
	m_Offset[1] = dy;

	jobj.CallVoidMethod("SetOffset", "(FF)V", dx, dy);
}

GaoVoid AndroidSprite::SetRenderSize(GaoInt16 width, GaoInt16 height) {

	LOGD(log, "SetRenderSize width:%d, dy:%d", width, height)

	m_Radius[0] = width * 0.5f;
	m_Radius[1] = height * 0.5f;

	jobj.CallVoidMethod("SetRenderSize", "(II)V", width, height);
}
