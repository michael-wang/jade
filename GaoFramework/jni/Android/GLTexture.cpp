#include "GLTexture.h"

GLTexture::currentTextureId = 0;

GLTexture::GLTexture() :
	m_Width (0),
	m_Height (0),
	textureId (0),
	pixels (NULL) {
}

GLTexture::~GLTexture() {
	Unload();
}

GaoBool GLTexture::Create(GaoString& fileName) {
}

GaoBool GLTexture::Reload() {
}

GaoVoid GLTexture::Unload() {
}

GaoVoid GLTexture::Bind() {
}
