//
//  OCTRepository+MRCPersistence.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 15/1/10.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import <OctoKit/OctoKit.h>
#import "MRCPersistenceProtocol.h"

@interface OCTRepository (MRCPersistence) <MRCPersistenceProtocol>

@property (assign, nonatomic) BOOL isStarred;

- (BOOL)mrc_update;

// Retrieves the repositories of the current `user` from disk.
//
// Returns the repositories.
+ (NSArray *)mrc_fetchUserRepositories;

// Retrieves the starred repositories of the current `user` from disk.
//
// Returns the starred repositories.
+ (NSArray *)mrc_fetchUserStarredRepositories;

+ (BOOL)mrc_saveOrUpdateUserRepositories:(NSArray *)repositories;

+ (BOOL)mrc_saveOrUpdateUserStarredRepositories:(NSArray *)repositories;

- (BOOL)mrc_hasUserStarred;

- (BOOL)mrc_starRepository;

- (BOOL)mrc_unstarRepository;

+ (BOOL)mrc_deleteRepositoryWithId:(NSString *)id isStarred:(BOOL)isStarred;

@end
