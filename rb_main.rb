$:.map! { |x| x.sub(/^\/Library\/Frameworks/, NSBundle.mainBundle.privateFrameworksPath) }
$:.unshift NSBundle.mainBundle.resourcePath.fileSystemRepresentation


#
# rb_main.rb
# soundmine
#
# Created by Demi on 5/20/09.
# Copyright __MyCompanyName__ 2009. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'
framework 'MTCoreAudio'

# Loading all the Ruby project files.
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.entries(dir_path).each do |path|
  if path != File.basename(__FILE__) and path[-3..-1] == '.rb'
    require(path)
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
