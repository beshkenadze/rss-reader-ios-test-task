//
//  ArticleViewController.m
//  RssReader
//
//  Created by developer on 23.09.13.
//  Copyright (c) 2013 developer. All rights reserved.
//

#import "ArticleViewController.h"
#import "Mediator.h"
#import "Article.h"

@interface ArticleViewController ()
{
    NSArray *_articles;
}
@end

@implementation ArticleViewController
@synthesize feed = _feed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData];
}

- (void)reloadData
{
    NSManagedObjectContext *context = [[Mediator sharedMediator] context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"feed == %@", _feed];
//    [request setPredicate:predicate];
    
    NSError *error;
    _articles = [[context executeFetchRequest:request error:&error] retain];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    }
        NSLog(@"articles Count : %d",[indexPath row]);
    cell.textLabel.text = ((Article *)[_articles objectAtIndex:[indexPath row]]).name;
    
    return cell;
}

@end
