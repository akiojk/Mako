//
//  ScrollerTextView.m
//  StatusItemScroller
//
//  Created by Qiushi on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryStatusScrollerTextView.h"

@implementation MerryStatusScrollerTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        distanceInBetween = 50.0f;
        stepInDistance = 0.5f;
        pauseInterval = 2.0f;
        leftPaddingBeforePause = 5.0f;
        leftPaddingBeforeSlowDown = 24.0f;
        isAnimating = YES;
    }
    
    return self;
}


- (void) setIsMenuVisible: (BOOL) visibility
{
    isMenuVisible = visibility;
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    float diff = [self bounds].size.width - (stringWidth + currentPoint.x) - distanceInBetween;
    
    // if 1st string completely vanishes, we reset its x to the x of 2nd string then 2nd string becomes the new 1st string.
    
    if (fabsf(currentPoint.x) >= stringWidth && currentPoint.x) 
    {
        currentPoint.x = [self bounds].size.width - diff - stepInDistance;
    }
    else
    {
        if (diff >= 0) // if needs to draw 2nd string
        {
            [aniString drawAtPoint: NSMakePoint([self bounds].size.width - diff, currentPoint.y) 
                    withAttributes: (isMenuVisible ? defaultAttributesHighlighted : defaultAttributes)];
        }
    }
    
    [aniString drawAtPoint: currentPoint 
            withAttributes: (isMenuVisible ? defaultAttributesHighlighted : defaultAttributes) ]; // draw 1st string
    
    
    
    if(currentPoint.x >= leftPaddingBeforePause && currentPoint.x - stepInDistance <= leftPaddingBeforePause && isAnimating == YES)
    {
        isAnimating = NO;
        
        pauseTimer = [NSTimer scheduledTimerWithTimeInterval: pauseInterval target: self selector: @selector(resumeAnimation) userInfo:nil repeats: NO];
        
    }
    
    
    currentPoint.x -= stepInDistance;
    
    
    // draw gradients at left and right.
    
    if(!isMenuVisible)
    {
        [NSGraphicsContext saveGraphicsState];
        [[NSGraphicsContext currentContext] setCompositingOperation: NSCompositeDestinationOut];
        
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor blackColor]
                                                             endingColor:[NSColor clearColor]];
        [gradient drawInRect: NSMakeRect(dirtyRect.origin.x, dirtyRect.origin.y, 5, dirtyRect.size.height) angle: 0];
        
        NSGradient *gradient2 = [[NSGradient alloc] initWithStartingColor:[NSColor blackColor]
                                                              endingColor:[NSColor clearColor]];
        
        [gradient2 drawInRect: NSMakeRect([self bounds].origin.x+[self bounds].size.width-5, [self bounds].origin.y, 5, [self bounds].size.height) angle: 180];
        
        [NSGraphicsContext restoreGraphicsState];
    }
    
}

- (void) resumeAnimation
{
    isAnimating = YES;
}

- (void) pauseAnimation
{
    [pauseTimer invalidate];
    isAnimating = NO;
}


- (void) buildAnimationForString: (NSString *) specifiedAniString withWidth:(float)width withFont:(NSFont *)font
{
    aniString = specifiedAniString;
    
    stringWidth = width;
    
    currentPoint = NSMakePoint(leftPaddingBeforePause, 3);   
    
    defaultAttributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [NSColor blackColor], NSForegroundColorAttributeName, nil];
    
    defaultAttributesHighlighted = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [NSColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self setNeedsDisplay: YES];
} 

- (void) forceDrawing
{
    if(isAnimating == YES)
    {
        [self setNeedsDisplay:YES];
    }
}


@end
