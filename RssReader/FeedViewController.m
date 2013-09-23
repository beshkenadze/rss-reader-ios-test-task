//
//  FeedViewController.m
//  RssReader
//
//  Created by developer on 23.09.13.
//  Copyright (c) 2013 developer. All rights reserved.
//

#import "FeedViewController.h"
#import "Mediator.h"
#import "Feed.h"
#import "ArticleViewController.h"


@interface FeedViewController ()
{
    NSArray *_feeds;
}

@end

@implementation FeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)reloadData
{
    NSManagedObjectContext *context = [[Mediator sharedMediator] context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feed" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    NSError *error;
    _feeds = [[context executeFetchRequest:request error:&error] retain];
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    


    [[Mediator sharedMediator] addFeedWithFeedURL:@"http://images.apple.com/main/rss/hotnews/hotnews.rss" completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
    
    cell.textLabel.text = ((Feed *)[_feeds objectAtIndex:[indexPath row]]).url;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleViewController *articleController = [ArticleViewController new];
    articleController.feed = [_feeds objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:articleController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
