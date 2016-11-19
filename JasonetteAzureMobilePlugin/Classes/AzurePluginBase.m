//
//  AzurePluginBase.m
//  Pods
//
//  Created by Stefan Eletzhofer on 19.11.16.
//
//

#import <Foundation/Foundation.h>
#import <MicrosoftAzureMobile/MicrosoftAzureMobile.h>

#import "AzurePluginBase.h"

@implementation AzurePluginBase

@synthesize client;
@synthesize settings;

#pragma mark Singleton Methods

+ (id)sharedInstance {
    static AzurePluginBase *sharedInstance = nil;
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

@end
