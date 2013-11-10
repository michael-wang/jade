#ifndef ANDROIDAUDIORESOURCE_H_
#define ANDROIDAUDIORESOURCE_H_

#include <Framework/AudioResource.hpp>
#include "Java/JavaObject.h"

using namespace Gao::Framework;

class AndroidAudioResource : public AudioResource {

public:
	AndroidAudioResource(AudioType type);

	virtual ~AndroidAudioResource();

	virtual GaoBool Create(AudioType type, GaoString& fileName, GaoBool loop);

	virtual GaoVoid Play();

	virtual GaoVoid Stop();

	virtual GaoVoid Pause();

	virtual GaoVoid SetLoop(GaoBool looping);

	virtual GaoVoid SetVolume(GaoReal32 volume);

	virtual GaoBool IsPlaying() const;

private:
	static const int JMETHOD_CREATE      = 1;
	static const int JMETHOD_PLAY        = 2;
	static const int JMETHOD_PAUSE       = 3;
	static const int JMETHOD_STOP        = 4;

	JavaObject jobj;
};

#endif /* ANDROIDAUDIORESOURCE_H_ */
