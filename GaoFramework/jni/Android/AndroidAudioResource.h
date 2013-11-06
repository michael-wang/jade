#ifndef ANDROIDAUDIORESOURCE_H_
#define ANDROIDAUDIORESOURCE_H_

#include <Framework/AudioResource.hpp>
#include <jni.h>

using namespace Gao::Framework;

class AndroidAudioResource : public AudioResource {

public:
	AndroidAudioResource();

	virtual ~AndroidAudioResource();

	virtual GaoBool Create(AudioType type, GaoString& fileName, GaoBool loop);

	virtual GaoVoid Play();

	virtual GaoVoid Stop();

	virtual GaoVoid Pause();

	virtual GaoVoid SetLoop(GaoBool looping);

	virtual GaoVoid SetVolume(GaoReal32 volume);

	virtual GaoBool IsPlaying() const;

private:
	jobject javaRef;
};

#endif /* ANDROIDAUDIORESOURCE_H_ */
