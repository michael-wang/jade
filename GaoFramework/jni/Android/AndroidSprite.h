#ifndef ANDROIDSPRITE_H_
#define ANDROIDSPRITE_H_

#include <Framework/Sprite.hpp>
#include "Java/JavaObject.h"
#include "AndroidLogger.h"


class AndroidSprite : public Gao::Framework::Sprite {
	
public:
	AndroidSprite();

	virtual ~AndroidSprite();

	virtual GaoBool Create(Gao::Framework::Transform* transform, 
		Gao::Framework::Texture* texture);

	virtual GaoVoid SetTransform(GaoInt16 coordX, GaoInt16 coordY);

	virtual GaoVoid SetTexCoords(GaoReal32 texCoordU1, GaoReal32 texCoordV1, 
		GaoReal32 texCoordU2, GaoReal32 texCoordV2);

	virtual GaoVoid SetTexCoordsU(GaoReal32 texCoordU1, GaoReal32 texCoordU2);

	virtual GaoVoid SetTexCoordsV(GaoReal32 texCoordV1, GaoReal32 texCoordV2);

	virtual GaoVoid SetRenderSizeAndTexCoords(GaoInt16 width, GaoInt16 height, 
		GaoReal32 texCoordU1, GaoReal32 texCoordV1, GaoReal32 texCoordU2, 
		GaoReal32 texCoordV2);

	virtual GaoVoid Draw();

private:
	JavaObject jobj;
	AndroidLogger log;
};

#endif /* ANDROIDSPRITE_H_ */