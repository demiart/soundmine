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
		NSLog(@"SETTING INPUT");
		//MTCoreAudioDevice * device = [[MTCoreAudioDevice devicesWithName:@"Built-in Input" havingStreamsForDirection:kMTCoreAudioDeviceRecordDirection] objectAtIndex:0];
		MTCoreAudioDevice * device = [MTCoreAudioDevice defaultInputDevice];
		NSLog([device description]);
		inputDevice = device;
		[inputDevice retain];
		// set up the recording callback
		[inputDevice setIOTarget: self
					withSelector: @selector(readCycleForDevice:timeStamp:inputData:inputTime:outputData:outputTime:clientData:)
				  withClientData: NULL];
		audioFileType = kAudioFileWAVEType;
		[self _setUpAudioFileData:device];
	}
	return self;
}

-(void)_setUpAudioFileData: (MTCoreAudioDevice *) device
{
	[self _setUpStreamDescription:device];
	[self _setUpFSRef];
	[self _setUpCFStringRef];
	[self _createNewAudioFile];
}

- (void)_setUpFSRef
{
	//TODO: set path through file menu
	NSLog(@"Setting up audio file");
	char * path = "/Users/kirklandnokia";
	audioFileDirFSPathRef = (FSRef *)calloc(1, sizeof(FSRef));
	Boolean myDir;
	FSPathMakeRef((UInt8 *) path, audioFileDirFSPathRef, &myDir);
	//NSLog(@"FSRef length = %i", strlen(audioFileFSPathRef->hidden));
	NSLog(@"Done setting up audio file");
}

- (void)_setUpCFStringRef
{
	//TODO: set name through file menu
	audioFileName = CFSTR("audiofile.wav");
	//CFShowStr(audioFileName);
}

- (void)_createNewAudioFile
{
	audioFileFSPathRef = (FSRef *)calloc(1, sizeof(FSRef));
	OSStatus status = AudioFileCreate(
		audioFileDirFSPathRef,
		audioFileName,
	    audioFileType,
		basicStreamDescription,
		kAudioFileFlags_EraseFile,
		audioFileFSPathRef,
		&audioFileIDHandle);
	NSLog(@"File creation status: %i", status);
	NSLog(@"File creation status string: %s", GetMacOSStatusErrorString(status));
	NSLog(@"File creation comment: %s", GetMacOSStatusCommentString(status));
	NSLog(@"test %i", audioFileIDHandle);
	if (audioFileIDHandle == 0) NSLog(@"Warning: file already exists");
}

- (void)_clearExistingAudioFile
{
	NSLog(@"file exists - clearing file contents");
	//use existing path
	//TODO: build path - don't use constant
	char * path = "/Users/kirklandnokia/audiofile.wav";
	Boolean myDir;
	FSPathMakeRef((UInt8 *) path, audioFileFSPathRef, &myDir);
	OSStatus status = AudioFileInitialize(
		audioFileFSPathRef,
		kAudioFileWAVEType,
		basicStreamDescription,
		0,
		&audioFileIDHandle
	);
	NSLog(@"File clear status: %i", status);
	NSLog(@"File clear status string: %s", GetMacOSStatusErrorString(status));
	NSLog(@"File clear comment: %s", GetMacOSStatusCommentString(status));
	NSLog(@"test %i", audioFileIDHandle);
	if (audioFileIDHandle == 0) 
	{
		NSLog(@"Error: unable to clear file contents");
	}
	else
	{
	    fileByteOffset = 0;	
	};
}

- (void)_setUpStreamDescription: (MTCoreAudioDevice *) device
{
	basicStreamDescription = (AudioStreamBasicDescription *)calloc(1, sizeof(AudioStreamBasicDescription));
	int index;
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
}

- (void)_closeExistingAudioFile
{
	OSStatus status = AudioFileClose(audioFileIDHandle);
	
	NSLog(@"File close status: %i", status);
	NSLog(@"File close status string: %s", GetMacOSStatusErrorString(status));
	NSLog(@"File close comment: %s", GetMacOSStatusCommentString(status));
}

- (void)dealloc
{
	free(basicStreamDescription);
	free(audioFileFSPathRef);
	NSLog(@"Deallocating audioqueue");
	[inputDevice release];
	[super dealloc];
}

- (void)startRecording
{
	[self _clearExistingAudioFile];
    [inputDevice deviceStart];
}

- (void)stopRecording
{
    [inputDevice deviceStop];
	[self _closeExistingAudioFile];
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
	//NSLog(@"Reading data %d", buffer->mDataByteSize);
	//NSLog(@"Tenth byte value %d", ((unsigned char *)buffer->mData)[10]);
	
	UInt32 byteCount = buffer->mDataByteSize;
	
	//write to file
	OSStatus status = AudioFileWriteBytes(
		audioFileIDHandle,
		false,
		fileByteOffset,
		&byteCount,
		buffer->mData
	);
	
	NSLog(@"File write status: %i", status);
	NSLog(@"File write status string: %s", GetMacOSStatusErrorString(status));
	NSLog(@"File write comment: %s", GetMacOSStatusCommentString(status));
	
	if (byteCount != buffer->mDataByteSize)
	{
	    NSLog(@"Error: requested write of %i bytes failed: wrote %i", buffer->mDataByteSize, byteCount);
	}
	
	fileByteOffset += buffer->mDataByteSize;
	
    return (noErr);
	
} // readCycleForDevice

@end
