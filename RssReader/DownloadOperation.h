//
//  DownloadOperation.h
//  RssReader
//
//  Created by developer on 23.09.13.
//  Copyright (c) 2013 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadOperation : NSOperation <NSXMLParserDelegate>
@property (retain, nonatomic, readwrite) NSString *feedUrl;
@property (retain, nonatomic, readwrite) NSManagedObjectContext *context;

@end
