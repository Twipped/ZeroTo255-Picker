//
//  HSLColor.h
//  ZeroTo255
//
//  Created by Jarvis Badgley on 3/23/11.
//  Copyright 2011 ChiperSoft Systems. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HSLColor : NSObject {
   double hue;
   double saturation;
   double lightness;
}

@property (nonatomic, assign) double hue;
@property (nonatomic, assign) double saturation;
@property (nonatomic, assign) double lightness;

-(HSLColor *) initFromColor:(NSColor *)color;
-(NSColor *) toColor;
@end
