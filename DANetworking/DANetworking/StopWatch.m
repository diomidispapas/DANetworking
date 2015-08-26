//
//  StopWatch.m
//  DANetworking
//
//  Created by Diomidis Papas on 11/08/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "StopWatch.h"
#include <mach/mach_time.h>

@implementation StopWatch

- (void)start {
    _stop = 0;
    _elapsed = 0;
    _start = mach_absolute_time();
}

- (void)stop {
    _stop = mach_absolute_time();
    if(_stop > _start)
    {
        _elapsed = _stop - _start;
    }
    else
    {
        _elapsed = 0;
    }
    _start = mach_absolute_time();
}

- (void)stopWithContext:(NSString*) context {
    _stop = mach_absolute_time();
    if(_stop > _start)
    {
        _elapsed = _stop - _start;
    }
    else
    {
        _elapsed = 0;
    }
    NSLog([NSString stringWithFormat:@"[%@] Stopped at %f",context,[self seconds]]);
    
    _start = mach_absolute_time();
}

- (double)seconds {
    if(_elapsed > 0)
    {
        uint64_t elapsedTimeNano = 0;
        
        mach_timebase_info_data_t timeBaseInfo;
        mach_timebase_info(&timeBaseInfo);
        elapsedTimeNano = _elapsed * timeBaseInfo.numer / timeBaseInfo.denom;
        double elapsedSeconds = elapsedTimeNano * 1.0E-9;
        return elapsedSeconds;
    }
    return 0.0;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%f secs.",[self seconds]];
}

@end
