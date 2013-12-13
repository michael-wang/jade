#ifndef GLYPHFONTRENDERER_H_
#define GLYPHFONTRENDERER_H_

class GlyphFontRenderer {
public:
	GlyphFontRenderer() {}
	~GlyphFontRenderer() {}

	bool Create(const char* fontDefPath, Gao::Framework::Sprite* fontSprite) {}
	void Draw(int e_iX, int e_iY, const char* e_pString) {}
};

#endif /* GLYPHFONTRENDERER_H_ */