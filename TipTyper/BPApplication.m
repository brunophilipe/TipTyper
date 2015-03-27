//
//  BPApplication.m
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

#import "BPApplication.h"
#import "DCOAboutWindowController.h"
#import "BPPreferencesWindowController.h"

NSString *const kBPDefaultFont         = @"BP_DEFAULT_FONT";
NSString *const kBPDefaultTextColor    = @"BP_DEFAULT_TXTCOLOR";
NSString *const kBPDefaultBGCOLOR      = @"BP_DEFAULT_BGCOLOR";
NSString *const kBPDefaultShowLines    = @"BP_DEFAULT_SHOWLINES";
NSString *const kBPDefaultShowStatus   = @"BP_DEFAULT_SHOWSTATUS";
NSString *const kBPDefaultInsertTabs   = @"BP_DEFAULT_INSERTTABS";
NSString *const kBPDefaultInsertSpaces = @"BP_DEFAULT_INSERTSPACES";
NSString *const kBPDefaultCountSpaces  = @"BP_DEFAULT_COUNTSPACES";
NSString *const kBPDefaultTabSize      = @"BP_DEFAULT_TABSIZE";
NSString *const kBPDefaultEditorWidth  = @"BP_DEFAULT_EDITOR_WIDTH";
NSString *const kBPDefaultShowSpecials = @"BP_DEFAULT_SHOWSPECIALS";

NSString *const kBPShouldReloadStyleNotification = @"BP_SHOULD_RELOAD_STYLE";

NSString *const kBPTipTyperWebsite = @"http://www.brunophilipe.com/software/tiptyper";

@implementation BPApplication
{
	BPPreferencesWindowController *prefWindowController;
	DCOAboutWindowController *aboutWindowController;

	NSWindow *prefWindow;
}

- (IBAction)openWebsite:(id)sender
{
	NSWorkspace *ws = [NSWorkspace sharedWorkspace];
	[ws openURL:[NSURL URLWithString:kBPTipTyperWebsite]];
}

- (IBAction)showPreferences:(id)sender
{
	if (!prefWindow)
	{
		prefWindowController = [[BPPreferencesWindowController alloc] initWithWindowNibName:@"Preferences"];
		prefWindow = prefWindowController.window;

		[prefWindow setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
	}

	[prefWindowController performSelector:@selector(showWindow:) withObject:self afterDelay:0.2];
}

#pragma mark - IBActions

- (IBAction)showAboutPanel:(id)sender {
	if (!aboutWindowController) {
		aboutWindowController = [[DCOAboutWindowController alloc] init];

        //TODO: Support for Lion
		NSTimeInterval buildDate = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"BuildDate"] doubleValue];
		NSInteger currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear
															   fromDate:[NSDate dateWithTimeIntervalSince1970:buildDate]];
		
		[aboutWindowController setAppCopyright:[NSString stringWithFormat:@"Copyright Bruno Philipe 2013-%ld – All Rights Reserved", currentYear]];
		[aboutWindowController setAppWebsiteURL:[NSURL URLWithString:kBPTipTyperWebsite]];
	}

	[aboutWindowController showWindow:sender];
}

@end
