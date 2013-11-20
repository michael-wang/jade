#ifndef ANDROIDAUDIORENDERER_H_
#define ANDROIDAUDIORENDERER_H_

#include <Framework/DataType.hpp>
#include <Framework/AudioDefine.hpp>
#include <Framework/AudioRenderer.hpp>
#include <Framework/AudioResource.hpp>
#include "AndroidLogger.h"

using namespace Gao::Framework;

class AndroidAudioRenderer : public AudioRenderer {

public:
	AndroidAudioRenderer();
	
	virtual ~AndroidAudioRenderer();

	virtual AudioResource* CreateAudio(AudioType type, GaoString& fileName, GaoBool looping);

	virtual GaoVoid Play(AudioResource* audio);

	virtual GaoVoid Stop(AudioResource* audio);

	virtual GaoVoid SetLoop(AudioResource* audio, GaoBool looping);

	virtual GaoVoid Pause(AudioResource* audio);

	virtual GaoVoid SetVolume(AudioResource* audio, GaoReal32 volume);

private:
	AndroidLogger log;
};

#endif /* ANDROIDAUDIORENDERER_H_ */