#
#  Controller.rb
#  soundmine
#
#  Created by Demi on 5/20/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

framework 'Cocoa'
framework 'MTCoreAudio'

class GeneralController
	attr_accessor :goButton, :playButton, :mainAudioView

    def initialize
		@soundBuffer = []		
		@audioQ = AudioQueue.new
	end

	def handlePlayButtonChange(sender)
	    p "play button pressed..."
	end
	
	def handleRecordingButtonChange(sender)
		if @goButton.state == 0 then
		    puts "stopping"
			@audioQ.stopRecording
		    @goButton.setTitle "Record"
			#@playButton.enabled = true;
		else
		    puts "starting"
			p "start!"
			#@playButton.enabled = false;
			@audioQ.startRecording
		    @goButton.setTitle "Stop"
		end
	end
end
