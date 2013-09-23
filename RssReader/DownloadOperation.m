//
//  DownloadOperation.m
//  RssReader
//
//  Created by developer on 23.09.13.
//  Copyright (c) 2013 developer. All rights reserved.
//

#import "DownloadOperation.h"

#import "Feed.h"
#import "Article.h"

#import <CoreData/CoreData.h>


#define cclear(obj){ if(obj != nil){[obj release]; obj = nil;} }


@interface DownloadOperation ()
{
    NSXMLParser *parser;
    NSString *element;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableArray *articles;
}
@end



@implementation DownloadOperation
@synthesize feedUrl = _feedUrl;
@synthesize context = _context;

- (void)main
{
    NSLog(@"URL : %@",_feedUrl);
    articles = [NSMutableArray new];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:_feedUrl]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    

    
    if ([element isEqualToString:@"item"])
    {
//        cclear(item);
//        cclear(title);
//        cclear(link);
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"])
    {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        
        [articles addObject:[item copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"])
    {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"])
    {
        [link appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"%@",articles);
    NSEntityDescription *feedEntity = [NSEntityDescription
                                           entityForName:@"Feed"
                                           inManagedObjectContext:_context];
    NSEntityDescription *articleEntity = [NSEntityDescription
                                           entityForName:@"Article"
                                           inManagedObjectContext:_context];

    Feed *feed = [[Feed alloc]
                                    initWithEntity:feedEntity
                                    insertIntoManagedObjectContext:self.context];
    feed.name = @"Wait for";
    feed.url = _feedUrl;

    
    [articles enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        Article *article = [[Article alloc]
                            initWithEntity:articleEntity
                            insertIntoManagedObjectContext:self.context];
        article.name = [dict objectForKey:@"title"];
        article.url = [dict objectForKey:@"link"];
    }];
    NSError *error = nil;
    if ([self.context save:&error])
    {
        NSLog(@"SAVE!!!");
    }
    else
    {
        NSLog(@"Error : %@",error);
    }
}

- (void)dealloc
{
    self.feedUrl = nil;
    cclear(item);
    cclear(link);
    cclear(parser);
    cclear(articles);
    
    [super dealloc];
}
@end

