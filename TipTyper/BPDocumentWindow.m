//
//  BPDocumentWindow.m
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

#import "BPDocumentWindow.h"
#import "Libraries/LineCounter/MarkerLineNumberView.h"
#import "Classes/NSString+WordsCount.h"
#import "NSColor+Luminance.h"
#import "BPEncodingTool.h"

@interface BPDocumentWindow ()

@property (strong) NoodleLineNumberView *lineNumberView;

@property (strong) IBOutlet NSLayoutConstraint *constraint_scrollViewLeftSpace;
@property (strong) IBOutlet NSLayoutConstraint *constraint_scrollViewRightSpace;
@property (strong) IBOutlet NSLayoutConstraint *constraint_scrollViewWidth;
@property (strong) IBOutlet NSLayoutConstraint *constraint_backgroundViewBottomSpace;

@property (getter=isDisplayingInvisibles, nonatomic) BOOL displayingInvisibles;

@end

@implementation BPDocumentWindow

- (void)construct
{
	NSParagraphStyle *paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

	self.lineNumberView = [[MarkerLineNumberView alloc] initWithScrollView:self.scrollView];

	[self.scrollView setVerticalRulerView:self.lineNumberView];
    [self.scrollView setHasHorizontalRuler:NO];
    [self.scrollView setHasVerticalRuler:YES];
    [self.scrollView setRulersVisible:YES];
	[self.scrollView setPostsBoundsChangedNotifications:YES];

	[self.textView setFont:[NSFont fontWithName:@"Monaco" size:12]];
	[self.textView setDelegate:self];
	[self.textView setAutomaticDashSubstitutionEnabled:NO];
	[self.textView setAutomaticQuoteSubstitutionEnabled:NO];
	[self.textView setDefaultParagraphStyle:paragraph];

	NSLayoutManager *layoutManager = self.textView.layoutManager;
	[layoutManager setShowsInvisibleCharacters:NO];

	[self updateLabels];

	[self.contentView setNeedsDisplay:YES];
	[self.lineNumberView setNeedsDisplay:YES];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	id aux;

	if ((aux = [defaults objectForKey:kBPDefaultShowLines]) && ![(NSNumber*)aux boolValue]) {
		[self setLinesCounterVisible:NO];
	}

	if ((aux = [defaults objectForKey:kBPDefaultShowStatus]) && ![(NSNumber*)aux boolValue]) {
		[self setInfoViewVisible:NO];
	}

	if ((aux = [defaults objectForKey:kBPDefaultShowSpecials]) && [(NSNumber*)aux boolValue]) {
		[self setDisplayingInvisibles:YES];
	}

	[self loadStyleAttributesFromDefaults];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(scrollViewDidScroll:)
												 name:NSViewBoundsDidChangeNotification
											   object:self.scrollView.contentView];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(loadStyleAttributesFromDefaults)
												 name:kBPShouldReloadStyleNotification
											   object:nil];
	
	[self updateEncodingLabel];
}

- (void)updateEncodingLabel
{
	[[self.infoView viewWithTag:4] setStringValue:[[BPEncodingTool sharedTool] nameForEncoding:self.document.encoding]];
}

- (void)scrollViewDidScroll:(NSNotification *)notif
{
	[self.scrollView setNeedsDisplay:YES];
}

- (void)setLinesCounterVisible:(BOOL)flag
{
	[self.scrollView setRulersVisible:flag];
	[self.tb_toggle_displayOptions setSelected:flag forSegment:0];
}

- (void)setInfoViewVisible:(BOOL)flag
{
	if (flag) { //Should become visible
		[self.constraint_backgroundViewBottomSpace setConstant:20.f];
	} else {
		[self.constraint_backgroundViewBottomSpace setConstant:0.f];
	}
	[(NSView*)self.contentView setNeedsDisplay:YES];
	[self.tb_toggle_displayOptions setSelected:flag forSegment:1];
}

- (void)setDisplayingInvisibles:(BOOL)displayingInvisibles
{
	_displayingInvisibles = displayingInvisibles;
	[self.tb_switch_displayInvisibles setSelected:_displayingInvisibles forSegment:0];
	[self.textView setNeedsDisplay:YES];
}

- (void)toggleLinesCounter
{
	[self setLinesCounterVisible:!self.isDisplayingLines];
}

- (void)toggleInfoView
{
	[self setInfoViewVisible:!self.isDisplayingInfo];
}

- (void)toggleInvisibles
{
	[self setDisplayingInvisibles:!self.displayingInvisibles];
}

- (BOOL)isDisplayingLines
{
	return self.scrollView.rulersVisible;
}

- (BOOL)isDisplayingInfo
{
	return [self.constraint_backgroundViewBottomSpace constant] > 0;
}

- (void)setTabWidthToNumberOfSpaces:(NSUInteger)spaces
{
	NSMutableParagraphStyle* paragraphStyle = [[self.textView defaultParagraphStyle] mutableCopy];

	if (paragraphStyle == nil) {
		paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	}

	CGFloat charWidth = [[self.textView.font screenFontWithRenderingMode:NSFontAntialiasedRenderingMode] advancementForGlyph:(NSGlyph) ' '].width;
	[paragraphStyle setDefaultTabInterval:(charWidth * spaces)];
	[paragraphStyle setTabStops:[NSArray array]];

	[self.textView setDefaultParagraphStyle:paragraphStyle];

	NSMutableDictionary* typingAttributes = [[self.textView typingAttributes] mutableCopy];
	[typingAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
//	[typingAttributes setObject:scriptFont forKey:NSFontAttributeName];
	[self.textView setTypingAttributes:typingAttributes];

	NSRange rangeOfChange = NSMakeRange(0, [[self.textView string] length]);
	[self.textView shouldChangeTextInRange:rangeOfChange replacementString:nil];
	[[self.textView textStorage] setAttributes:typingAttributes range:rangeOfChange];
	[self.textView didChangeText];
}

- (void)textDidChange:(NSNotification *)notification
{
	[self updateLabels];
}

- (void)updateLabels
{
	[[self.infoView viewWithTag:1] setStringValue:[NSString stringWithFormat:NSLocalizedString(@"BP_LABEL_WORDS", nil),[self.textView.string wordsCount]]];
	[[self.infoView viewWithTag:3] setStringValue:[NSString stringWithFormat:NSLocalizedString(@"BP_LABEL_LINES", nil),[[self.lineNumberView lineIndices] count]]];

	if ([[[NSUserDefaults standardUserDefaults] objectForKey:kBPDefaultCountSpaces] isEqualToValue:@YES]) {
		[[self.infoView viewWithTag:2] setStringValue:[NSString stringWithFormat:NSLocalizedString(@"BP_LABEL_CHARS", nil),[self.textView.string length]]];
	} else {
		[[self.infoView viewWithTag:2] setStringValue:[NSString stringWithFormat:NSLocalizedString(@"BP_LABEL_CHARS", nil),[self.textView.string charactersCount]]];
	}
}

- (void)updateTextViewContents
{
	[self.textView setString:self.document.fileString];
	[self updateLabels];

	[self.undoManager removeAllActions];
	
	if (self.document)
	{
		[self updateEncodingLabel];
	}
}

- (void)goToLine:(NSUInteger)line
{
	NSString *string = [self.textView string];
	NSRange __block range = NSMakeRange(0, 0), __block lastRange;
	NSUInteger __block curLine = 1;
	NSError *error;

	if (line > 1) {
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\n|\r|\r\n)"
																			   options:NSRegularExpressionCaseInsensitive
																				 error:&error];

		[regex enumerateMatchesInString:string
								options:0
								  range:NSMakeRange(0, string.length)
							 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
		{
			if (result.resultType == NSTextCheckingTypeRegularExpression) {
				if (curLine == line) {
					range = NSMakeRange(lastRange.location+1, result.range.location-lastRange.location);
					*stop = YES;
				}
				lastRange = result.range;
				curLine++;
			}
		}];

		if (range.location == 0 && range.length == 0)
		{
			NSAlert *alert = [NSAlert alertWithMessageText:@"Attention!"
											 defaultButton:@"OK"
										   alternateButton:nil
											   otherButton:nil
								 informativeTextWithFormat:@"There is no such line!"];
			
			[alert setAlertStyle:NSWarningAlertStyle];
			[alert.window setTitle:@"TipTyper"];
			[alert runModal];
			return;
		}
	}
	else
	{
		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\n|\r)"
																			   options:NSRegularExpressionCaseInsensitive error:&error];
		range = NSMakeRange(0, [regex rangeOfFirstMatchInString:string
														options:0
														  range:NSMakeRange(0, string.length)].location+1);
	}

	[self.textView setSelectedRange:range];
	[self.textView scrollRangeToVisible:range];
}

- (void)increaseIndentation:(id)sender
{
	[self.textView increaseIndentation];
}

- (void)decreaseIndentation:(id)sender
{
	[self.textView decreaseIndentation];
}

- (void)loadTabSettingsFromDefaults
{
	[self.undoManager disableUndoRegistration];

	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];

	id aux;

	if ((aux = [defaults objectForKey:kBPDefaultInsertTabs])) {
		[self.textView setShouldInsertTabsOnLineBreak:[aux boolValue]];
	} else {
		[self.textView setShouldInsertTabsOnLineBreak:YES];
	}

	if ((aux = [defaults objectForKey:kBPDefaultInsertSpaces])) {
		[self.textView setShouldInsertSpacesInsteadOfTabs:[aux boolValue]];
	}

	if ((aux = [defaults objectForKey:kBPDefaultTabSize])) {
		[self.textView setTabSize:[aux unsignedIntegerValue]];
		[self setTabWidthToNumberOfSpaces:[aux unsignedIntegerValue]];
	} else {
		[self.textView setTabSize:4];
		[self setTabWidthToNumberOfSpaces:4];
	}
#ifdef DEBUG
	NSLog(@"Loaded tab settings from defaults");
#endif

	[self.undoManager enableUndoRegistration];
}

- (void)loadStyleAttributesFromDefaults
{
	[self.undoManager disableUndoRegistration];

	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	NSFont			*font = kBP_TIPTYPER_FONT;

	id aux;

	if ((aux = [defaults objectForKey:kBPDefaultFont])) {
		font = [NSKeyedUnarchiver unarchiveObjectWithData:aux];
	}
	[self.textView setFont:font];

	if ((aux = [defaults objectForKey:kBPDefaultBackgroundColor])) {
		NSColor *bg = [NSKeyedUnarchiver unarchiveObjectWithData:aux];
		[self.textView setBackgroundColor:bg];
		[self.textView setInsertionPointColor:([bg isDarkColor] ? [NSColor lightGrayColor] : [NSColor blackColor])];
	} else {
		[self.textView setBackgroundColor:kBP_TIPTYPER_BGCOLOR];
		[self.textView setInsertionPointColor:kBP_TIPTYPER_TXTCOLOR];
	}

	if ((aux = [defaults objectForKey:kBPDefaultTextColor])) {
		[self.textView setTextColor:[NSKeyedUnarchiver unarchiveObjectWithData:aux]];
	} else {
		[self.textView setTextColor:kBP_TIPTYPER_TXTCOLOR];
	}

	if ([self isEditorSetToNarrow]) {
		[self updateEditorWidthToNarrow:YES];
	}

	[self loadTabSettingsFromDefaults];

#ifdef DEBUG
	NSLog(@"Loaded style from defaults");
#endif

	[self.undoManager enableUndoRegistration];
}

- (void)updateEditorWidthToNarrow:(BOOL)narrow
{
    if (narrow)
    {
        [self.constraint_scrollViewLeftSpace setPriority:NSLayoutPriorityDefaultHigh];
        [self.constraint_scrollViewRightSpace setPriority:NSLayoutPriorityDefaultHigh];
        [self.constraint_scrollViewWidth setPriority:NSLayoutPriorityDefaultLow];
    }
    else
    {
        CGFloat width = [[NSUserDefaults standardUserDefaults] floatForKey:kBPDefaultEditorWidth];
        if (width < 400) width = 450.f;
        [self.constraint_scrollViewWidth setConstant:width];
        [self.constraint_scrollViewLeftSpace setPriority:NSLayoutPriorityDefaultLow];
        [self.constraint_scrollViewRightSpace setPriority:NSLayoutPriorityDefaultLow];
        [self.constraint_scrollViewWidth setPriority:NSLayoutPriorityDefaultHigh];
        [self setLinesCounterVisible:NO];
    }
}

- (BOOL)isEditorSetToNarrow
{
	return [self.constraint_scrollViewWidth priority] == NSLayoutPriorityDefaultHigh;
}

#pragma mark - IBActions

- (IBAction)action_switch_textAlignment:(id)sender {
	NSSegmentedControl *toggle = sender;
	switch (toggle.selectedSegment) {
		case 0: //Align left
			[self.textView alignLeft:sender];
			break;

		case 1: //Align center
			[self.textView alignCenter:sender];
			break;

		case 2: //Align right
			[self.textView alignRight:sender];
			break;

		default:
			break;
	}
}

- (IBAction)action_switch_editorSpacing:(id)sender {
	NSSegmentedControl *toggle = sender;
	[self updateEditorWidthToNarrow:(toggle.selectedSegment == 1)];
}

- (IBAction)action_switch_indentation:(id)sender {
	NSSegmentedControl *toggler = sender;

	switch (toggler.selectedSegment) {
		case 0:
			[self.textView decreaseIndentation];
			break;

		case 1:
			[self.textView increaseIndentation];
			break;

		default:
			break;
	}
}

- (IBAction)action_toggle_displayOptions:(id)sender {
	NSSegmentedControl *toggler = sender;

	switch (toggler.selectedSegment) {
		case 0: //Toggle lines counter
			[self toggleLinesCounter];
			break;

		case 1: //Toggle info display
			[self toggleInfoView];
			break;

		default:
			break;
	}
}

- (IBAction)action_switch_displayInvisibles:(id)sender {
	[self toggleInvisibles];
}

- (IBAction)action_showJumpToLineDialog:(id)sender {
	NSAlert		*alert;
	NSTextField *field;
	
	alert = [NSAlert alertWithMessageText:NSLocalizedString(@"BP_MESSAGE_GOTOLINE", nil) defaultButton:NSLocalizedString(@"BP_MESSAGE_GO", nil) alternateButton:NSLocalizedString(@"BP_GENERIC_CANCEL", nil) otherButton:nil informativeTextWithFormat:@""];
	field = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 22)];
	[alert setAccessoryView:field];
	[alert setAlertStyle:NSInformationalAlertStyle];
	
	void (^completion)(NSInteger returnCode) = ^(NSInteger returnCode) {
		if (returnCode == 1) {
			[self goToLine:MAX(1, (NSUInteger)field.integerValue)];
		}
	};
	
	if ([alert respondsToSelector:@selector(beginSheetModalForWindow:completionHandler:)])
	{
		[alert beginSheetModalForWindow:self completionHandler:completion];
	}
	else
	{
		completion([alert runModal]);
	}
}

- (IBAction)action_switch_changeFontSize:(id)sender {
	NSSegmentedControl *toggle = sender;

	switch (toggle.selectedSegment) {
		case 0: //Reduce font size
			if (self.textView.font.pointSize > 7) {
				toggle.tag = 4;
				[[NSFontManager sharedFontManager] modifyFont:sender];
			}
			break;

		case 1: //Normal font size
			[self loadStyleAttributesFromDefaults];
			break;

		case 2: //Increase font size
			toggle.tag = 3;
			[[NSFontManager sharedFontManager] modifyFont:sender];
			break;

		default:
			break;
	}

	[self loadTabSettingsFromDefaults];
}

- (IBAction)updateFontSizeWithTaggedSender:(id)sender
{
	NSMenuItem *item = sender;
	static NSControl *dummy;

	if (!dummy) {
		dummy = [[NSControl alloc] init];
	}

	switch (item.tag) {
		case 3: //Reduce font size
			if (self.textView.font.pointSize > 7) {
				dummy.tag = 4;
				[[NSFontManager sharedFontManager] modifyFont:dummy];
			}
			break;

		case 2: //Normal font size
			[self loadStyleAttributesFromDefaults];
			break;

		case 1: //Increase font size
			dummy.tag = 3;
			[[NSFontManager sharedFontManager] modifyFont:dummy];
			break;

		default:
			break;
	}

	[self loadTabSettingsFromDefaults];
}

#pragma mark - Text Field Delegate

- (NSMenu *)textView:(NSTextView *)view menu:(NSMenu *)menu forEvent:(NSEvent *)event atIndex:(NSUInteger)charIndex {
	NSUInteger i=0;
	for (NSMenuItem *item in menu.itemArray) {
		if ([item.title isEqualToString:@"Font"]) {
			[menu removeItemAtIndex:i];
			break;
		}
		i++;
	}
	return menu;
}

@end
