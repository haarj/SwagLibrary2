//
//  ViewController.m
//  Swag Library 2
//
//  Created by Justin Haar on 9/30/15.
//  Copyright © 2015 Justin Haar. All rights reserved.
//

#import "BookListVC.h"
#import "Contants.h"   
#import "BookDetailVC.h"

@interface BookListVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BookListVC

- (void)viewDidLoad {
    [super viewDidLoad];



}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellid];
    cell.textLabel.text = @"Test";
    cell.detailTextLabel.text = @"detail";
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BookDetailVC *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"bookdetail"];

    
    [self showViewController:detailVC sender:self];

}



@end
