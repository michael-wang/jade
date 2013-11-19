#ifndef ANDROIDTEXTURE_H_
#define ANDROIDTEXTURE_H_

#include <Framework/Texture.hpp>
#include <jni.h>
#include <string>
#include "Java/JavaObject.h"


class GLTexture : public Gao::Framework::Texture {

public:
	GLTexture();
	virtual ~GLTexture();

	virtual GaoBool Create(GaoString& fileName);
	virtual GaoBool Reload();
	virtual GaoVoid Unload();

	jobject GetJavaReference() {
		return jobj.GetJavaRef();
	}

private:
	JavaObject jobj;
};

#endif // ANDROIDTEXTURE_H_