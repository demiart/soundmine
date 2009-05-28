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
		#@coreAudioInputDevice = MTCoreAudioDevice.devicesWithName("Built-in Input", havingStreamsForDirection:kMTCoreAudioDeviceRecordDirection)
		
	end

	def handleRecordingButtonChange(sender)
	    #puts @coreAudioInputDevice.description
		if @goButton.state == 0 then
		    puts "stopping"
		    @goButton.setTitle "stop"
		else
		    puts "starting"
		    @goButton.setTitle "record"
		end
		
	end
end
