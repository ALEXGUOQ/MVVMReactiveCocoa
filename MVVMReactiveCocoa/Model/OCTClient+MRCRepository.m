//
//  OCTClient+MRCRepository.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 15/5/14.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import "OCTClient+MRCRepository.h"

@implementation OCTClient (MRCRepository)

- (RACSignal *)mrc_starRepository:(OCTRepository *)repository {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([repository mrc_starRepository]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MRCStarredReposDidChangeNotification object:nil];
        }
    });
    return [self starRepository:repository];
}

- (RACSignal *)mrc_unstarRepository:(OCTRepository *)repository {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([repository mrc_unstarRepository]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MRCStarredReposDidChangeNotification object:nil];
        }
    });
    return [self unstarRepository:repository];
}

@end
