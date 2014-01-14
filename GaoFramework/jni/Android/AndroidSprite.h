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

	virtual GaoVoid SetTexture(Gao::Framework::Texture* texture);

	virtual GaoVoid SetTexCoords(GaoReal32 texCoordU1, GaoReal32 texCoordV1, 
		GaoReal32 texCoordU2, GaoReal32 texCoordV2);

	virtual GaoVoid SetTexCoordsU(GaoReal32 texCoordU1, GaoReal32 texCoordU2);

	virtual GaoVoid SetTexCoordsV(GaoReal32 texCoordV1, GaoReal32 texCoordV2);

	virtual GaoVoid SetRenderSizeAndTexCoords(GaoInt16 width, GaoInt16 height, 
		GaoReal32 texCoordU1, GaoReal32 texCoordV1, GaoReal32 texCoordU2, 
		GaoReal32 texCoordV2);

	virtual GaoVoid Draw();

	virtual GaoVoid DrawOffset(GaoInt16 dx, GaoInt16 dy);

	// index: [1, 4].
	virtual GaoVoid SetVertexData(GaoUInt16 index, GaoReal32 x, GaoReal32 y, 
		GaoReal32 u, GaoReal32 v);

	virtual GaoVoid SetQuadVertices(
		GaoReal32 x1, GaoReal32 y1, GaoReal32 x2, GaoReal32 y2, 
		GaoReal32 x3, GaoReal32 y3, GaoReal32 x4, GaoReal32 y4);

	virtual GaoVoid SetQuadTexCoords(
		GaoReal32 u1, GaoReal32 v1, GaoReal32 u2, GaoReal32 v2, 
		GaoReal32 u3, GaoReal32 v3, GaoReal32 u4, GaoReal32 v4);

	virtual GaoVoid SetOffset(GaoReal32 x, GaoReal32 y);

	virtual GaoVoid SetRenderSize(GaoInt16 width, GaoInt16 height);

private:
	JavaObject jobj;
	AndroidLogger log;
};

#endif /* ANDROIDSPRITE_H_ */