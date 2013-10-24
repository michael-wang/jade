#ifndef ANDROIDTEXTURE_H_
#define ANDROIDTEXTURE_H_

#include <Framework/Texture.hpp>
#include <OpenGLES/ES1/gl.h>

class GLTexture : public Texture {

public:
	GLTexture();
	virtual ~GLTexture();

	virtual GaoBool Create(GaoString& fileName);
	virtual GaoBool Reload();
	virtual GaoVoid Unload();
	
	GaoVoid Bind();

protected:
	static GLuint   currentTextureId;

	GLuint          textureId;
	GLvoid*         pixels;
};

#endif // ANDROIDTEXTURE_H_
