#include "AndroidAudioRenderer.h"
#include "AndroidAudioResource.h"
#include <android/log.h>


static const char TAG[] = "native::framework::AndroidAudioRenderer";

AndroidAudioRenderer::AndroidAudioRenderer() {
}

AndroidAudioRenderer::~AndroidAudioRenderer() {
}

AudioResource* AndroidAudioRenderer::CreateAudio(AudioType type, GaoString& fileName, 
	GaoBool looping) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"CreateAudio type:%d, fileName:%s, looping:%d", type, fileName.c_str(), looping);
	
	AndroidAudioResource* audio = new AndroidAudioResource(type);

	bool success = audio->Create(type, fileName, looping);

	if (!success) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"CreateAudio failed to create audio file:%s.", fileName.c_str());
		return NULL;
	}

	return audio;
}

GaoVoid AndroidAudioRenderer::Play(AudioResource* audio) {
	audio->Play();
}

GaoVoid AndroidAudioRenderer::Stop(AudioResource* audio) {
	audio->Stop();
}

GaoVoid AndroidAudioRenderer::SetLoop(AudioResource* audio, GaoBool looping) {
	audio->SetLoop(looping);
}

GaoVoid AndroidAudioRenderer::Pause(AudioResource* audio) {
	audio->Pause();
}

GaoVoid AndroidAudioRenderer::SetVolume(AudioResource* audio, GaoReal32 volume) {
	audio->SetVolume(volume);
}