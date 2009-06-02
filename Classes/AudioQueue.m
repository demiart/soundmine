//
//  AudioQueue.m
//  soundmine
//
//  Created by Demi on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AudioQueue.h"
#import <MTCoreAudio/MTCoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioQueue

- (id)init
{  
	NSLog(@"Allocating audioqueue");
	if (self = [super init])
	{
		int index;
		basicStreamDescription = (AudioStreamBasicDescription *)calloc(1, sizeof(AudioStreamBasicDescription));
		NSLog(@"SETTING INPUT");
		//MTCoreAudioDevice * device = [[MTCoreAudioDevice devicesWithName:@"Built-in Input" havingStreamsForDirection:kMTCoreAudioDeviceRecordDirection] objectAtIndex:0];
		MTCoreAudioDevice * device = [MTCoreAudioDevice defaultInputDevice];
		NSLog([device description]);
		uint32 channels = [device channelsForDirection:kMTCoreAudioDeviceRecordDirection];
		NSLog(@"device channels: %i", channels);
		NSArray * perStreamDescriptions = [device streamsForDirection:kMTCoreAudioDeviceRecordDirection];
		if (nil != perStreamDescriptions)
		{
			MTCoreAudioStream * stream = [perStreamDescriptions objectAtIndex:0];
			MTCoreAudioStreamDescription * streamDesc = [stream streamDescriptionForSide:kMTCoreAudioStreamLogicalSide];
			NSLog(@"Record direction stream %i description: %s", index, [[streamDesc description] UTF8String]);
			NSLog(@"Record direction stream sample rate: %f", [streamDesc sampleRate]);
			uint32 format = [streamDesc formatID];
			NSLog(@"Record direction stream format ID: %c%c%c%c", format >> 24, ((format >> 16) & 0xFF), ((format >> 8) & 0xFF), format & 0xFF);
		    NSLog(@"Record direction stream format flags: %i", [streamDesc formatFlags]); //defined in CoreAudioTypes.h
			NSLog(@"Record direction stream bytes per packet: %i", [streamDesc bytesPerPacket]);
			NSLog(@"Record direction stream frames per packet: %i", [streamDesc framesPerPacket]);
			NSLog(@"Record direction stream bytes per frame: %i", [streamDesc bytesPerFrame]);
			NSLog(@"Record direction stream channels per frame: %i", [streamDesc channelsPerFrame]);
			NSLog(@"Record direction stream bits per channel: %i", [streamDesc bitsPerChannel]);
			char * interleaved = [streamDesc isInterleaved] == TRUE ? "true" : "false"; 
			NSLog(@"Record direction stream is interleaved: %s", interleaved);
			basicStreamDescription->mSampleRate = [streamDesc sampleRate];
			basicStreamDescription->mFormatID = [streamDesc formatID];
			basicStreamDescription->mFormatFlags = [streamDesc formatFlags];
			basicStreamDescription->mBytesPerPacket = [streamDesc bytesPerPacket];
			basicStreamDescription->mFramesPerPacket = [streamDesc framesPerPacket];
			basicStreamDescription->mBytesPerFrame = [streamDesc bytesPerFrame];
			basicStreamDescription->mChannelsPerFrame = [streamDesc channelsPerFrame];
			basicStreamDescription->mBitsPerChannel = [streamDesc bitsPerChannel];
		}
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
	free(basicStreamDescription);
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
