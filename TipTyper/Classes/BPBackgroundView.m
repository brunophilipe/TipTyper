//
//  BPView.m
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

#import "BPBackgroundView.h"

@implementation BPBackgroundView

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	if (self) {
		[self setBackgroundColor:[NSColor whiteColor]];
		[self setNeedsDisplay:YES];
	}
	return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[self.backgroundColor setFill];
	NSRectFill(self.bounds);
}

@end
