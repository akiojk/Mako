//
//  MerryCoverFlowMenuItemView.h
//  Mako
//
//  Created by Josh Yu on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MerryCoverFlowMenuItemView : NSView
{
    NSImage *coverFlowImage;
}

- (id)initWithFrame:(NSRect)frame coverFlowImage: (NSImage *) image;

@end
