//
//  AppDelegate.m
//  ImageBrowser
//
//  Created by yoshimura on 2013/11/17.
//  Copyright (c) 2013年 yoshimura. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Create a background task identifier
    __block UIBackgroundTaskIdentifier task;
    task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 10分未満に終わらず強制終了
        NSLog(@"System terminated background task early");
        [application endBackgroundTask:task];
    }];
    
    // If the system refuses to allow the task return
    if (task == UIBackgroundTaskInvalid)
    {
        NSLog(@"System refuses to allow background task");
        return;
    }
    
    // Do the task
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *pastboardContents = [UIPasteboard generalPasteboard].string;
        
        for (int i = 0; i < 1000; i++)
        {
            if (![pastboardContents isEqualToString:[UIPasteboard generalPasteboard].string])
            {
                pastboardContents = [UIPasteboard generalPasteboard].string;
                
                
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^https?:\\/\\/"
                                                                                       options:0
                                                                                         error:nil];
                NSArray *matches = [regex matchesInString: pastboardContents
                                       
                                                     options:0
                                                                      range:NSMakeRange(0, [pastboardContents length])];
                
                if ([matches count] == 1){
                    
                
                    NSLog(@"Pasteboard Contents: %@", pastboardContents);
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                
                        [self pushLocalNotify:pastboardContents];
                
                    });
                }
                    
            }
            
            // Wait some time before going to the beginning of the loop
            [NSThread sleepForTimeInterval:1];
        }
        
        // End the task
        // 完了を通知
        [application endBackgroundTask:task];
    });

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

- (void) pushLocalNotify:(NSString*) _alertBody
{
    // 全通知削除
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:.5f]];
    [notification setTimeZone:[NSTimeZone systemTimeZone]];
    [notification setAlertBody:_alertBody];
    [notification setUserInfo:nil];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setAlertAction:@"Open"];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSLog(@"didReceiveLocalNotification %@", [notification alertBody]);
    
    // キャンセル処理
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    
    
    
    // 通知の受取側に送る値を作成する
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[notification alertBody] forKey:@"url"];
    
    // 通知を作成する
    NSNotification *_n =
        [NSNotification notificationWithName:@"NotifyPasteBoard" object:nil userInfo:dic];
    
    // 通知実行！
    [[NSNotificationCenter defaultCenter] postNotification:_n];

}

@end
