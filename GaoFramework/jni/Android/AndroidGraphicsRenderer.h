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
#include "AndroidLogger.h"
#include <jni.h>

class AndroidGraphicsRenderer : public Gao::Framework::GraphicsRenderer {
public:
	AndroidGraphicsRenderer();
	virtual ~AndroidGraphicsRenderer();

	GaoVoid OnSurfaceChanged(GaoInt32 width, GaoInt32 height);

	virtual Gao::Framework::Transform* CreateTransform();

    /**
     * Texture APIs.
     */
	virtual Gao::Framework::Texture* CreateTexture(GaoString& fileName);

	virtual Gao::Framework::Texture* CreateFilteredTexture(GaoString& fileName);

	virtual Gao::Framework::Texture* CreateSpecialTexture(GaoInt32 width, GaoInt32 height);

	virtual GaoBool IsSpecialTextureValid() const;

	virtual GaoBool ReloadTexture(Gao::Framework::Texture* texture);

	virtual GaoVoid UnloadTexture(Gao::Framework::Texture* texture);

    /**
     * Sprite APIs.
     */
	virtual Gao::Framework::Sprite* CreateSprite(Gao::Framework::Transform* transform, 
		Gao::Framework::Texture* texture);

    /**
     * Drawing APIs.
     */
	virtual GaoVoid DrawRectangle(GaoInt16 startX, GaoInt16 startY, GaoInt16 endX, GaoInt16 endY, 
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

	virtual GaoVoid DrawCircle(GaoInt16 centerX, GaoInt16 centerY, GaoInt16 radius, 
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

protected:
	Gao::Framework::Texture*  _createTexture(GaoString& fileName, GaoBool filtered);

protected:
	AndroidLogger log;
	GaoInt32 width, height;
	jmethodID drawRectID;
};

#endif /* ANDROIDGRAPHICSRENDERER_H_ */
