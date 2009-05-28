#
#  Controller.rb
#  soundmine
#
#  Created by Demi on 5/20/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class Controller
	attr_accessor :goButton, :mainAudioView

    def initialize
		@soundBuffer = []		
		@coreAudioInputDevice = MTCoreAudioDevice.devicesWithName("Built-in Input", havingStreamsForDirection:1)[0] #1 is record direction
	    #puts @coreAudioInputDevice.description
		#puts @coreAudioInputDevice.methods(true, true)
		@coreAudioInputDevice.setIOTarget(self, withSelector:'testselector:', withClientData:nil)
	end

	def handleRecordingButtonChange(sender)
		if @goButton.state == 0 then
		    puts "stopping"
		    @goButton.setTitle "stop"
			@coreAudioInputDevice.deviceStop
		else
		    puts "starting"
		    @goButton.setTitle "record"
			@coreAudioInputDevice.deviceStart
			p "start!"
		end
		
	end
	
	def testselector
	    p "testselector"
		0
	end
	
	def readCycleForDevice(theDevice, timeStamp, inputData, inputTime, outputData, outputTime, clientData)
	    p "test"
		buffer = inputData.mBuffers
		0 #return noErr
	end
end
