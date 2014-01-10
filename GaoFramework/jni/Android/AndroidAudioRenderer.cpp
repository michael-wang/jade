#include "AndroidAudioRenderer.h"
#include "AndroidAudioResource.h"


AndroidAudioRenderer::AndroidAudioRenderer() :
	log ("native::framework::AndroidAudioRenderer", false) {
}

AndroidAudioRenderer::~AndroidAudioRenderer() {
}

AudioResource* AndroidAudioRenderer::CreateAudio(AudioType type, GaoString& fileName, 
	GaoBool looping) {

	LOGD(log, "CreateAudio type:%d, fileName:%s, looping:%d", 
		type, fileName.c_str(), looping)
	
	AndroidAudioResource* audio = new AndroidAudioResource(type);

	bool success = false;

	if (type == Audio_Normal) {
		GaoString path = m_NormalBasePath + fileName;
		success = audio->Create(type, path, looping);
	} else if (type == Audio_Streaming) {
		GaoString path = m_StreamingBasePath + fileName;
		success = audio->Create(type, path, looping);
	} else {
		LOGE(log, "CreateAudio: unknown audio type:%d", type)
	}

	if (!success) {
		LOGE(log, "CreateAudio failed to create audio file:%s.", fileName.c_str())
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