//
//  NSColor+Luminance.m
//  TipTyper
//
//  Created by Bruno Philipe on 11/30/14.
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

#import "NSColor+Luminance.h"

@implementation NSColor (Luminance)

- (BOOL)isDarkColor
{
	NSColor *rgbSelf = [self colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
	CGFloat luminance = 0.2126*rgbSelf.redComponent + 0.7152*rgbSelf.greenComponent + 0.0722*rgbSelf.blueComponent;
	return luminance<0.5;
}

@end
