//
//  AppDelegate.m
//  PushBotsObjcDemo
//
//  Created by Atiaa on 1/4/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.PushbotsClient = [[Pushbots alloc] initWithAppId:@"YOUR_APPID" prompt:YES];
    
    [self.PushbotsClient trackPushNotificationOpenedWithLaunchOptions:launchOptions];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        //Check for openURL [optional]
        [Pushbots openURL:userInfo];
        //Capture notification data e.g. badge, alert and sound
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        
        if (aps) {
            NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
            NSDictionary *alertDict = [notificationDict objectForKey:@"alert"];
            NSString *alertbody = [alertDict objectForKey:@"body"];
            NSString *alertTitle= [alertDict objectForKey:@"title"];
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:alertTitle
                                         message:alertbody
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];
        }
        //Capture custom fields
//        NSString* articleId = [userInfo objectForKey:@"articleId"];
    }

    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Register the deviceToken on Pushbots
    [self.PushbotsClient registerOnPushbots:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Notification Registration Error %@", [error description]);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //Check for openURL [optional]
    //[Pushbots openURL:userInfo];
    //Track notification only if the application opened from Background by clicking on the notification.
    if (application.applicationState == UIApplicationStateInactive) {
        [self.PushbotsClient trackPushNotificationOpenedWithPayload:userInfo];
    }
    
    //The application was already active when the user got the notification, just show an alert.
    //That should *not* be considered open from Push.
    if (application.applicationState == UIApplicationStateActive) {
        NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
        NSDictionary *alertDict = [notificationDict objectForKey:@"alert"];
        NSString *alertbody = [alertDict objectForKey:@"body"];
        NSString *alertTitle= [alertDict objectForKey:@"title"];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:alertTitle
                                     message:alertbody
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];
    }
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    // .. Process notification data
    handler(UIBackgroundFetchResultNewData);
    [Pushbots openURL:userInfo];

    NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
    NSDictionary *alertDict = [notificationDict objectForKey:@"alert"];
    NSString *alertbody = [alertDict objectForKey:@"body"];
    NSString *alertTitle= [alertDict objectForKey:@"title"];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:alertTitle
                                 message:alertbody
                                 preferredStyle:UIAlertControllerStyleAlert];

    [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];

}
@end
