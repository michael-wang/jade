/*
 * AndroidGraphicsRenderer.h
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#ifndef ANDROIDGRAPHICSRENDERER_H_
#define ANDROIDGRAPHICSRENDERER_H_

#include <Framework/GraphicsRenderer.hpp>
#include <Framework/Sprite.hpp>
#include <Framework/Transform.hpp>
#include <Android/GLTexture.h>
#include <Android/Rectangle.h>
#include "AndroidLogger.h"
#include <jni.h>

class AndroidGraphicsRenderer : public Gao::Framework::GraphicsRenderer {
public:
	AndroidGraphicsRenderer();
	virtual ~AndroidGraphicsRenderer();

	GaoVoid OnSurfaceChanged(GaoInt32 width, GaoInt32 height);

	virtual Gao::Framework::Transform* CreateTransform();

	virtual Gao::Framework::Texture* CreateTexture(GaoString& fileName);

	virtual Gao::Framework::Sprite* CreateSprite(Gao::Framework::Transform* transform, 
		Gao::Framework::Texture* texture);

	GaoVoid Draw(Rectangle* rect);

	virtual GaoVoid DrawRectangle(GaoInt16 startX, GaoInt16 startY, GaoInt16 endX, GaoInt16 endY, 
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

protected:
	AndroidLogger log;
	GaoInt32 width, height;
	jmethodID drawRectID;
};

#endif /* ANDROIDGRAPHICSRENDERER_H_ */
