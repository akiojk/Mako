//
//  MerryCoverFlowMenuItemView.m
//  Mako
//
//  Created by Josh Yu on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MerryCoverFlowMenuItemView.h"

@implementation MerryCoverFlowMenuItemView

- (id)initWithFrame:(NSRect)frame coverFlowImage: (NSImage *) image
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        coverFlowImage = image;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect fullBounds = [self bounds];

    fullBounds.origin.y += 6;
    
    [NSGraphicsContext saveGraphicsState];
    
    [[NSBezierPath bezierPathWithRect:fullBounds] setClip]; // make possible to draw above gap

    
    [coverFlowImage drawInRect: fullBounds 
                      fromRect: NSMakeRect(0, 0, [coverFlowImage size].width, [coverFlowImage size].height) operation: NSCompositeSourceOver fraction:1.0];
    
    
    [NSGraphicsContext restoreGraphicsState];
    
//    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite: 1.0 alpha:1.0]
//                                             endingColor:[NSColor clearColor]];     
//
//    [gradient drawInRect: NSMakeRect(fullBounds.origin.x, fullBounds.origin.y, fullBounds.size.width, 50) 
//                   angle: 90];
    
//    [[NSColor redColor] set];
//    [NSBezierPath strokeRect:  NSMakeRect(fullBounds.origin.x, fullBounds.origin.y, fullBounds.size.width, 80) ];
//    

    
    [NSGraphicsContext saveGraphicsState];
//  
//    
//    
//    [NSGraphicsContext restoreGraphicsState];
    
    [[NSColor colorWithSRGBRed:0.87 green:0.87 blue:0.87 alpha:1] set];
    
    [NSBezierPath strokeLineFromPoint: NSMakePoint(fullBounds.origin.x, fullBounds.origin.y) toPoint: NSMakePoint(fullBounds.origin.x + fullBounds.size.width, fullBounds.origin.y)];

}

@end
