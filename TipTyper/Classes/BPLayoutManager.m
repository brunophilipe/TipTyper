//
//  BPLayoutManager.m
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

#import "BPLayoutManager.h"
#import "NSColor+Luminance.h"

typedef enum {
	BPHiddenGlypthNewLine,
	BPHiddenGlypthSpace,
	BPHiddenGlypthTab
} BPHiddenGlypth;

@implementation BPLayoutManager

+ (NSString*)stringForHiddenGlypth:(BPHiddenGlypth)glypth
{
	NSString __block *CRLF, *SPACE, *TAB;

	@synchronized(self)
	{
		if (!CRLF)
		{
			CRLF	= @"↩︎";
			SPACE	= @"⎵";
			TAB		= @"⇥";
		}

		switch (glypth) {
			case BPHiddenGlypthNewLine:
				return CRLF;

			case BPHiddenGlypthSpace:
				return SPACE;

			case BPHiddenGlypthTab:
				return TAB;
		}
	}
}

+ (NSFont*)cachedInvisibleGlyphFontWithSize:(CGFloat)size
{
	NSFont *font;
	CGFloat lastSize = -1.0;
	@synchronized(self)
	{
		if (!font || lastSize != size) {
			font = [NSFont fontWithName:@"Inconsolata" size:size];
			if (!font)
			{
				font = [NSFont fontWithName:@"Helvetica" size:size];
			}
			lastSize = size;
		}
	}
	return font;
}

- (void)drawGlyphsForGlyphRange:(NSRange)glyphRange atPoint:(NSPoint)origin
{
	BPDocumentWindow *window = (BPDocumentWindow*)self.textViewForBeginningOfSelection.window;

	if (window.isDisplayingInvisibles) {
		NSString *docContents = [self.textStorage string];
		CGFloat userFontSize = [self.textStorage font].pointSize;
		CGFloat pointScale = [[NSApp mainWindow] backingScaleFactor];
		NSString *glyph = nil;
		NSPoint glyphPoint;
		NSRect glyphRect;
		NSDictionary *attr = @{NSForegroundColorAttributeName: [self.textViewForBeginningOfSelection.backgroundColor isDarkColor] ? [NSColor grayColor] : [NSColor lightGrayColor], NSFontAttributeName: [BPLayoutManager cachedInvisibleGlyphFontWithSize:userFontSize*0.8]};

		//loop thru current range, drawing glyphs
		for (NSUInteger i = glyphRange.location; i < NSMaxRange(glyphRange); i++)
		{
			//look for special chars
			switch ([docContents characterAtIndex:i])
			{
					//eol
				case 0x2028:
				case 0x2029:
				case '\n':
				case '\r':
					glyph = [BPLayoutManager stringForHiddenGlypth:BPHiddenGlypthNewLine];
					break;
					
					//space
				case ' ':
					glyph = [BPLayoutManager stringForHiddenGlypth:BPHiddenGlypthSpace];
					break;

					//tab
				case '\t':
					glyph = [BPLayoutManager stringForHiddenGlypth:BPHiddenGlypthTab];
					break;

					//do nothing
				default:
					glyph = nil;
					break;
			}

			//should we draw?
			if (glyph)
			{
				glyphPoint = [self locationForGlyphAtIndex:i];
				glyphRect = [self lineFragmentRectForGlyphAtIndex:i effectiveRange:NULL];
				glyphPoint.x += glyphRect.origin.x - 0.5 * pointScale;
				glyphPoint.y = glyphRect.origin.y + 2 * pointScale;
				[glyph drawAtPoint:glyphPoint withAttributes:attr];
			}
		}
	}

	[super drawGlyphsForGlyphRange:glyphRange atPoint:origin];
}

@end
