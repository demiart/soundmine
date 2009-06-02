//
//  AudioQueue.h
//  soundmine
//
//  Created by Demi on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MTCoreAudio/MTCoreAudio.h>

@class MTCoreAudioDevice;

@interface AudioQueue : NSObject 
{
	AudioStreamBasicDescription * basicStreamDescription;
	MTCoreAudioDevice *inputDevice;
}

- (void) startRecording;
- (void) stopRecording;

@end
