//
//  MTResultsViewController.m
//  MiniTip
//
//  Created by IFAN CHU on 11/29/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "MTResultsViewController.h"
#import "MTResultItemStore.h"
#import "MTResultItem.h"
#import "MTDetailsViewController.h"

@interface MTResultsViewController ()

@end

@implementation MTResultsViewController

- (id)init
{
    self = [super init];
    if (self) {
        // do nothing
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self resultTableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTResultItem *p = [[[MTResultItemStore defaultStore] allPersons] objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ResultTableCell"];
    [[cell textLabel] setText:[p getName]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"$%.2f", [p totalForName]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MTResultItemStore defaultStore] allPersons] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTResultItem *p = [[[MTResultItemStore defaultStore] allPersons] objectAtIndex:[indexPath row]];
    MTDetailsViewController *dvc = [[MTDetailsViewController alloc] initWithResultItem:p];
    
    [[self navigationController] pushViewController:dvc animated:YES];
}

@end
