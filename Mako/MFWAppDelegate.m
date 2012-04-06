//
//  MFWAppDelegate.m
//  Mako
//
//  Created by 余 秋实 on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MFWAppDelegate.h"

@implementation MFWAppDelegate

@synthesize window = _window, menu, pauseAnimationMenuItem, launchAtStartMenuItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    userPaused = NO;

    isCoverFlowMenuItemAdded = NO;
    
    coverFlowMenuItem = [[NSMenuItem alloc] init];
    
    [launchAtStartMenuItem setState: ([self appExistsInLoginItem] != nil) ? NSOnState : NSOffState];  
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    
    NSImage *iconImage = [NSImage imageNamed: @"31-ipod.png"];
    [iconImage setSize: NSMakeSize(11, 18)];
    
    NSImage *iconInvImage = [NSImage imageNamed: @"31-ipod_inv.png"];
    [iconInvImage setSize: NSMakeSize(11, 18)];
    
    scrollerController = [[MerryStatusScrollerController alloc] initWithStatusItem: statusItem withMenu: menu withIcon: iconImage withIconInversed: iconInvImage];
    
    iTunes = [SBApplication applicationWithBundleIdentifier: @"com.apple.iTunes"];
    
    if([iTunes playerState] != iTunesEPlSPlaying)
    {
        shouldBeAnimating = NO;
        [scrollerController displayIconOnly];
    }
    else
    {   
        shouldBeAnimating = YES;
        //        [self scrollForSongName: [currentTrack name] artist: [currentTrack artist]];
        [self scrollForTrack: [iTunes currentTrack]];
    }
    
    
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver: self selector: @selector(changeTrack:) name: @"com.apple.iTunes.playerInfo" object: nil];
    
    
}


- (void) changeTrack:(NSNotification *) notification
{
    NSDictionary *info = [notification userInfo];
    NSLog(@"Info: %@", info);
    
    iTunesTrack *currentTrack = [iTunes currentTrack];
    
    if([[info valueForKey: @"Player State"] isEqual: @"Stopped"])
    {
        shouldBeAnimating = NO;
        [scrollerController displayIconOnly];
    }
    else if([[info valueForKey: @"Player State"] isEqual: @"Paused"])
    {
        shouldBeAnimating = NO;
        [scrollerController pauseAnimation];
        currentSongPersistentID = [info valueForKey: @"PersistentID"];
    }
    else if([[info valueForKey: @"Player State"] isEqual: @"Playing"])
    {
        if(userPaused == NO)
        {
            shouldBeAnimating = YES;
            
            if(![[info valueForKey: @"PersistentID"] isEqual: currentSongPersistentID])
            {
                [self scrollForTrack: currentTrack];
            }
            
            [scrollerController resumeAnimation];
        }
        else
        {
            shouldBeAnimating = NO;
            
            if(![[info valueForKey: @"PersistentID"] isEqual: currentSongPersistentID])
            {
                [self scrollForTrack: currentTrack];
            }
            
            [scrollerController pauseAnimation];
        }
        
    }
}

- (void) scrollForTrack: (iTunesTrack *) track
{
    if([[[track artworks] get] count]) // if array is null, then count=nil
    {
        NSImage *coverFlowImage = [[NSImage alloc] initWithData: [(iTunesArtwork *)[[[track artworks] get] objectAtIndex:0] rawData]];
        
        MerryCoverFlowMenuItemView *coverFlowView;
        
        float coverFlowWidth = [menu size].width > 200 ? [menu size].width : 200;
        
        coverFlowView = [[MerryCoverFlowMenuItemView alloc] initWithFrame: NSMakeRect(0, 0, coverFlowWidth, [coverFlowImage size].height * (coverFlowWidth / [coverFlowImage size].width)) coverFlowImage: coverFlowImage];

        
        if(isCoverFlowMenuItemAdded)
        {
            [[menu itemAtIndex:0] setView: coverFlowView];
        }
        else
        {
            isCoverFlowMenuItemAdded = YES;

            [coverFlowMenuItem setView: coverFlowView];
            [menu insertItem: coverFlowMenuItem atIndex:0];
            
        }

        [menu update];
    }
    else
    {

        if(isCoverFlowMenuItemAdded)
        {
            [menu removeItemAtIndex: 0];
            isCoverFlowMenuItemAdded = NO;
        }
        
        [menu update];
    }
    
    [self scrollForSongName: [track name] artist: [track artist]];
    
}

- (void) scrollForSongName: (NSString *) name artist:(NSString *) artist
{
    stringToScroll = [NSString stringWithFormat: @"%@ - %@", name, artist];
    
    [scrollerController startAnimationForString: stringToScroll];
    
    
}

- (IBAction) toggleAnimationEnabling:(id)sender
{
    userPaused = !([[self pauseAnimationMenuItem] state] == NSOnState); // This is current status. If currently NSOffState, user is intending to turn it ON.
    
    shouldBeAnimating = !userPaused;
    
    if(userPaused == YES)
    {       
        [scrollerController pauseAnimation];
        [[self pauseAnimationMenuItem] setState: NSOnState];
        
    }
    else
    {
        [scrollerController resumeAnimation];
        [[self pauseAnimationMenuItem] setState: NSOffState];
    }
}

- (IBAction) toggleLaunchAtStart:(id)sender
{
    if(![self appExistsInLoginItem])
    {
        [self addAppAsLoginItem];
        [launchAtStartMenuItem setState: NSOnState];
    }
    else
    {
        [self removeAppFromLoginItem];
        [launchAtStartMenuItem setState: NSOffState];
    }
}



-(void) addAppAsLoginItem{
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
    
	// This will retrieve the path for the application
	// For example, /Applications/test.app
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath]; 
    
	// Create a reference to the shared file list.
    // We are adding it to the current user only.
    // If we want to add it all users, use
    // kLSSharedFileListGlobalLoginItems instead of
    //kLSSharedFileListSessionLoginItems
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, NULL);
	if (loginItems) {
		//Insert an item to the list.
		LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
                                                                     kLSSharedFileListItemLast, NULL, NULL,
                                                                     url, NULL, NULL);
		if (item){
			CFRelease(item);
        }
	}	
    
	CFRelease(loginItems);
}

-(LSSharedFileListItemRef) appExistsInLoginItem
{
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
    
	// This will retrieve the path for the application
	// For example, /Applications/test.app
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath]; 
    
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, NULL);
    
	if (loginItems) {
		UInt32 seedValue;
		//Retrieve the list of Login Items and cast them to
		// a NSArray so that it will be easier to iterate.
		NSArray  *loginItemsArray = (__bridge_transfer NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
		for(int i=0 ; i< [loginItemsArray count]; i++){
			LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)[loginItemsArray
                                                                                 objectAtIndex:i];
			//Resolve the item with URL
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
				NSString * urlPath = [(__bridge_transfer NSURL*)url path];
				if ([urlPath compare:appPath] == NSOrderedSame){
					return itemRef;
				}
			}
		}
	}
    return nil;
}

- (void) removeAppFromLoginItem
{
    if([self appExistsInLoginItem] != nil)
    {
        LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                                kLSSharedFileListSessionLoginItems, NULL);
        
        LSSharedFileListItemRemove(loginItems, [self appExistsInLoginItem]);
    }
    
}



@end
