//
//  MerryStatusScrollerController.h
//  StatusItemScroller
//
//  Created by Qiushi on 11-10-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerryStatusScrollerView.h"
#import <QuartzCore/QuartzCore.h>

@interface MerryStatusScrollerController : NSObject
{
    MerryStatusScrollerView *scrollerView;

    NSFont *defaultFont;
    
    NSString *aniString;
    
    NSStatusItem *statusItem;
    NSMenu *menu;
    
    NSSize defaultSize;
    
    NSTimer *aniTimer;
    
    CVDisplayLinkRef displayLink;
    
}

- (id) initWithStatusItem: (NSStatusItem *) _statusItem withMenu: (NSMenu *) _menu withIcon: (NSImage *) _icon withIconInversed: (NSImage *) _invicon;

- (void) startAnimationForString: (NSString *) specifiedAniString;

- (void) pauseAnimation;

- (void) resumeAnimation;

- (void) displayIconOnly;

- (float) widthForStringDrawing: (NSString*) stringToDraw withFont: (NSFont *) stringFont;


@end
