#if __has_include(<notifyvisitors/notifyvisitors.h>)
#import <notifyvisitors/notifyvisitors.h>
#else
#import "../notifyvisitors.h"
#endif
#if __has_include(<UserNotifications/UserNotifications.h>)
#import <UserNotifications/UserNotifications.h>
#else
#import "UserNotifications.h"
#endif



extern BOOL nvPushObserverReady;

@interface RNNotifyvisitors : NSObject <UNUserNotificationCenterDelegate>

// SDK initialization
+(void)Initialize;

+(void)RegisterPushWithDelegate:(id _Nullable)delegate App:(UIApplication * _Nullable)application launchOptions:(NSDictionary *_Nullable)launchOptions;


//for simple push

+(void)application:(UIApplication *_Nullable)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *_Nullable)deviceToken;

+(void)application:(UIApplication *_Nullable)application didFailToRegisterForRemoteNotificationsWithError:(NSError *_Nullable)error;
    
+(void)application:(UIApplication *_Nullable)application didReceiveRemoteNotification:(NSDictionary *_Nullable)userInfo;

// app termination

+(void)applicationWillTerminate;


// ios 10 push methods
+(void)willPresentNotification:(UNNotification *_Nullable)notification withCompletionHandler:(void (^_Nullable)(UNNotificationPresentationOptions options))completionHandler;

+(void)didReceiveNotificationResponse:(UNNotificationResponse *_Nullable)response;

+(void)application:(UIApplication *_Nullable)application didReceiveRemoteNotification:(NSDictionary *_Nullable)userInfo
fetchCompletionHandler:(void (^_Nullable)(UIBackgroundFetchResult))completionHandler;


//Geofencing methods

+(void)applicationDidEnterBackground:(UIApplication *_Nullable)application;
+(void)applicationDidBecomeActive:(UIApplication *_Nullable)application;
+(void)NotifyVisitorsGeofencingReceivedNotificationWithApplication:(UIApplication *_Nullable)application localNotification:(UILocalNotification *_Nullable) notification;


//open Url Application

+(void)openUrl:(UIApplication *_Nullable)application openURL:(NSURL *_Nullable)url;


@end
  
