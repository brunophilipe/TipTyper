//
//  BPTopBarView.m
//  TipTyper
//
//  Created by Bruno Philipe on 2/10/14.
//  Copyright (c) 2014 Bruno Philipe. All rights reserved.
//

#import "BPTopBarView.h"

@implementation BPTopBarView
{
	NSBezierPath *_path;
	CGFloat scaleFactor;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		[self setBackgroundColor:NSColorFromRGB(0xededed)];
		[self setTopBorderColor:NSColorFromRGB(0x9f9f9f)];
		scaleFactor = [self.window backingScaleFactor];
		_path = [NSBezierPath bezierPath];
		[_path setLineWidth:scaleFactor];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
	[self.topBorderColor setStroke];

	[_path removeAllPoints];
	[_path moveToPoint:NSMakePoint(0, self.bounds.size.height-(scaleFactor == 1 ? 1 : 1.5))];
	[_path lineToPoint:NSMakePoint(self.bounds.size.width, self.bounds.size.height-(scaleFactor == 1 ? 1 : 1.5))];
	[_path stroke];
}

@end
