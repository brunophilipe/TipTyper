//
//  BPPreferencesViewController.m
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

#import "BPPreferencesWindowController.h"

typedef NS_ENUM(NSUInteger, BP_DEFAULT_TYPES) {
    BP_Defaults_Font				= (1<<1),
    BP_Defaults_TxtColor			= (1<<2),
    BP_Defaults_BgColor				= (1<<3),
    BP_Defaults_ShowLines			= (1<<4),
    BP_Defaults_ShowStatus			= (1<<5),
    BP_Defaults_InsertTabs			= (1<<6),
    BP_Defaults_TabSize				= (1<<7),
    BP_Defaults_InsertSpaces		= (1<<8),
    BP_Defaults_CountSpaces			= (1<<9),
    BP_Defaults_EditorWidth			= (1<<10),
	BP_Defaults_ShowSpecials		= (1<<11),
    BP_Defaults_None				= 0
};

@interface BPPreferencesWindowController ()

@property BP_DEFAULT_TYPES changedAttributes;

@property (strong) NSFont *currentFont;
@property (strong) NSColor *color_text;
@property (strong) NSColor *color_bg;

@property (strong) IBOutlet NSPopover	*popover;
@property (strong) IBOutlet NSTextField	*field_currentFont;
@property (strong) IBOutlet NSTextField	*textView_example;
@property (strong) IBOutlet NSTextField	*field_tabSize;
@property (strong) IBOutlet NSTextField	*field_editorSize;
@property (strong) IBOutlet NSButton	*checkbox_insertTabs;
@property (strong) IBOutlet NSButton	*checkbox_insertSpaces;
@property (strong) IBOutlet NSButton	*checkbox_countSpaces;
@property (strong) IBOutlet NSButton	*checkbox_showLines;
@property (strong) IBOutlet NSButton	*checkbox_showStatus;
@property (strong) IBOutlet NSButton	*checkbox_showInvisibles;
@property (strong) IBOutlet NSButton	*checkbox_rememberWindowSize;
@property (strong) IBOutlet NSStepper	*stepper_tabSize;
@property (strong) IBOutlet NSStepper	*stepper_editorSize;

@end

@implementation BPPreferencesWindowController

- (void)windowDidLoad
{
	[self configurePreferencesWindow];
}

- (void)configurePreferencesWindow
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	id aux;

	if ((aux = [defaults objectForKey:kBPDefaultBackgroundColor]))
		[self setColor_bg:[NSKeyedUnarchiver unarchiveObjectWithData:aux]];
	else
		[self setColor_bg:kBP_TIPTYPER_BGCOLOR];

	if ((aux = [defaults objectForKey:kBPDefaultTextColor]))
		[self setColor_text:[NSKeyedUnarchiver unarchiveObjectWithData:aux]];
	else
		[self setColor_text:kBP_TIPTYPER_TXTCOLOR];

	if ((aux = [defaults objectForKey:kBPDefaultFont]))
		[self setCustomFont:[NSKeyedUnarchiver unarchiveObjectWithData:aux]];
	else
		[self setCustomFont:kBP_TIPTYPER_FONT];

	if ((aux = [defaults objectForKey:kBPDefaultShowLines]))
		[self.checkbox_showLines setState:NSStateForNSNumber(aux)];
	else
		[self.checkbox_showLines setState:NSOnState];

	if ((aux = [defaults objectForKey:kBPDefaultShowStatus]))
		[self.checkbox_showStatus setState:NSStateForNSNumber(aux)];
	else
		[self.checkbox_showStatus setState:NSOnState];

	if ((aux = [defaults objectForKey:kBPDefaultShowSpecials]))
		[self.checkbox_showInvisibles setState:NSStateForNSNumber(aux)];
	else
		[self.checkbox_showInvisibles setState:NSOffState];

	if ((aux = [defaults objectForKey:kBPDefaultInsertTabs]))
		[self.checkbox_insertTabs setState:NSStateForNSNumber(aux)];
	else
		[self.checkbox_insertTabs setState:NSOnState];

	if ((aux = [defaults objectForKey:kBPDefaultInsertSpaces]))
		[self.checkbox_insertSpaces setState:NSStateForNSNumber(aux)];
	else
		[self.checkbox_insertSpaces setState:NSOffState];

	if ((aux = [defaults objectForKey:kBPDefaultCountSpaces]))
		[self.checkbox_countSpaces setState:NSStateForNSNumber(aux)];
	else
		[self.checkbox_countSpaces setState:NSOffState];

	if ((aux = [defaults objectForKey:kBPDefaultTabSize]))
	{
		[self.field_tabSize setIntegerValue:[aux integerValue]];
		[self.stepper_tabSize setIntegerValue:[aux integerValue]];
	}
	else
	{
		[self.field_tabSize setIntegerValue:4];
		[self.stepper_tabSize setIntegerValue:4];
	}

	if ((aux = [defaults objectForKey:kBPDefaultEditorWidth]))
	{
		[self.field_editorSize setIntegerValue:[aux integerValue]];
		[self.stepper_editorSize setIntegerValue:[aux integerValue]];
	}
	else
	{
		[self.field_editorSize setIntegerValue:450];
		[self.stepper_editorSize setIntegerValue:450];
	}

	[self.textView_example setTextColor:self.color_text];
	[self.textView_example setBackgroundColor:self.color_bg];

	[[self.window.contentView viewWithTag:-3] performSelector:@selector(setColor:) withObject:self.color_text];
	[[self.window.contentView viewWithTag:-4] performSelector:@selector(setColor:) withObject:self.color_bg];
}

- (void)changeFont:(id)sender
{
	NSFontManager *fm = sender;

	[self setCustomFont:[fm convertFont:self.currentFont]];

	self.changedAttributes |= BP_Defaults_Font;
}

- (void)setCustomFont:(NSFont *)font
{
	self.currentFont = font;

	[self.field_currentFont setFont:[NSFont fontWithName:self.currentFont.fontName size:12]];
	[self.field_currentFont setStringValue:[NSString stringWithFormat:@"%@ %.0fpt", self.currentFont.displayName, self.currentFont.pointSize]];

	[self.textView_example setFont:self.currentFont];
}

#pragma mark - Actions

- (IBAction)action_changeFont:(id)sender
{
	[[NSFontManager sharedFontManager] setDelegate:self];

	NSFontPanel *panel = [NSFontPanel sharedFontPanel];
	[panel makeKeyAndOrderFront:self];
}

- (IBAction)action_revertDefaults:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[defaults removeObjectForKey:kBPDefaultBackgroundColor];
	[defaults removeObjectForKey:kBPDefaultTextColor];
	[defaults removeObjectForKey:kBPDefaultFont];
	[defaults removeObjectForKey:kBPDefaultShowStatus];
	[defaults removeObjectForKey:kBPDefaultShowLines];
	[defaults removeObjectForKey:kBPDefaultInsertTabs];
	[defaults removeObjectForKey:kBPDefaultInsertSpaces];
	[defaults removeObjectForKey:kBPDefaultCountSpaces];
	[defaults removeObjectForKey:kBPDefaultTabSize];
	[defaults removeObjectForKey:kBPDefaultEditorWidth];
	[defaults removeObjectForKey:kBPDefaultShowSpecials];

	[defaults synchronize];

	self.changedAttributes = BP_Defaults_None;

	[self configurePreferencesWindow];

	[[NSNotificationCenter defaultCenter] postNotificationName:kBPShouldReloadStyleNotification object:self];
}

- (IBAction)action_controlChanged:(id)sender
{
	switch ([(NSControl *)sender tag]) {
		case -1: //Show lines
			self.changedAttributes |= BP_Defaults_ShowLines;
			break;

		case -2: //Show status
			self.changedAttributes |= BP_Defaults_ShowStatus;
			break;

		case -3: //Font color
			self.color_text = [(NSColorWell *)sender color];
			[self.textView_example setTextColor:self.color_text];
			self.changedAttributes |= BP_Defaults_TxtColor;
			break;

		case -4: //BG color
			self.color_bg = [(NSColorWell *)sender color];
			[self.textView_example setBackgroundColor:self.color_bg];
			self.changedAttributes |= BP_Defaults_BgColor;
			break;

		case -5: //Insert tabs
			self.changedAttributes |= BP_Defaults_InsertTabs;
			break;

		case -6: //Tab size stepper
			[self.field_tabSize setIntegerValue:[sender integerValue]];
			self.changedAttributes |= BP_Defaults_TabSize;
			break;

		case -7: //Insert spaces
			self.changedAttributes |= BP_Defaults_InsertSpaces;
			break;

		case -8: //Count spaces as chars
			self.changedAttributes |= BP_Defaults_CountSpaces;
			break;

		case -9: //Fixed editor width stepper
			[self.field_editorSize setIntegerValue:[sender integerValue]];
			self.changedAttributes |= BP_Defaults_EditorWidth;
			break;

		case -10: //Count spaces as chars
			self.changedAttributes |= BP_Defaults_ShowSpecials;
			break;

        default:
            break;
	}
}

- (IBAction)action_applyChanges:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	if (self.changedAttributes & BP_Defaults_Font)
	{
		[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.currentFont]
					 forKey:kBPDefaultFont];
	}
	if (self.changedAttributes & BP_Defaults_BgColor)
	{
		[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.color_bg]
					 forKey:kBPDefaultBackgroundColor];
	}
	if (self.changedAttributes & BP_Defaults_TxtColor)
	{
		[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.color_text]
					 forKey:kBPDefaultTextColor];
	}
	if (self.changedAttributes & BP_Defaults_ShowLines)
	{
		[defaults setObject:[NSNumber numberWithBool:([self.checkbox_showLines state] == NSOnState)]
					 forKey:kBPDefaultShowLines];
	}
	if (self.changedAttributes & BP_Defaults_ShowStatus)
	{
		[defaults setObject:[NSNumber numberWithBool:([self.checkbox_showStatus state] == NSOnState)]
					 forKey:kBPDefaultShowStatus];
	}
	if (self.changedAttributes & BP_Defaults_InsertTabs)
	{
		[defaults setObject:[NSNumber numberWithBool:([self.checkbox_insertTabs state] == NSOnState)]
					 forKey:kBPDefaultInsertTabs];
	}
	if (self.changedAttributes & BP_Defaults_InsertSpaces)
	{
		[defaults setObject:[NSNumber numberWithBool:([self.checkbox_insertSpaces state] == NSOnState)]
					 forKey:kBPDefaultInsertSpaces];
	}
	if (self.changedAttributes & BP_Defaults_CountSpaces)
	{
		[defaults setObject:[NSNumber numberWithBool:([self.checkbox_countSpaces state] == NSOnState)]
					 forKey:kBPDefaultCountSpaces];
	}
	if (self.changedAttributes & BP_Defaults_TabSize)
	{
		[defaults setObject:[NSNumber numberWithInteger:[self.field_tabSize integerValue]]
					 forKey:kBPDefaultTabSize];
	}
	if (self.changedAttributes & BP_Defaults_EditorWidth)
	{
		[defaults setObject:[NSNumber numberWithInteger:[self.field_editorSize integerValue]]
					 forKey:kBPDefaultEditorWidth];
	}
	if (self.changedAttributes & BP_Defaults_ShowSpecials)
	{
		[defaults setObject:[NSNumber numberWithBool:([self.checkbox_showInvisibles state] == NSOnState)]
					 forKey:kBPDefaultShowSpecials];
	}

	self.changedAttributes = BP_Defaults_None;

	[defaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:kBPShouldReloadStyleNotification object:self];
}

- (IBAction)showHelpPopover:(NSControl*)sender {
	if (!self.popover.isShown)
	{
		[self.popover showRelativeToRect:sender.frame ofView:self.window.contentView preferredEdge:NSMaxXEdge];
	}
	else
	{
		[self.popover performClose:sender];
	}
}

@end
