#ifndef ANDROIDSPRITE_H_
#define ANDROIDSPRITE_H_

#include <Framework/Sprite.hpp>
#include "AndroidLogger.h"


class AndroidSprite : public Gao::Framework::Sprite {
	
public:
	AndroidSprite();

	virtual ~AndroidSprite();

	virtual GaoBool Create(Gao::Framework::Transform* transform, 
		Gao::Framework::Texture* texture);

private:
	AndroidLogger log;
};

#endif /* ANDROIDSPRITE_H_ */