//
//  ScrollerTextView.h
//  StatusItemScroller
//
//  Created by Qiushi on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MerryStatusScrollerTextView : NSView
{
 
    NSDictionary *defaultAttributes;
    NSDictionary *defaultAttributesHighlighted;
    
    float stepInDistance;
    float distanceInBetween;
    float stringWidth;
    float leftPaddingBeforePause;
    float leftPaddingBeforeSlowDown;
    
    NSTimeInterval pauseInterval;
    
    NSPoint currentPoint;
 
    BOOL isMenuVisible;
    
    BOOL isAnimating;
    
    float aniInterval;
    
    NSString *aniString;
    
    NSTimer *pauseTimer;
    
    NSGradient *gradient;
}


- (void) setIsMenuVisible: (BOOL) visibility;

- (void) buildAnimationForString: (NSString *) specifiedAniString withWidth: (float) width withFont: (NSFont *) font;

- (void) forceDrawing;

- (void) resumeAnimation;

- (void) pauseAnimation;

@end
