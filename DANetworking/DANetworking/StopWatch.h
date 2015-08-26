//
//  StopWatch.h
//  DANetworking
//
//  Created by Diomidis Papas on 11/08/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StopWatch : NSObject
{
    uint64_t _start;
    uint64_t _stop;
    uint64_t _elapsed;
}

- (void)start;
- (void)stop;
- (void)stopWithContext:(NSString*) context;
- (double) seconds;
- (NSString*) description;

@end
