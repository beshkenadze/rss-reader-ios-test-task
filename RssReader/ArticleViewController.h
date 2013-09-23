//
//  ArticleViewController.h
//  RssReader
//
//  Created by developer on 23.09.13.
//  Copyright (c) 2013 developer. All rights reserved.
//

#import "Feed.h"


@interface ArticleViewController : UITableViewController
@property (retain,nonatomic, readwrite) Feed *feed;
@end
