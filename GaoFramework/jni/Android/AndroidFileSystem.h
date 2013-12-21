#ifndef ANDROIDFILESYSTEM_H_
#define ANDROIDFILESYSTEM_H_

#include <Framework/DataType.hpp>


class AndroidFileSystem {
	
public:
	AndroidFileSystem();

	~AndroidFileSystem();

	/*
	 * The only usage of this function is Logger::Create, which expect fileName be 
	 *  appended to a path which developer can easily access, such as public SD card
	 *  folders.
	 */
	static GaoVoid MakeFullPath(GaoString& fileName);

	/*
	 * This function is found in EaglFileSystem and IOManager.lua, and it looks like
	 *  to append application private folder path followed by fileName.
	 */
	static GaoConstCharPtr MakeDocumentPath(GaoConstCharPtr fileName);
};

#endif /* ANDROIDFILESYSTEM_H_ */