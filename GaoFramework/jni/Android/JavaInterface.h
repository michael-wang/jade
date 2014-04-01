#ifndef JAVAINTERFACE_H_
#define JAVAINTERFACE_H_

#include <jni.h>
#include <Framework/DataType.hpp>
#include <Framework/Singleton.hpp>
#include "Java/JavaObject.h"
#include "TouchEvent.h"
#include "AndroidLogger.h"

class JavaInterface : public Gao::Framework::Singleton<JavaInterface>  {

public:
	JavaInterface();
	virtual ~JavaInterface();

	void OnNativeInitializeDone();

	TouchEventArray* GetTouchEvents();
	char* GetLogFilePath();

	void DrawRectangle(
		GaoInt16 left, GaoInt16 top, GaoInt16 right, GaoInt16 bottom, 
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

	void DrawCircle(GaoReal32 x, GaoReal32 y, GaoReal32 radius,
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

	const char* GetString(const char* name);

	void ShowMessage(const char* title, const char* message);
	void ShowDialogWithChoices(const char* title, const char* message, const char* yes, const char* no);
	void ShowDialogWithChoices(const char* title, const char* yes, const char* no, const char* format, GaoVector<GaoString> values);

	void ToastMessage(const char* message);

	GaoBool IsFileExist(GaoConstCharPtr path);
	GaoBool RemoveFile(GaoConstCharPtr path);

	const char* GetCurrentSystemTime();

	void PlayMovie(const char* filename);

	void BuyProduct(const char* id);
	void RestorePurchases();

	void SendEmail(const char* subject, const char* recipient, const char* message);

	GaoConstCharPtr GetAppVersion();

	GaoBool IsGooglePlayGameServiceReady();
	void ShowLeaderboard(const char* id);
	void ShowAchievements();
	void SubmitAchievement(const char* id, float value, bool unlock);
	void SubmitScore(const char* id, int value);

	void SaveStateToCloud(const char* filename);
	void LoadStateFromCloud();

private:
	JavaObject jobj;
	AndroidLogger log;
};

#endif /* JAVAINTERFACE_H_ */