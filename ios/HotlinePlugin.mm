#import "HotlinePlugin.h"

@interface HotlinePlugin()
@property NSInteger unread_count;
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

    [[Hotline sharedInstance] initWithConfig:config];
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
  [[Hotline sharedInstance] clearUserData];
}

- (void) showConversations: (NSDictionary *)jsonObject {
  [[Hotline sharedInstance] showConversations:self.viewController];
}

- (void) showFAQs: (NSDictionary *)jsonObject {
  [[Hotline sharedInstance] showFAQs:self.viewController];
}

- (void) getUnreadCountAsync: (NSDictionary *)jsonObject {
  NSInteger unread_count = 0;

  @try {
    unread_count = [[Hotline sharedInstance] getUnreadMessagesCount];
    [[PluginManager get] dispatchJSEvent:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"hotlineUnreadCount", @"name",
                          [NSString stringWithFormat: @"%ld", unread_count], @"count",
                          nil]];
  }
  @catch (NSException *exception) {
    NSLOG(@"{hotline} Failure to get: %@", exception);
  }
}
@end
