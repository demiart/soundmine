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
			@audioQ.stopRecording
		    @goButton.setTitle "Record"
		else
		    puts "starting"
			p "start!"
			@audioQ.startRecording
		    @goButton.setTitle "Stop"
		end
	end
	
	def testselector
	    p "testselector"
		0
	end
	
end
