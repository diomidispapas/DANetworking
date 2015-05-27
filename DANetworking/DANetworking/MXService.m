//
//  MXService.m
//  DANetworking
//
//  Created by Diomidis Papas on 25/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "MXService.h"

@interface MXService ()
@property (nonatomic, strong, nonnull) NSURLSession *session;
@end


@implementation MXService


#pragma mark -Shared Instance

+ (instancetype)sharedInstance {
    static MXService *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MXService alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.session = [[NSURLSession alloc] init];
    }
    return self;
}

- (void)taskForGETMethod:(NSString *)method
              parameters:(NSDictionary *)parameters
       completionHandler:(void(^)(id result, NSError* error))completionHandler {
    
}

- (void)taskForPOSTMethod:(NSString *)method
               parameters:(NSDictionary *)parameters
        completionHandler:(void(^)(id result, NSError* error))completionHandler {
    
}
@end
