//
//  BPTopBarView.m
//  TipTyper
//
//  Created by Bruno Philipe on 2/10/14.
//  TipTyper – The simple plain-text editor for OS X.
//  Copyright (c) 2014 Bruno Philipe. All rights reserved.
//  
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
