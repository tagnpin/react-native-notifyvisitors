#import "RCTEventEmitterDemo.h"
#if __has_include(<notifyvisitors/notifyvisitors.h>)
#import <notifyvisitors/notifyvisitors.h>
#else
#import "../notifyvisitors.h"
#endif
#import "RNNotifyvisitors.h"
#import <UIKit/UIKit.h>

BOOL nvDismissNCenterOnAction;
static BOOL hasListeners;

@implementation RCTEventEmitterDemo{
  BOOL hasListeners;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

static BOOL _startObserving = false;

+ (BOOL)hasSetBridge {
    return _startObserving;
}

+(BOOL)requiresMainQueueSetup {
    return YES;
}

RCT_EXPORT_MODULE(RNNotifyvisitors);

#pragma mark RCTEventEmitter Subclass Methods

-(instancetype)init {
    if (self = [super init]) {
        NSLog(@"init method was called");
        for (NSString *eventName in [self supportedEvents])
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emitEvent:) name:eventName object:nil];
    }
    
    return self;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"event_push_click"];
}

// Will be called when this module's first listener is added.
- (void)startObserving {
    hasListeners = YES;
    NSLog(@"startObserving method was called");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSetBridge" object:nil];
    _startObserving = true;
}

// Will be called when this module's last listener is removed, or on dealloc.
- (void)stopObserving {
     NSLog(@"stopObserving method was called");
     hasListeners = NO;
}



// Send Event Methods
- (void)emitEvent:(NSNotification *)notification {
    if (!hasListeners) {
        NSLog(@"Attempted to send an event. When no listeners were set");
        return;
    }
    [self sendEventWithName:notification.name body:notification.userInfo];
}

+ (void)sendEventWithName:(NSString *)name withBody:(NSDictionary *)body {
    if (hasListeners) {
        NSLog(@"sendEventWithName method was called");
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:body];
    }
}

// end of Send Event Methods



//Open Notification Center
RCT_EXPORT_METHOD(showNotifications:(NSString*_Nullable)dismissValue) {
    @try{
         NSLog(@"showNotifications triggered !!");
         [notifyvisitors NotifyVisitorsNotificationCentre];
        
        
        NSString *nvResourcePlistPath = [[NSBundle mainBundle] pathForResource: @"nvResourceValues" ofType: @"plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath: nvResourcePlistPath]) {
       NSDictionary *nvResourceData = [NSDictionary dictionaryWithContentsOfFile: nvResourcePlistPath];
            if ([nvResourceData count] > 0) {
       NSDictionary *nvResourceBooleans = [nvResourceData objectForKey: @"nvBooleans"];
    if ([nvResourceBooleans count] > 0) {
        
        
        if (nvResourceBooleans [@"DismissNotificationCenterOnAction"]) {
nvDismissNCenterOnAction = [nvResourceBooleans [@"DismissNotificationCenterOnAction"] boolValue];
        } else {
            nvDismissNCenterOnAction = YES;
        }
        
        
        NSLog(@"nvDismissNCenterOnAction = %@", nvDismissNCenterOnAction ? @"YES" : @"NO");
    } else {
         NSLog(@"nvResourceBooleans not found !!");
    }
            } else {
                  NSLog(@"nvResourceData not found !!");
            }
            
            
        } else {
            NSLog(@"nvResourceValues plist not found !!");
        }
        
        
        
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}


//Stop Inapp Banner serveyes
RCT_EXPORT_METHOD(stopNotifications) {
    @try{
        NSLog(@"stopNotifications triggered !!");
        [notifyvisitors DismissAllNotifyvisitorsInAppNotifications];
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}

//Stop Push Notifications
RCT_EXPORT_METHOD(stopPushNotifications:(NSString*_Nullable)strValue) {
    @try{
        BOOL value;
        NSLog(@"stopPushNotifications triggered !!");
        if(![strValue isEqual:[NSNull null]] && [strValue length]>0 ){
            if([strValue caseInsensitiveCompare:@"true"]){
                value = true;
            }else{
                value = false;
            }
            [notifyvisitors stopPushNotification:value];
        }else{
            NSLog(@"Parameter can not be null or empty!!");
        }
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}



// Show In App Banner, Alert, Serveys 
RCT_EXPORT_METHOD(show:(NSString*_Nullable)nvCustomRule  userToken:(NSString*_Nullable)nvUserToken 
    mobile:(NSString*_Nullable)dummy ){
    @try{
        NSLog(@"show triggered !!");
        NSMutableDictionary *jNvCustomRule = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *jNvUserToken = [[NSMutableDictionary alloc] init];

       if (![nvCustomRule isEqual:[NSNull null]] && [nvCustomRule length] > 0 && ![nvCustomRule isEqualToString: @""])
        {
           NSError *err = nil;
           NSData *data = [nvCustomRule dataUsingEncoding:NSUTF8StringEncoding];
           jNvCustomRule = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
           //NSLog(@"Dictionary: %@", [jNvCustomRule description]);
        }else{
           jNvCustomRule = nil;
        }

        if (![nvUserToken isEqual:[NSNull null]] && [nvUserToken length] != 0)
        {
           NSError *err = nil;
           NSData *data = [nvCustomRule dataUsingEncoding:NSUTF8StringEncoding];
           jNvUserToken = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
           //NSLog(@"Dictionary: %@", [jNvCustomRule description]);
        }else{
           jNvUserToken = nil; 
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [notifyvisitors Show:jNvCustomRule CustomRule:jNvUserToken];
        });
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}


//user identifier method
RCT_EXPORT_METHOD(userIdentifier:(NSString*_Nullable)nvUserID  UserParams:(NSString*_Nullable)nvUserParams)
 {
    @try{
        NSLog(@"userIdentifier triggered !!");
        if( [nvUserID isEqual:[NSNull null]] || [nvUserID length] == 0){
          nvUserID = nil; 
        }
        
        NSMutableDictionary *jNvUserParams = [[NSMutableDictionary alloc] init];
        if (![nvUserParams isEqual:[NSNull null]] && [nvUserParams length] != 0){
           NSError *err = nil;
           NSData *data = [nvUserParams dataUsingEncoding:NSUTF8StringEncoding];
           jNvUserParams = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
           //NSLog(@"Dictionary: %@", [jNvCustomRule description]);
        }else{
           jNvUserParams = nil; 
        }
       [notifyvisitors UserIdentifier: nvUserID UserParams: jNvUserParams];
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}

// Hit Event
RCT_EXPORT_METHOD(event:(NSString*_Nullable)eventName  Attributes:(NSString*_Nullable)attributes
                  LifeTimeValue:(NSString*_Nullable)lifeTimeValue Scope:(NSString*_Nullable)scope ) {
    @try{
        NSLog(@"event triggered !!");
        NSMutableDictionary *jAttributes = [[NSMutableDictionary alloc] init];
        int nvScope = 0;

        if([eventName isEqual:[NSNull null]] || [eventName length] == 0){
          eventName = nil;
        }

        if (![attributes isEqual:[NSNull null]] && [attributes length] != 0){
           NSError *err = nil;
           NSData *data = [attributes dataUsingEncoding:NSUTF8StringEncoding];
           jAttributes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
           //NSLog(@"Dictionary: %@", [jNvCustomRule description]);
        }else{
           jAttributes = nil; 
        }

        if([lifeTimeValue isEqual:[NSNull null]] || [lifeTimeValue length] == 0){
          lifeTimeValue = nil;
        } 


        if([scope isEqual:[NSNull null]] ){
          nvScope = 0;
        } else if([scope length] == 0){
            nvScope = 0;
        }else{
            nvScope = [scope intValue];
        }

       [notifyvisitors trackEvents:eventName Attributes:jAttributes lifetimeValue:lifeTimeValue Scope:nvScope];
       
     
        
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}

// for unread notifications in notification Center
RCT_EXPORT_METHOD(getNotificationCount:(RCTResponseSenderBlock)callback) {
    @try{
            NSLog(@"getNotificationCount triggered !!");
            [notifyvisitors GetUnreadPushNotification:^(NSInteger nvUnreadPushCount) {        
            NSString *jCount = nil;
            jCount = [@(nvUnreadPushCount) stringValue];
            callback(@[jCount, [NSNull null]]);
           }];        
    } @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        callback(@[exception.reason, [NSNull null]]);
    }
}

//for redirection method 
RCT_EXPORT_METHOD(getClickInfoCP:(NSString *)callbackName) {
    NSArray *callbacksplit = [callbackName componentsSeparatedByString:@"-"];
    @try{
        NSLog(@"getClickInfoCP triggered !!");
        nvPushObserverReady = YES;
        [[NSNotificationCenter defaultCenter] addObserverForName: @"NVInAppViewConroller" object: nil queue: nil usingBlock: ^(NSNotification *notification) {
        NSDictionary *nvUserInfo = [notification userInfo];
        if ([nvUserInfo count] > 0) {
            NSError *nvError = nil;
            NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: nvUserInfo options: NSJSONWritingPrettyPrinted error: &nvError];
            NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
            NSLog(@"getClickInfoCP = %@", notification);
            [self sendEventWithName:callbacksplit[0] body:@{@"_callbackName": callbackName, @"data":nvJsonString}];
        }else {
            //[self sendEventWithName:callbacksplit[0] body:@{@"_callbackName": callbackName, @"data":@""}];  
        }
    }];
        
    }
    @catch(NSException *exception){
        //[self sendEventWithName:callbacksplit[0] body:@{@"_callbackName": callbackName, @"data":@""}];  
        NSLog(@"getClickInfoCP Exception = %@", exception.reason);
    }
}

// stop geofence push for date and time
RCT_EXPORT_METHOD(stopGeofencePushforDateTime:(NSString*_Nullable)nvDateTime  AdditionalHours:(NSString*_Nullable)additionalHours) {
    @try{
         NSLog(@"stopGeofencePushforDateTime triggered !!");
         NSInteger nvAdditionalHours = 0;
         
         if ([nvDateTime isEqual:[NSNull null]] || [nvDateTime length] == 0){
              nvDateTime = nil;     
         }

        if ([additionalHours isEqual:[NSNull null]] || [additionalHours length] == 0){
              nvAdditionalHours = 0;     
         }else{
             nvAdditionalHours  = [additionalHours intValue];
         }

        [notifyvisitors stopGeofencePushforDateTime: nvDateTime additionalHours: nvAdditionalHours];
        
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}


// Get notificvation Center data
RCT_EXPORT_METHOD(getNotificationDataListener:(RCTResponseSenderBlock)callback) {
    @try{
        NSLog(@"getNotificationDataListener triggered !!");
        [notifyvisitors GetNotificationCentreData:^(NSMutableArray * nvNotificationCenterData) {
        //NSLog(@"Neeraj nvNotificationCenterData=  %@", nvNotificationCenterData);
         if([nvNotificationCenterData count] > 0){
             NSError *nvError = nil;
             NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: nvNotificationCenterData options:NSJSONWritingPrettyPrinted error: &nvError];
             NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
             callback(@[nvJsonString, [NSNull null]]);
         }else{
             callback(@[@"No Notification Found", [NSNull null]]);
         }
        }];                
         
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        callback(@[exception.reason, [NSNull null]]);
    }
}


//for ios only
RCT_EXPORT_METHOD(scrollViewDidScroll_iOS_only) {
    @try{
        NSLog(@"scrollViewDidScroll_iOS_only triggered !!");
        UIScrollView *nvScrollview;
        [notifyvisitors scrollViewDidScroll: nvScrollview];
    }
    @catch(NSException *exception){
        NSLog(@"%@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}


// -(NSArray<NSString *> *)supportedEvents {
//     NSMutableArray *events = [NSMutableArray new];
    
//     for (int i = 0; i < OSNotificationEventTypesArray.count; i++)
//         [events addObject:OSEventString(i)];
    
//     return events;
// }


@end
