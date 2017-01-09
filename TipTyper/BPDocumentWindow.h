//
//  BPDocumentWindow.h
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
#import "BPDocument.h"
#import "BPBackgroundView.h"
#import "BPTextView.h"

@class BPDocument;
@class BPTextView;

@interface BPDocumentWindow : NSWindow <NSTextViewDelegate, NSTouchBarDelegate>

@property (assign) BPDocument *document;

- (void)construct;
- (void)updateTextViewContents;

- (void)toggleLinesCounter;
- (void)toggleInfoView;
- (void)toggleInvisibles;

- (BOOL)isDisplayingLines;
- (BOOL)isDisplayingInfo;
- (BOOL)isDisplayingInvisibles;

- (void)updateFontSizeWithTaggedSender:(id)sender;

- (void)increaseIndentation:(id)sender;
- (void)decreaseIndentation:(id)sender;

- (void)updateEncodingLabel;

- (NSArray<NSTouchBarItemIdentifier>*)defaultTouchBarIdentifiers;

#pragma mark - IBOutlets

@property (strong) IBOutlet BPBackgroundView	*wrapView;
@property (strong) IBOutlet NSScrollView		*scrollView;
@property (strong) IBOutlet BPTextView			*textView;
@property (strong) IBOutlet NSView				*infoView;
@property (strong) IBOutlet NSSegmentedControl	*textAlignmentSegmentedControl;
@property (strong) IBOutlet NSSegmentedControl	*editorSpacingSegmentedControl;
@property (strong) IBOutlet NSSegmentedControl	*displayInvisiblesSegmentedControl;
@property (strong) IBOutlet NSSegmentedControl	*changeIndentationSegmentedControl;
@property (strong) IBOutlet NSSegmentedControl	*displayOptionsSegmentedControl;
@property (strong) IBOutlet NSButton			*goToLineButton;
@property (strong) IBOutlet NSToolbarItem		*editToolbarToolbarItem;

#pragma mark - IBActions

- (IBAction)action_switch_textAlignment:(id)sender;
- (IBAction)action_switch_editorSpacing:(id)sender;
- (IBAction)action_switch_indentation:(id)sender;
- (IBAction)action_toggle_displayOptions:(id)sender;
- (IBAction)action_switch_displayInvisibles:(id)sender;
- (IBAction)action_showJumpToLineDialog:(id)sender;
- (IBAction)action_switch_changeFontSize:(id)sender;

@end
