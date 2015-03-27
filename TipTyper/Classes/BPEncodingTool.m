//
//  EncodingTool.m
//  TipTyper
//
//  Created by Bruno Philipe on 4/29/13.
//  TipTyper – The simple plain-text editor for OS X.
//  Copyright (c) 2013 Bruno Philipe. All rights reserved.
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

#import "BPEncodingTool.h"

@implementation BPEncodingTool
{
	NSDictionary *encodings;
}

+ (BPEncodingTool *)sharedTool
{
    static dispatch_once_t once;
    static BPEncodingTool *__singleton__;
    dispatch_once(&once, ^ { __singleton__ = [[BPEncodingTool alloc] init]; });
    return __singleton__;
}

- (id)init
{
	self = [super init];
	
	NSStringEncoding rawEncodings[] = {NSUTF8StringEncoding,NSASCIIStringEncoding,NSISOLatin1StringEncoding,NSISOLatin2StringEncoding,NSMacOSRomanStringEncoding,NSWindowsCP1251StringEncoding,NSWindowsCP1252StringEncoding,NSWindowsCP1253StringEncoding,NSWindowsCP1254StringEncoding,NSWindowsCP1250StringEncoding,NSUTF16StringEncoding,NSUTF16BigEndianStringEncoding,NSUTF16LittleEndianStringEncoding,NSUTF32StringEncoding,NSUTF32BigEndianStringEncoding,NSUTF32LittleEndianStringEncoding,NSNEXTSTEPStringEncoding,NSSymbolStringEncoding,NSISO2022JPStringEncoding,NSJapaneseEUCStringEncoding,NSNonLossyASCIIStringEncoding,NSShiftJISStringEncoding};
	NSString *rawNames[] = {@"UTF-8",@"ASCII",@"ISO Latin-1",@"ISO Latin-2",@"Mac OS Roman",@"Windows-1251",@"Windows-1252",@"Windows-1253",@"Windows-1254",@"Windows-1250",@"UTF-16",@"UTF-16 BE",@"UTF-16 LE",@"UTF-32",@"UTF-32 BE",@"UTF-32 LE",@"NeXT",@"Symbol",@"ISO-2022 JP",@"Japanese EUC",@"Lossy ASCII",@"Shift JIS"};

	NSMutableDictionary *dEncodings = [[NSMutableDictionary alloc] initWithCapacity:22];

	for (short i=0; i<22; i++) {
		[dEncodings setObject:rawNames[i] forKey:[NSNumber numberWithUnsignedInteger:rawEncodings[i]]];
	}

	encodings = [dEncodings copy];

	return self;
}

- (NSString *)nameForEncoding:(NSStringEncoding)encoding
{
	return [encodings objectForKey:[NSNumber numberWithInteger:encoding]];
}

- (NSArray *)getAllEncodings
{
	NSArray *encs = [encodings allValues];
	encs = [encs sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	return encs;
}

- (NSStringEncoding)encodingForEncodingName:(NSString *)name
{
	for (NSNumber *enc in [encodings allKeys]) {
		if ([name isEqualToString:[encodings objectForKey:enc]]) {
			return [enc unsignedIntegerValue];
		}
	}

	return 0;
}

+ (NSString*)loadStringWithPathAskingForEncoding:(NSURL*)fileURL usedEncoding:(NSStringEncoding*)usedEncoding
{
	if (fileURL)
	{
		NSInteger result = 1;
		
		NSString *curEncodingName = [[BPEncodingTool sharedTool] nameForEncoding:NSUTF8StringEncoding];
		
		NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"BP_MESSAGE_PICKENCODING", nil)
										 defaultButton:NSLocalizedString(@"BP_GENERIC_OK", nil)
									   alternateButton:NSLocalizedString(@"BP_GENERIC_CANCEL", nil)
										   otherButton:nil
							 informativeTextWithFormat:NSLocalizedString(@"BP_MESSAGE_ENCODING", nil)];
		
		[alert.window setTitle:NSLocalizedString(@"BP_MESSAGE_AUTOENCODING", nil)];
		
		NSPopUpButton __strong *button = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 160, 40) pullsDown:YES];
		
		[button addItemsWithTitles:[[BPEncodingTool sharedTool] getAllEncodings]];
		[button selectItemWithTitle:curEncodingName];
		[button setTitle:curEncodingName];
		[button setTarget:self];
		[button setAction:@selector(menuEncodingChanged:)];
		
		[alert setAccessoryView:button];
		
		do
		{
			result = [alert runModal];
			
			if (result == 1)
			{
				NSStringEncoding encoding = [[BPEncodingTool sharedTool] encodingForEncodingName:button.selectedItem.title];
				NSString *inputString = nil;
				NSError *error;
				
				inputString = [[NSString alloc] initWithContentsOfURL:fileURL encoding:encoding error:&error];
				
				if (error)
				{
					NSAlert *errorAlert = [NSAlert alertWithError:error];
					[errorAlert runModal];
				}
				
				if (inputString)
				{
					if (usedEncoding != NULL)
					{
						*usedEncoding = encoding;
					}
					
					return inputString;
				}
			}
		}
		while (result == 1);
	}
	else
	{
		[[NSAlert alertWithMessageText:NSLocalizedString(@"BP_ERROR_ENCODING_NOFILE", nil)
						 defaultButton:NSLocalizedString(@"BP_GENERIC_OK", nil)
					   alternateButton:NSLocalizedString(@"BP_GENERIC_CANCEL", nil)
						   otherButton:nil
			 informativeTextWithFormat:@""] runModal];
	}
	
	return nil;
}

- (void)menuEncodingChanged:(id)sender
{
	NSPopUpButton *button = sender;
	[button setTitle:[button selectedItem].title];
}

@end
