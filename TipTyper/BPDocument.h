//
//  BPDocument.h
//  TipTyper
//
//  Created by Bruno Philipe on 2/9/14.
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

@import Cocoa;
#import "BPDocumentWindow.h"

@class BPDocumentWindow;

@interface BPDocument : NSDocument

@property (strong) NSString *fileString;
@property (strong) BPDocumentWindow *displayWindow;

@property (getter = isLoadedFromFile) BOOL loadedFromFile;

@property (readonly) NSStringEncoding encoding;

- (void)toggleLinesCounter:(id)sender;
- (void)toggleInfoView:(id)sender;
- (void)toggleInvisibles:(id)sender;

- (IBAction)pickEncodingAndReload:(id)sender;

@end
