#ifndef ANDROIDTEXTURE_H_
#define ANDROIDTEXTURE_H_

#include <Framework/Texture.hpp>


class GLTexture : public Gao::Framework::Texture {

public:
	GLTexture();
	virtual ~GLTexture();

	virtual GaoBool Create(GaoString& fileName);
	virtual GaoBool Reload();
	virtual GaoVoid Unload();
};

#endif // ANDROIDTEXTURE_H_