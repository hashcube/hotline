#import "HotlinePlugin.h"

@interface HotlinePlugin()
@property (nonatomic, retain) NSData *deviceToken;
@property (nonatomic) BOOL initDone;
@end

@implementation HotlinePlugin


// The plugin must call super dealloc.
- (void) dealloc {
  [self.deviceToken release];
  [super dealloc];
}

// The plugin must call super init.
- (id) init {
  if(self = [super init]) {
    self.initDone = NO;
    self.deviceToken = nil;
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
    config.voiceMessagingEnabled = YES;
    config.pictureMessagingEnabled = YES;
    config.showNotificationBanner = YES;
    config.agentAvatarEnabled = YES;

    [[Hotline sharedInstance] initWithConfig:config];
    self.initDone = YES;
  }
  @catch (NSException *exception) {
    NSLOG(@"{hotline} Failure to get: %@", exception);
  }
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
  NSLOG(@"{hotline}: get unread count");
  [[Hotline sharedInstance]unreadCountWithCompletion:^(NSInteger count) {
      NSLOG(@"{hotline}: Unread count (Async) : %d", (int)count);
      [[PluginManager get] dispatchJSEvent:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"hotlineUnreadCount", @"name",
                            [NSString stringWithFormat: @"%ld", count], @"count",
                            nil]];
  }];
}

- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken application:(UIApplication *)app {
  if(self.initDone && (self.deviceToken == nil)) {
    self.deviceToken = deviceToken;
    [[Hotline sharedInstance] updateDeviceToken:deviceToken];
  }
}

- (void) didReceiveRemoteNotification:(NSDictionary *)userInfo application:(UIApplication *)app {
  if ([[Hotline sharedInstance]isHotlineNotification:userInfo]) {
    [[Hotline sharedInstance]handleRemoteNotification:userInfo andAppstate:app.applicationState];
  }
}
@end
