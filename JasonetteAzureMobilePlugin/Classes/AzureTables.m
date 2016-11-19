//
//  JasonAzureAction.m
//  Jasonette
//
//  Copyright © 2016 seletz. All rights reserved.
//

#import <MicrosoftAzureMobile/MicrosoftAzureMobile.h>

#include "AzurePluginBase.h"

@interface AzureTables : AzurePluginBase
@end

@implementation AzureTables : AzurePluginBase


- (id)init {
    if (self = [super init]) {
        
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

    }
    return self;
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
        
        if (!self.client) {
            NSLog(@"Error: azure client not initialised.");
            [self error:nil];
            return;
        }
        
        if (!table_name) {
            NSLog(@"Error: AzureMobile: insert: no table.");
            [self error:nil];
            return;
        }
        
        MSTable *table = [self.client tableWithName: table_name];
        
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
        
        if (!self.client) {
            NSLog(@"Error: azure client not initialised.");
            [self error];
            return;
        }
        
        MSTable *table = [self.client tableWithName: table_name];
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
        
        [self.client.push registerDeviceToken:token completion:^(NSError *error) {
            if (error) {
                [self error:@{@"error":error}];
            } else {
                [self success];
            }
        }];
        
    }
}

@end
