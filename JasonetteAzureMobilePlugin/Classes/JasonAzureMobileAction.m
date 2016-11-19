//
//  JasonAzureAction.m
//  Jasonette
//
//  Copyright © 2016 seletz. All rights reserved.
//

#import <MicrosoftAzureMobile/MicrosoftAzureMobile.h>


@interface JasonAzuremobileAction : NSObject

@property (nonatomic, retain) MSClient      *client;
@property (nonatomic, retain) NSDictionary  *settings;

+ (id)sharedInstance;

@end


@implementation JasonAzuremobileAction

@synthesize client;
@synthesize settings;

#pragma mark Singleton Methods

+ (id)sharedInstance {
    static JasonAzuremobileAction *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        NSURL *file = [[NSBundle mainBundle] URLForResource:@"settings" withExtension:@"plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:file];
        settings = plist[@"azure"];
        
        if (!settings) {
            NSLog(@"Unable to initialise Azure Services -- no azure settings.");
            return nil;
        }
        
        // Azure Mobile Services
        NSString *app_url = settings[@"app_url"];
        if (app_url) {
            NSLog(@"Azure Mobile App URL: %@", app_url);
            client = [MSClient clientWithApplicationURLString: app_url];
        }
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(query:)
         name:@"AzureTables.query"
         object:nil];

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(insert:)
         name:@"AzureTables.insert"
         object:nil];

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(registerDeviceToken:)
         name:@"AzurePush.registerDeviceToken"
         object:nil];

    }
    return self;
}

#pragma mark -- helpers
-(void)error {
    [self error:nil];
}

-(void)success {
    [self success:nil];
}

-(void)error:(NSDictionary *)info {
    
}

-(void)success:(NSDictionary *)info {
    
}

-(NSDictionary *)optionsFromNotification:(NSNotification *)notification {
    NSDictionary *args = notification.userInfo;
    return args[@"options"];
}

#pragma mark -- Azure Mobile Table Actions

/**
 Query a table and return results.  Optionally pass a query string.
 
 Example:
 
     "type": "$AzureMobile.query",
        "options": {
            "table": "todoitem",
            "query": "complete == NO"
        },
        "success": {
            "type": "$log.debug",
            "options": {
                "text": "SUCCESS"
            }
        },
     }

 */
-(void)query:(NSNotification *)notification {
    NSDictionary *options = [self optionsFromNotification:notification];

    if (options) {
        NSString *table_name = options[@"table"];
        NSString *query_string = options[@"query"];
        
        if (!client) {
            NSLog(@"Error: azure client not initialised.");
            [self error:nil];
            return;
        }
        
        if (!table_name) {
            NSLog(@"Error: AzureMobile: insert: no table.");
            [self error:nil];
            return;
        }
        
        MSTable *table = [client tableWithName: table_name];
        
        if (query_string) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:query_string];
            [table readWithPredicate:predicate
                          completion:^(MSQueryResult *result, NSError *error) {
                              if(error) {
                                  NSLog(@"ERROR %@", error);
                                  [self error];
                                  return;
                              }
                              
                              [self success:@{@"count": [NSNumber numberWithLong: result.totalCount], @"items": result.items}];
                              
                          }];
        } else {
            [table readWithCompletion:^(MSQueryResult *result, NSError *error) {
                if(error) {
                    NSLog(@"ERROR %@", error);
                    [self error];
                    return;
                }
                
                [self success:@{@"count": [NSNumber numberWithLong: result.totalCount], @"items": result.items}];
                
            }];
            
        }
    }
    
    
}

-(void)insert:(NSNotification *)notification {
    NSDictionary *options = [self optionsFromNotification:notification];

    if (options) {
        NSString *table_name = options[@"table"];
        NSDictionary *data = options[@"data"];
        
        if (!table_name) {
            NSLog(@"Error: AzureMobile: insert: no table.");
            [self error];
            return;
        }
        
        if (!data) {
            NSLog(@"Error: AzureMobile: insert: no data.");
            [self error];
            return;
        }
        
        if (!client) {
            NSLog(@"Error: azure client not initialised.");
            [self error];
            return;
        }
        
        MSTable *table = [client tableWithName: table_name];
        [table insert:data completion:^(NSDictionary *insertedItem, NSError *error) {
            if (error) {
                NSLog(@"Error: AzureMobile: insert: %@", error);
                [self error];
                
            } else {
                NSLog(@"AzureMobile: Item inserted, id: %@", [insertedItem objectForKey:@"id"]);
                [self success:insertedItem];
            }
        }];
    }
    [self success];
    
}

-(void)delete:(NSNotification *)notification {
    NSDictionary *options = [self optionsFromNotification:notification];
    [self error:@{@"error": @"Sorry, not yet implemented."}];
}

#pragma mark -- APNS Push Related

-(void)registerDeviceToken:(NSNotification *)notification {
    NSDictionary *options = [self optionsFromNotification:notification];

    if (options) {
        NSData *token = options[@"device_token"];
        if (!token) {
            NSLog(@"Error: AzureMobile: registerDeviceToken: no token.");
            [self error];
            return;
        }
        
        [client.push registerDeviceToken:token completion:^(NSError *error) {
            if (error) {
                [self error: error];
            } else {
                [self success];
            }
        }];
        
    }
}

@end
