#import "HotlinePlugin.h"

@interface HotlinePlugin()
@end

@implementation HotlinePlugin

// The plugin must call super dealloc.
- (void) dealloc {
  [super dealloc];
}

// The plugin must call super init.
- (id) init {
  self = [super init];
  if (!self) {
    return nil;
  }

  return self;
}

- (void) initializeWithManifest:(NSDictionary *)manifest appDelegate:(TeaLeafAppDelegate *)appDelegate {
  @try {
    NSDictionary *ios = [manifest valueForKey:@"ios"];
    NSString *appID = [ios valueForKey:@"hotlineAppID"];
    NSString *appKey = [ios valueForKey:@"hotlineAppKey"];

    self.viewController = appDelegate.tealeafViewController;

    HotlineConfig *config = [[HotlineConfig alloc]initWithAppID:appID andAppKey:appKey];
    config.voiceMessagingEnabled = [self isBeforeiOS10];
    config.pictureMessagingEnabled = [self isBeforeiOS10];
    config.showNotificationBanner = YES;
    config.agentAvatarEnabled = YES;

    [[Hotline sharedInstance] initWithConfig:config];
  }
  @catch (NSException *exception) {
    NSLOG(@"{hotline} Failure to get: %@", exception);
  }
}

- (BOOL)isBeforeiOS10 {
  return [[[UIDevice currentDevice] systemVersion] floatValue] < 10.0 ;
}

- (void) setName: (NSDictionary *)jsonObject {
  HotlineUser *user = [HotlineUser sharedInstance];

  user.name = [jsonObject objectForKey:@"name"];
  [[Hotline sharedInstance] updateUser:user];
}

- (void) setEmail: (NSDictionary *)jsonObject {
  HotlineUser *user = [HotlineUser sharedInstance];

  user.email = [jsonObject objectForKey:@"email"];
  [[Hotline sharedInstance] updateUser:user];
}

- (void) setExternalId: (NSDictionary *)jsonObject {
  HotlineUser *user = [HotlineUser sharedInstance];

  user.externalID = [jsonObject objectForKey:@"id"];
  [[Hotline sharedInstance] updateUser:user];
}

- (void) addMetaData: (NSDictionary *)jsonObject {
  [[Hotline sharedInstance]
    updateUserPropertyforKey:[jsonObject objectForKey:@"field_name"]
    withValue:[jsonObject objectForKey:@"value"]];
}

- (void) clearUserData: (NSDictionary *)jsonObject {
  [[Hotline sharedInstance] clearUserDataWithCompletion:nil];
}

- (void) showConversations: (NSDictionary *)jsonObject {
  [[Hotline sharedInstance] showConversations:self.viewController];
}

- (void) showFAQs: (NSDictionary *)jsonObject {
  FAQOptions *options = [FAQOptions new];

  options.showContactUsOnFaqScreens = YES;
  options.showContactUsOnAppBar = YES;
  [[Hotline sharedInstance] showFAQs:self.viewController withOptions:options];
}

- (void) getUnreadCountAsync: (NSDictionary *)jsonObject {
  [[Hotline sharedInstance]unreadCountWithCompletion:^(NSInteger count) {
      NSLog(@"Unread count (Async) : %d", (int)count);
      [[PluginManager get] dispatchJSEvent:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"hotlineUnreadCount", @"name",
                            [NSString stringWithFormat: @"%ld", count], @"count",
                            nil]];
  }];
}
@end
