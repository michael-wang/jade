#include "AndroidSprite.h"


using namespace Gao::Framework;


AndroidSprite::AndroidSprite() :
	log ("native::framework::AndroidSpirte", true) {
}

AndroidSprite::~AndroidSprite() {
}

GaoBool AndroidSprite::Create(Transform* transform, Texture* texture) {

	LOGD(log, "Create transform:%p, texture:%p", transform, texture);
	
	m_Transform = transform;
	m_Texture = texture;

	return true;
}