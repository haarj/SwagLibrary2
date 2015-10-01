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
#import "Book.h"

@interface BookListVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)  NSMutableArray *books;

@end

@implementation BookListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [Book getBooksWithBlock:^(NSArray *array) {
        self.books = [array mutableCopy];
    }];
//    self.books = [Book getBooks];


}

-(void)setBooks:(NSMutableArray *)books
{
    _books = books;
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellid];
    Book *book = self.books[indexPath.row];
    cell.textLabel.text = book.title.description;
    cell.detailTextLabel.text = book.author.description;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BookDetailVC *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"bookdetail"];

    Book *book = self.books[indexPath.row];

    detailVC.book = book;
    
    [self showViewController:detailVC sender:self];

}



@end
