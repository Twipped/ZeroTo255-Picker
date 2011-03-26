//
//  ZeroTo255.m
//  ZeroTo255
//
//  Created by Jarvis Badgley on 3/23/11.
//  Copyright 2011 ChiperSoft Systems. All rights reserved.
//

#import "ZeroTo255.h"

#import "HSLColor.h"

#define UseColorCalibration false

@implementation ZeroTo255

- (id)init
{
    self = [super init];
    if (self) {

        //colorsList = [[[NSMutableArray alloc] init] retain];

    
    
    }
    
    return self;
}

- (void)dealloc
{
    [currColor release];
    [colorsList release];
    
    [super dealloc];
}

#pragma mark Color exchanges

- (void)colorChanged:(id)sender {

    //NSLog(@"color changed: %@", sender);

    
}

- (void)setColor:(NSColor *)color {

    [currColor release];
	currColor = [color retain];

	NSColor *colorInCorrectColorSpace = [color colorUsingColorSpaceName:(UseColorCalibration ? NSCalibratedRGBColorSpace : NSDeviceRGBColorSpace )];
    NSColor *shade;
    
	NSString *str = @"?";
    
    HSLColor *hsl;
    
    NSMutableArray *clist;
    
    double l;
    int startIndex;

	if (nil != colorInCorrectColorSpace) { 
		color = colorInCorrectColorSpace; 
        
		str = [self hexForColor:color];
        [hexField setStringValue:str];
    
        hsl = [[[HSLColor alloc] initFromColor:color] autorelease];

        //NSLog(@"h:%f s:%f l:%f", [hsl hue], [hsl saturation], [hsl lightness]);
        
        clist = [[[NSMutableArray alloc] init] autorelease]; //create a color list
        [clist addObject:[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1]]; //add black first.
        
        l = [hsl lightness];
        
        startIndex = floor(l / .03) + 1 ;  //find which element in the array should contain our base color;
        
        l = l - ( floor(l/0.03) * 0.03);   //find the lowest lightness
        
        while (l < 1) {                    //add each shade to the array, incrementing by 3% lightness each step.
            [hsl setLightness:l];
            shade = [hsl toColor];
            [clist addObject:shade];
            l += 0.03;
        }
        
        if (l != 1) [clist addObject:[NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:1]];  //add white at the end, if we haven't already.
        
        [colorsList release];
        colorsList = [clist retain];
        
        [resultsList reloadData];
        [resultsList selectRowIndexes:[NSIndexSet indexSetWithIndex:startIndex] byExtendingSelection:NO];
        [resultsList scrollRowToVisible:startIndex];
	}
    
}
             
-(NSString *) hexForColor:(NSColor *)color {
	NSString *str = @"?";
    str = [NSString stringWithFormat:@"#%02X%02X%02X",
           (unsigned int)(255*[color redComponent]),
           (unsigned int)(255*[color greenComponent]),
           (unsigned int)(255*[color blueComponent])];
    return str;
}

#pragma mark Color Picker Plugin Implementation

- (BOOL)supportsMode:(NSInteger)mode {
	switch (mode) {
		case NSColorPanelAllModesMask:
			return YES;
	}
	return NO;
}

- (NSInteger)currentMode {
	return NSColorPanelAllModesMask;
}


- (NSView *)provideNewView:(BOOL)initialRequest {
    if (initialRequest) {
        // Load our nib files
        if (![NSBundle loadNibNamed:@"ZeroTo255" owner:self]) {
            NSLog(@"ERROR: couldn't load the nib file");
        }
    }
    return mainView;
}


// provide a tooltip for our color picker icon in the NSColorPanel
- (NSString *)_buttonToolTip
{
    return @"ZeroTo255";
}

// provide a description string for our color picker
- (NSString *)description
{
    return @"ZeroTo255 - Shade selection color picker";
}

- (NSImage *)provideNewButtonImage {
	NSImage *im;
	
	im = [[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"icon" ofType:@"icns"]];
	[im setScalesWhenResized:YES];
	[im setSize:NSMakeSize(32.0,32.0)];
	
	return [im autorelease];
}

-(void)awakeFromNib {

}

#pragma mark Color List Table View

-(int)numberOfRowsInTableView:(NSTableView *)tv {
    //NSLog(@"Row count requested. colorsList:%@", colorsList);
    
    if (colorsList == NULL) return 0;
    
    return (int)[colorsList count];
}

-(id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //NSLog(@"Row object value for %ld", row);
    
    NSColor *col = [colorsList objectAtIndex:row];
    
    NSString *hexText = [self hexForColor:col];
    return hexText;
    
}

-(void)tableView:(NSTableView *)tv willDisplayCell:(NSTextFieldCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSColor *col = [colorsList objectAtIndex:row];
    
    [cell setBackgroundColor:col];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 23;
}

-(void)tableViewSelectionDidChange:(id)notification {
    int row = (int)[resultsList selectedRow];
    if (row == -1) return;
    NSColor *col = [colorsList objectAtIndex:row];

    //[self setColor:col];
    [[self colorPanel] setColor:col];	
}

@end
