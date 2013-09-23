//
//  Downlader.m
//  RssReader
//
//  Created by developer on 23.09.13.
//  Copyright (c) 2013 developer. All rights reserved.
//

#import "Mediator.h"
#import "DownloadOperation.h"

#import <CoreData/CoreData.h>

@interface Mediator ()
@property (nonatomic, retain,readonly) NSOperationQueue *operationQueue;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation Mediator
@synthesize operationQueue = _operationQueue;
@synthesize context = _context;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedMediator
{
    static Mediator *mediator;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        mediator = [[self alloc] init];
    });
    
    return mediator;
}

- (void)dealloc
{
    if (_operationQueue != nil)
    {
        [_operationQueue release];
    }
    
    if (_context != nil)
    {
        [_context release];
    }
    
    [super dealloc];
}

- (void)downloadAllKnownFeedsCompletion:(void(^)())completion
{
    [self addFeedWithFeedURL:@"http://images.apple.com/main/rss/hotnews/hotnews.rss" completion:completion];
}

- (void)addFeedWithFeedURL:(NSString *)url completion:(void(^)())completion
{
    dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    dispatch_async(queue, ^{
        NSOperationQueue *operationQueue = self.operationQueue;
        
        DownloadOperation *operation = [DownloadOperation new];
        operation.feedUrl = url;
        operation.context = self.context;
        
        [operationQueue addOperation:operation];
        if ([NSThread isMainThread])
        {
            NSLog(@"main");
        }
        [operationQueue waitUntilAllOperationsAreFinished];
        completion();
    });
}


#pragma mark - 
#pragma mark private

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil)
    {
        _operationQueue = [NSOperationQueue new];
    }
    return _operationQueue;
}

- (NSManagedObjectContext *)context
{
    if (_context != nil) {
        return _context;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:coordinator];
    }
    return _context;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RssReader" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RssReader.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end

