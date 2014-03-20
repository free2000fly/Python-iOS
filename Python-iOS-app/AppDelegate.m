//
//  AppDelegate.m
//  Python-iOS-app
//
//  Created by Fancyzero on 13-8-21.
//  Copyright (c) 2013年 Fancyzero. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#include "Python.h"

@implementation AppDelegate

+ (NSString *)documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
}

+ (BOOL)copyFileIfNotExist:(NSString *)srcPath target:(NSString *)targetPath {
    BOOL succ = NO;
	// First, test for existence - we don't want to wipe out a user's DB
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	BOOL dbexits = [fileManager fileExistsAtPath:targetPath];
	if (!dbexits) {
		NSError *error;
		succ = [fileManager copyItemAtPath:srcPath toPath:targetPath error:&error];
		if (!succ) {
			NSAssert1(0, @"Failed to copy file with message '%@'.\n", [error localizedDescription]);
		}
	} else {
        succ = YES;
    }
    return succ;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    
    /* terminate Python environment */
    Py_Finalize();
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //init python
    //get python lib path and set this path as python home directory
    NSString* fullpath = [[NSBundle mainBundle] pathForResource:@"python" ofType:nil inDirectory:nil];
    Py_SetPythonHome( (char *) [fullpath UTF8String] );
    
    Py_Initialize();
    if (!Py_IsInitialized()) {
        printf("Initialize failed!\n");
        return NO;
    }
    
    PyRun_SimpleString("import sys");
    // sys.path.append('./Documents')
    NSString *env = [NSString stringWithFormat:@"sys.path.append('%@')", [AppDelegate documentsPath]];
    PyRun_SimpleString([env UTF8String]);
    
    PyRun_SimpleString("print 'hello'");//say hello see debug output :)
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
