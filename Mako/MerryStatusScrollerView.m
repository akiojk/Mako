//
//  ScrollerView.m
//  StatusItemScroller
//
//  Created by Qiushi on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryStatusScrollerView.h"

@implementation MerryStatusScrollerView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        scrollerTextView = [[MerryStatusScrollerTextView alloc] init];
        [self addSubview: scrollerTextView];
        
    }
    
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{

    
    if(isMenuVisible)
    {
        [parentStatusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:YES];
        [iconImageInversed setSize: NSMakeSize(11, 18)];
        [iconImageInversed drawAtPoint:NSMakePoint(5, 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }else
    {
        [iconImage drawAtPoint:NSMakePoint(5, 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    }

}

- (void) buildAnimationForString: (NSString *) specifiedAniString withWidth:(float)width withFont:(NSFont *)font
{
    [scrollerTextView buildAnimationForString: specifiedAniString withWidth: width withFont: font];
    [scrollerTextView setFrame: NSMakeRect(21, 0, [self bounds].size.width - 28,  [self bounds].size.height)];
    
}

- (void) timerTick
{
    [scrollerTextView forceDrawing];
}
 
- (void) setIconImage: (NSImage *)_iconImage inversedImage: (NSImage *) _iconImageInversed
{
    iconImage = _iconImage;
    iconImageInversed = _iconImageInversed;
    [iconImage setSize: NSMakeSize(11, 18)];
    [iconImageInversed setSize: NSMakeSize(11, 18)];
}

- (void) setParentStatusItem: (NSStatusItem *) _statusItem
{
    parentStatusItem = _statusItem;
}

- (void) setDropDownMenu: (NSMenu *) _menu
{
    dropDownMenu = _menu;
    [_menu setDelegate: self];
}

- (void) mouseDown:(NSEvent *)theEvent
{
    [parentStatusItem popUpStatusItemMenu: dropDownMenu];
}

- (void) menuWillOpen: (NSMenu *)menu
{
    isMenuVisible = YES;
    [scrollerTextView setIsMenuVisible: isMenuVisible];
    [self setNeedsDisplay: YES];
}

- (void) menuDidClose:(NSMenu *)menu
{
    isMenuVisible = NO;
    [scrollerTextView setIsMenuVisible: isMenuVisible];
    [self setNeedsDisplay: YES];
}
 
- (void) pauseAnimation
{
    [scrollerTextView pauseAnimation];
}

- (void) resumeAnimation
{
    [scrollerTextView resumeAnimation];
}


@end
