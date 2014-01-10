#ifndef GLYPHFONTRENDERER_H_
#define GLYPHFONTRENDERER_H_

#include "AndroidLogger.h"


class GlyphFontRenderer {
public:
	GlyphFontRenderer() :
		log ("native::framework::GlyphFontRenderer", false) {
	}
	~GlyphFontRenderer() {}

	bool Create(const char* fontDefPath, Gao::Framework::Sprite* fontSprite) {
		LOGD(log, "Create fontDefPath:%s", fontDefPath)

		return true;
	}

	void Draw(int e_iX, int e_iY, const char* e_pString) {
		LOGD(log, "Draw e_iX:%d, e_iY:%d, e_pString:%s", e_iX, e_iY, e_pString)
	}

private:
	AndroidLogger log;
};

#endif /* GLYPHFONTRENDERER_H_ */