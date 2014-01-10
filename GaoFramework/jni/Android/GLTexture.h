#ifndef ANDROIDTEXTURE_H_
#define ANDROIDTEXTURE_H_

#include <Framework/Texture.hpp>
#include <jni.h>
#include <string>
#include "Java/JavaObject.h"
#include "AndroidLogger.h"


class GLTexture : public Gao::Framework::Texture {

public:
	GLTexture();
	virtual ~GLTexture();

	virtual GaoBool Create(GaoString& fileName);
	virtual GaoBool Reload();
	virtual GaoVoid Unload();

	GaoBool Create(GaoString& fileName, GaoBool filtered);

	jobject GetJavaRef() {
		return jobj.GetJavaRef();
	}

private:
	JavaObject jobj;
	AndroidLogger log;
};

#endif // ANDROIDTEXTURE_H_