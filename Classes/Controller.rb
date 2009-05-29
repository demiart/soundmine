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
		@audioQ = AudioQueue.new
	end

	def handleRecordingButtonChange(sender)
		if @goButton.state == 0 then
		    puts "stopping"
		    @goButton.setTitle "stop"
			@audioQ.stopRecording
		else
		    puts "starting"
		    @goButton.setTitle "record"
			p "start!"
			@audioQ.startRecording
		end
	end
	
	def testselector
	    p "testselector"
		0
	end
	
end
