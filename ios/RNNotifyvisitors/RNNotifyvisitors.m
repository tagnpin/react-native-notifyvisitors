#if __has_include(<React/RCTConvert.h>)
#import <React/RCTConvert.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>
#import <React/RCTAnimationType.h>
#else
#import "RCTConvert.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTUtils.h"
#import "RCTAnimationType.h"
#endif


#import <UIKit/UIKit.h>
#import "RNNotifyvisitors.h"
#import <objc/runtime.h>


BOOL nvPushObserverReady;
typedef void (^nvPushClickCheckRepeatHandler)(BOOL isnvPushActionRepeat);
typedef void (^nvPushClickCheckRepeatBlock)(nvPushClickCheckRepeatHandler completionHandler);
int nvCheckPushClickTimeCounter = 0;

@implementation RNNotifyvisitors

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}



//app delegate methods

+(void)Initialize{
    NSLog(@"Initialize triggered !!");
        NSString *nvMode = nil;
    #if DEBUG
        nvMode = @"debug";
    #else
        nvMode = @"live";
    #endif
        [notifyvisitors Initialize:nvMode];
    
}

+(void)RegisterPushWithDelegate:(id _Nullable)delegate App:(UIApplication * _Nullable)application launchOptions:(NSDictionary *_Nullable)launchOptions{
    [notifyvisitors RegisterPushWithDelegate: delegate App: application launchOptions: launchOptions];
}


//for simple push

+(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    @try{
NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken triggered !!");
        [notifyvisitors DidRegisteredNotification: application deviceToken: deviceToken];
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
    
}


+(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    @try{
NSLog(@"didFailToRegisterForRemoteNotificationsWithError triggered !!");
        NSLog(@"Error:%@",error);
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
    
}

+(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    @try{
        NSLog(@"didReceiveRemoteNotification triggered !!");
    [notifyvisitors didReceiveRemoteNotificationWithUserInfo: userInfo];
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}

+(void)applicationWillTerminate{
    @try{
        NSLog(@"applicationWillTerminate triggered !!");
        [notifyvisitors applicationWillTerminate];
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
    
}



//open Url Function

+(void)openUrl:(UIApplication *_Nullable)application openURL:(NSURL*)url{
    
    [notifyvisitors OpenUrlWithApplication:application Url:url];
    
    
}


+(void)willPresentNotification:(UNNotification *_Nullable)notification withCompletionHandler:(void (^_Nullable)(UNNotificationPresentationOptions options))completionHandler {
      @try{
            NSLog(@"userNotificationCenter triggered !!");
            [notifyvisitors willPresentNotification: notification withCompletionHandler: completionHandler];
        }
       @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
            //callback(@[exception.reason, [NSNull null]]);
        }
}



+(void)didReceiveNotificationResponse:(UNNotificationResponse *_Nullable)response {
    
    NSLog(@"didReceiveNotificationResponse called !!");
    @try{
        //  NSLog(@"didReceiveNotificationResponse triggered with nvPushObserverReady value = %@", nvPushObserverReady ? @"YES" : @"NO");
    
          if(!nvPushObserverReady) {
              [self nvPushClickCheckInSeconds: 1 withBlock: ^(nvPushClickCheckRepeatHandler completionHandler) {
                  [notifyvisitors didReceiveNotificationResponse: response];
              }];
          } else {
              [notifyvisitors didReceiveNotificationResponse: response];
          }
    
        }
        @catch(NSException *exception){
            NSLog(@"push click exception = %@", exception.reason);
            //callback(@[exception.reason, [NSNull null]]);
        }
    
    
}


+(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    @try{
        NSLog(@"didReceiveRemoteNotification triggered !!");
         [notifyvisitors didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
          
}


//Geofencing Methods

+(void)applicationDidEnterBackground:(UIApplication *)application{
    @try{
        NSLog(@"NotifyVisitors applicationDidEnterBackground triggered");
        [notifyvisitors applicationDidEnterBackground: application];
        
    }@catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}


+(void)applicationDidBecomeActive:(UIApplication *)application{
    @try{
        NSLog(@"NotifyVisitors applicationDidBecomeActive triggered");
        [notifyvisitors applicationDidBecomeActive: application];
    
    }@catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
    
}


+(void)NotifyVisitorsGeofencingReceivedNotificationWithApplication:(UIApplication *)application  localNotification:(UILocalNotification *) notification{
    @try{
    NSLog(@"NotifyVisitorsGeofencingReceivedNotificationWithApplication triggered !!");
        [notifyvisitors NotifyVisitorsGeofencingReceivedNotificationWithApplication:application window:[UIApplication sharedApplication].keyWindow didReceiveGeofencingNotification:notification];
        
    }@catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }

}


+(void)nvPushClickCheckInSeconds:(int)seconds withBlock: (nvPushClickCheckRepeatBlock) nvPushCheckBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        nvCheckPushClickTimeCounter = nvCheckPushClickTimeCounter + seconds;
        if(!nvPushObserverReady) {
            if (nvCheckPushClickTimeCounter < 20) {
                return [self nvPushClickCheckInSeconds: seconds withBlock: nvPushCheckBlock];
                //[self irDispatchReatforTrackingDataInSeconds: seconds withBlock: irBlock];
            } else {
                //irTempTrackResponse = @{@"Authentication" : @"failed",@"http_code": @"408"};
            nvPushCheckBlock(^(BOOL isRepeat) {
                if (isRepeat) {
                    if (nvCheckPushClickTimeCounter < 20) {
                        return [self nvPushClickCheckInSeconds: seconds withBlock: nvPushCheckBlock];
                        }
                    }
                });
            }
        } else {
            nvPushCheckBlock(^(BOOL isRepeat) {
                if (isRepeat) {
                    if (nvCheckPushClickTimeCounter < 20) {
                        return [self nvPushClickCheckInSeconds: seconds withBlock: nvPushCheckBlock];
                    }
                }
            });
        }
    });
}

@end

