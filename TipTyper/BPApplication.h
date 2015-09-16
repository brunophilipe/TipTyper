//
//  BPApplication.h
//  TipTyper
//
//  Created by Bruno Philipe on 10/14/13.
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

@import Cocoa;
#import "BPDocument.h"

extern NSString *const kBPDefaultFont;
extern NSString *const kBPDefaultTextColor;
extern NSString *const kBPDefaultBackgroundColor;
extern NSString *const kBPDefaultShowLines;
extern NSString *const kBPDefaultShowStatus;
extern NSString *const kBPDefaultInsertTabs;
extern NSString *const kBPDefaultInsertSpaces;
extern NSString *const kBPDefaultCountSpaces;
extern NSString *const kBPDefaultTabSize;
extern NSString *const kBPDefaultEditorWidth;
extern NSString *const kBPDefaultShowSpecials;

extern NSString *const kBPShouldReloadStyleNotification;

extern NSString *const kBPTipTyperWebsite;

@class BPDocument;

@interface BPApplication : NSApplication

/**
 * Returns YES if the key window has a document associated with it.
 * Used in Cocoa Bindings.
 */
- (BOOL)hasLoadedDocumentInKeyWindow;

#pragma mark - IBActions

/**
 * Checks for updates with Sparkle. (If built for Mac App Store, does nothing).
 */
- (IBAction)checkForUpdate:(id)sender;

/**
 * Sends a message to the shared application manager to open the app's website using the default browser.
 */
- (IBAction)openWebsite:(id)sender;

/**
 *  Opens (and creates if necessary) the preferences window.
 */
- (IBAction)showPreferences:(id)sender;

/**
 *  Opens the About panel.
 */
- (IBAction)showAboutPanel:(id)sender;

@end
