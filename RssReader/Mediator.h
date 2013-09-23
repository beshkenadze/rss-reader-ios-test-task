//
//  Downlader.h
//  RssReader
//
//  Created by developer on 23.09.13.
//  Copyright (c) 2013 developer. All rights reserved.
//



@interface Mediator : NSObject
@property (nonatomic, retain, readonly) NSManagedObjectContext *context;

- (void)downloadAllKnownFeedsCompletion:(void(^)())completion;
- (void)addFeedWithFeedURL:(NSString *)url completion:(void(^)())completion;

+ (id)sharedMediator;

@end
