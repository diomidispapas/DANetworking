//
//  DANetwork+Messages.h
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DANetwork.h"

@interface DANetwork (Messages)

- (void)sendJoiningMessageWithCompletionBlock:(void(^)(BOOL sucess, NSError *error))completion;

@end
