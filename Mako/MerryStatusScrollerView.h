//
//  ScrollerView.h
//  StatusItemScroller
//
//  Created by Qiushi on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MerryStatusScrollerTextView.h"
#import <QuartzCore/QuartzCore.h>

@interface MerryStatusScrollerView : NSView <NSMenuDelegate>
{
    float timeInterval;
    NSMenu *dropDownMenu;
    
    NSStatusItem *parentStatusItem;
    
    NSImage *iconImage;
    NSImage *iconImageInversed;
    
    BOOL isMenuVisible;
    
    NSRect frameForScrollingText;
    
    MerryStatusScrollerTextView *scrollerTextView;
    
    NSFont *defaultFont;

}

- (void) buildAnimationForString: (NSString *) specifiedAniString withWidth:(float)width withFont: (NSFont *) font;

- (void) timerTick;

- (void) setIconImage: (NSImage *)_iconImage inversedImage: (NSImage *) _iconImageInversed;

- (void) setParentStatusItem: (NSStatusItem *) _statusItem;

- (void) setDropDownMenu: (NSMenu *) _menu;

- (void) pauseAnimation;

- (void) resumeAnimation;

@end
