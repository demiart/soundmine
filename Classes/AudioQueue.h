//
//  AudioQueue.h
//  soundmine
//
//  Created by Demi on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MTCoreAudio/MTCoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>

@class MTCoreAudioDevice;

@interface AudioQueue : NSObject 
{
	AudioStreamBasicDescription * basicStreamDescription;
	FSRef * audioFileDirFSPathRef;
	FSRef * audioFileFSPathRef;
	AudioFileID audioFileIDHandle;
	CFStringRef audioFileName;
	AudioFileTypeID audioFileType;
	MTCoreAudioDevice *inputDevice;
}

- (void) _setUpAudioFileData: (MTCoreAudioDevice *) device;
- (void) _setUpFSRef;
- (void) _setUpCFStringRef;
- (void) _createNewAudioFile;
- (void) _setUpStreamDescription: (MTCoreAudioDevice *) device;

- (void) startRecording;
- (void) stopRecording;

@end
