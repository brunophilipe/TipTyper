//
//  BPPreferencesViewController.h
//  TipTyper
//
//  Created by Bruno Philipe on 11/7/14.
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

@interface BPPreferencesWindowController : NSWindowController

@property (strong) NSFont *currentFont;
@property (strong) NSColor *color_text;
@property (strong) NSColor *color_bg;

@property (strong) IBOutlet NSTextField *field_currentFont;
@property (strong) IBOutlet NSTextField *textView_example;
@property (strong) IBOutlet NSTextField *field_tabSize;
@property (strong) IBOutlet NSTextField *field_editorSize;
@property (strong) IBOutlet NSButton    *checkbox_insertTabs;
@property (strong) IBOutlet NSButton    *checkbox_insertSpaces;
@property (strong) IBOutlet NSButton    *checkbox_countSpaces;
@property (strong) IBOutlet NSButton    *checkbox_showLines;
@property (strong) IBOutlet NSButton    *checkbox_showStatus;
@property (strong) IBOutlet NSButton	*checkbox_showInvisibles;
@property (strong) IBOutlet NSStepper   *stepper_tabSize;
@property (strong) IBOutlet NSStepper   *stepper_editorSize;

- (IBAction)action_changeFont:(id)sender;
- (IBAction)action_revertDefaults:(id)sender;
- (IBAction)action_controlChanged:(id)sender;
- (IBAction)action_applyChanges:(id)sender;

@end
