//
//  JasonettePlugin.h
//  Pods
//
//  Created by Stefan Eletzhofer on 19.11.16.
//
//

#ifndef JasonettePlugin_h
#define JasonettePlugin_h

#import <MicrosoftAzureMobile/MicrosoftAzureMobile.h>

@interface AzurePluginBase : NSObject

@property (nonatomic, retain) MSClient      *client;
@property (nonatomic, retain) NSDictionary  *settings;

+ (id)sharedInstance;

-(void)error;

-(void)success;

-(void)error:(NSDictionary *)info;

-(void)success:(NSDictionary *)info;

-(NSDictionary *)optionsFromNotification:(NSNotification *)notification;

@end


#endif /* JasonettePlugin_h */
