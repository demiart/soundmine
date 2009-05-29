//
//  AudioQueue.m
//  soundmine
//
//  Created by Demi on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AudioQueue.h"
#import <MTCoreAudio/MTCoreAudio.h>

@implementation AudioQueue

- (id)init
{  
	NSLog(@"Allocating audioqueue");
	if (self = [super init])
	{
		NSLog(@"SETTING INPUT");
		MTCoreAudioDevice * device = [[MTCoreAudioDevice devicesWithName:@"Built-in Input" havingStreamsForDirection:kMTCoreAudioDeviceRecordDirection] objectAtIndex:0];
		NSLog([device description]);
		inputDevice = device;
		[inputDevice retain];
		// set up the recording callback
		[inputDevice setIOTarget: self
					withSelector: @selector(readCycleForDevice:timeStamp:inputData:inputTime:outputData:outputTime:clientData:)
				  withClientData: NULL];
	}
	return self;
}

- (void)dealloc
{
	NSLog(@"Deallocating audioqueue");
	[inputDevice release];
	[super dealloc];
}

- (void)startRecording
{
    [inputDevice deviceStart];
}

- (void)stopRecording
{
    [inputDevice deviceStop];
}

- (OSStatus) readCycleForDevice: (MTCoreAudioDevice *) theDevice 
					  timeStamp: (const AudioTimeStamp *) now 
					  inputData: (const AudioBufferList *) inputData 
					  inputTime: (const AudioTimeStamp *) inputTime 
					 outputData: (AudioBufferList *) outputData 
					 outputTime: (const AudioTimeStamp *) outputTime 
					 clientData: (void *) clientData
{
	const AudioBuffer *buffer;
    buffer = &inputData->mBuffers[0];

	//for debug - testing cptuing data
	NSLog(@"Reading data %d", buffer->mDataByteSize);
	NSLog(@"Tenth byte value %d", ((unsigned char *)buffer->mData)[10]);
	
    return (noErr);
	
} // readCycleForDevice

@end
