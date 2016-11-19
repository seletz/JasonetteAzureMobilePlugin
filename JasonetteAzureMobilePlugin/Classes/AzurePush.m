//
//  JasonAzureAction.m
//  Jasonette
//
//  Copyright © 2016 seletz. All rights reserved.
//

#import <MicrosoftAzureMobile/MicrosoftAzureMobile.h>

#include "AzurePluginBase.h"

@interface AzurePush : AzurePluginBase
@end

@implementation AzurePush : AzurePluginBase


- (id)init {
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(registerDeviceToken:)
         name:@"AzurePush.registerDeviceToken"
         object:nil];

    }
    return self;
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
        
        [self.client.push registerDeviceToken:token completion:^(NSError *error) {
            if (error) {
                [self error: @{@"error": error}];
            } else {
                [self success];
            }
        }];
        
    }
}

@end
