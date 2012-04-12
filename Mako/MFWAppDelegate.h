//
//  MFWAppDelegate.h
//  Mako
//
//  Created by 余 秋实 on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>
#import "iTunes.h"
#import "MerryCoverFlowMenuItemView.h"
#import "MerryStatusScrollerController.h"

@interface MFWAppDelegate : NSObject <NSApplicationDelegate>
{
    NSStatusItem *statusItem;
    MerryStatusScrollerController *scrollerController;
    BOOL shouldBeAnimating;
    NSString *stringToScroll;
    NSString *currentSongPersistentID;
    BOOL userPaused;
    iTunesApplication *iTunes;
    BOOL isCoverFlowMenuItemAdded;
    NSMenuItem *coverFlowMenuItem;
    float menuMinSize;
}

- (void) scrollForSongName: (NSString *) name artist:(NSString *) artist;
- (void) scrollForTrack: (iTunesTrack *) track;
- (IBAction) toggleAnimationEnabling:(id)sender;
- (IBAction) toggleLaunchAtStart:(id)sender;
- (LSSharedFileListItemRef) appExistsInLoginItem;
- (void) addAppAsLoginItem;
- (void) removeAppFromLoginItem;

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSMenu *menu;

@property (assign) IBOutlet NSMenuItem *pauseAnimationMenuItem;

@property (assign) IBOutlet NSMenuItem *launchAtStartMenuItem;

@end
