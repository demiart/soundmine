//
//  AudioView.m
//  soundmine
//
//  Created by Demi on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AudioView.h"


@implementation AudioView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    NSRect bounds = [self bounds];
	[[NSColor colorWithDeviceRed:0.1 green:0.1 blue:0.3 alpha:1.0] set];
	[NSBezierPath fillRect:bounds];
}

@end
