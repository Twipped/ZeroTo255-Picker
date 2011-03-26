//
//  HSLColor.m
//  ZeroTo255
//
//  Created by Jarvis Badgley on 3/23/11.
//  Copyright 2011 ChiperSoft Systems. All rights reserved.
//

#import "HSLColor.h"


@implementation HSLColor
@synthesize hue;
@synthesize saturation;
@synthesize lightness;

-(HSLColor *) initFromColor:(NSColor *)color {
    double r,g,b, min, max;
    
    if ((self = [super init])) {
        
        r = [color redComponent];
        g = [color greenComponent];
        b = [color blueComponent];
        min = 1;
        max = 0;
        
        if (r < min) min = r;
        if (r > max) max = r;
        
        if (g < min) min = g;
        if (g > max) max = g;
        
        if (b < min) min = b;
        if (b > max) max = b;
        
        //NSLog(@"fromRGB - r:%f g:%f b:%f min:%f max:%f", r,g,b,min, max);

        lightness = (max+min)/2;
        
        if (min == max) {
            saturation = 0;
            hue = 0;
            return self; //color is a form of grey, no need to continue
        }
        
        if (lightness < 0.5) {
            saturation = (max-min)/(max+min);
        } else {
            saturation = (max-min)/(2.0-max-min);
        }
        
        if (r==max) hue = (g-b)/(max-min);
        else if (g==max) hue = 2.0 + (b-r)/(max-min);
        else if (b==max) hue = 4.0 + (r-g)/(max-min);
        
        hue = hue * 60;
        if (hue<0) hue += 360;
    
    }
    return self;
}

-(NSColor *) toColor {
    double temp1, temp2;
    double temp3[] = {0,0,0};
    int i;
    
    if (saturation == 0) {
        //NSLog(@"  toRGB - r:%f g:%f b:%f", lightness, lightness, lightness);
        return [NSColor colorWithDeviceRed:lightness green:lightness blue:lightness alpha:1];
    }
    
    if (lightness < 0.5) temp2 = lightness * (1.0+saturation);
    else temp2 = lightness + saturation - lightness * saturation;
    
    temp1 = 2.0 * lightness - temp2;
    
    temp3[0] = (hue/360) + 1.0/3.0;
    temp3[1] = (hue/360);
    temp3[2] = (hue/360) - 1.0/3.0;

    for (i = 0;i<=2;i++) {
        if (temp3[i] < 0) temp3[i] += 1.0;
        if (temp3[i] > 1) temp3[i] -= 1.0;
        //NSLog(@"temp3[%i]: %f", i, temp3[i]);
        
        if (6.0 * temp3[i] < 1) temp3[i] = temp1 + (temp2-temp1) * 6.0 * temp3[i];
        else if (2.0 * temp3[i] < 1) temp3[i] = temp2;
        else if (3.0 * temp3[i] < 2) temp3[i] = temp1 + (temp2 - temp1) * ((2.0/3.0)-temp3[i]) * 6.0;
        else temp3[i] = temp1;
        
        //NSLog(@"temp3[%i]: %f", i, temp3[i]);
    }
    
    //NSLog(@"  toRGB - r:%f g:%f b:%f", temp3[0],temp3[1], temp3[2]);
    
    return [NSColor colorWithDeviceRed:temp3[0] green:temp3[1] blue:temp3[2] alpha:1];
}

@end
