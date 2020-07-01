#if __has_include(<notifyvisitors/notifyvisitors.h>)
#import <notifyvisitors/notifyvisitors.h>
#else
#import "../notifyvisitors.h"
#endif

#import "RNNotifyvisitorExtensionService.h"


@implementation RNNotifyvisitorExtensionService

+(void)LoadAttachmentWithRequest:(UNNotificationRequest *)request BestAttemptContent: (UNMutableNotificationContent *)bestAttemptContent
              withContentHandler: (void (^)(UNNotificationContent * _Nonnull))contentHandler{
    @try{
[notifyvisitors LoadAttachmentWithRequest: request bestAttemptContent: bestAttemptContent withContentHandler: contentHandler];
   
    }
    
    @catch(NSException *exception){
    
NSLog(@"LoadAttachmentWithRequest exception error = %@", exception.reason);
        //callback(@[exception.reason, [NSNull null]]);
    }
}
@end
