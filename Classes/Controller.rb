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
	    @isRecording = false
	end

	def handleRecordingButtonChange(sender)
	    @isRecording = !@isRecording
		puts "is recording = #{@isRecording}" #logs to console
		#puts goButton.methods(true, true)
		if @isRecording then
		    @goButton.setTitle "stop"
		else
		    @goButton.setTitle "record"
		end
		
	end
end
