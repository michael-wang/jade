/*
 * AndroidGraphicsRenderer.h
 *
 *  Created on: 2013/10/16
 *      Author: michael
 */

#ifndef ANDROIDGRAPHICSRENDERER_H_
#define ANDROIDGRAPHICSRENDERER_H_

#include <Framework/GraphicsRenderer.hpp>
#include <Android/GLTexture.h>
#include <Android/Rectangle.h>
#include <jni.h>

class AndroidGraphicsRenderer : public Gao::Framework::GraphicsRenderer {
public:
	AndroidGraphicsRenderer();
	virtual ~AndroidGraphicsRenderer();

	GaoVoid OnSurfaceChanged(GaoInt32 width, GaoInt32 height);

	virtual Gao::Framework::Texture* CreateTexture(GaoString& fileName);

	GaoVoid DrawRectangle(GaoInt16 startX, GaoInt16 startY, GaoInt16 endX, GaoInt16 endY, 
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha, Gao::Framework::Texture* texture);

	GaoVoid Draw(Rectangle* rect);

protected:
	GaoInt32 width, height;
	jmethodID drawRectID;
};

#endif /* ANDROIDGRAPHICSRENDERER_H_ */
