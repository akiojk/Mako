//
//  MerryStatusScrollerController.m
//  StatusItemScroller
//
//  Created by Qiushi on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MerryStatusScrollerController.h"

@implementation MerryStatusScrollerController

- (id) initWithStatusItem: (NSStatusItem *) _statusItem withMenu: (NSMenu *) _menu withIcon: (NSImage *) _icon withIconInversed: (NSImage *) _invicon
{
    if(self = [super init])
    {
        defaultFont = [NSFont fontWithName:@"Lucida Grande" size:13.0];
        defaultSize = NSMakeSize(22, 28);
        
        scrollerView = [[MerryStatusScrollerView alloc] init];
        
        [scrollerView setParentStatusItem: _statusItem];
        [scrollerView setDropDownMenu: _menu];
        [scrollerView setIconImage: _icon inversedImage: _invicon];
        
        [_statusItem setView: scrollerView];
        
        
        aniTimer= [NSTimer scheduledTimerWithTimeInterval: 0.01 target:scrollerView selector:@selector(timerTick) userInfo:nil repeats:YES];
        
        
    }
    
    return self;
    
}

- (CVReturn) drawTheShit
{
    [scrollerView timerTick];
    
    return kCVReturnSuccess;
}


- (void) startAnimationForString: (NSString *) specifiedAniString
{
    aniString = specifiedAniString;
    
    [scrollerView setFrameSize: NSMakeSize(150.0f, [scrollerView bounds].size.height)];
    
    [scrollerView buildAnimationForString: specifiedAniString withWidth: [self widthForStringDrawing: specifiedAniString withFont: defaultFont] withFont: defaultFont];
    
}


- (void) resumeAnimation 
{
    [scrollerView resumeAnimation];
}

- (void) pauseAnimation
{
    [scrollerView pauseAnimation];
}

- (void) displayIconOnly
{
    [scrollerView setFrameSize: defaultSize];
    
    [scrollerView buildAnimationForString: @"" withWidth:0.0 withFont: defaultFont];
    
    [scrollerView pauseAnimation];
}


- (float) widthForStringDrawing: (NSString*) stringToDraw withFont: (NSFont *) stringFont
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString: stringToDraw];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(FLT_MAX, FLT_MAX)];
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    [layoutManager addTextContainer: textContainer];
    [textStorage addLayoutManager: layoutManager];
    [textStorage addAttribute: NSFontAttributeName value: stringFont range: NSMakeRange(0, [textStorage length])];
    
    [textContainer setLineFragmentPadding: 0.0];
    
    (void) [layoutManager glyphRangeForTextContainer: textContainer];
    
    return [layoutManager usedRectForTextContainer: textContainer].size.width;
}

@end
