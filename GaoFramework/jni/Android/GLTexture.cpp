#include "GLTexture.h"


GLTexture::GLTexture() {
}

GLTexture::~GLTexture() {
	Unload();
}

GaoBool GLTexture::Create(GaoString& fileName) {
	return FALSE;
}

GaoBool GLTexture::Reload() {
	return FALSE;
}

GaoVoid GLTexture::Unload() {
}
