//
//  ZeroTo255.h
//  ZeroTo255
//
//  Created by Jarvis Badgley on 3/23/11.
//  Copyright 2011 ChiperSoft Systems. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZeroTo255 : NSColorPicker <NSColorPickingCustom> {

    IBOutlet NSView *mainView;
    IBOutlet NSTextField *hexField;

    IBOutlet NSTableView *resultsList;

    NSColor *currColor;
    NSMutableArray *colorsList;

}

-(NSString *) hexForColor:(NSColor *)color;

@end
