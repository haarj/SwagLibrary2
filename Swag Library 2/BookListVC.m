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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;

@end

@implementation BookListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Swag Library";

}

-(void)viewWillAppear:(BOOL)animated
{
    [Book getBooksWithBlock:^(NSArray *array) {
        self.books = [array mutableCopy];

        if (self.books.count > 0) {
            self.trashButton.enabled = YES;
        }else
        {
            self.trashButton.enabled = NO;
        }
    }];

    self.tableView.editing = NO;
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

    [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
    cell.imageView.image = [UIImage imageNamed:@"Bookshelf"];
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = cell.imageView.layer.frame.size.height/2;
    cell.imageView.layer.borderWidth = 1;
    cell.imageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;

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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing == YES) {
        return  UITableViewCellEditingStyleDelete;
    }else
    {
        return UITableViewCellEditingStyleNone;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Book *book = self.books[indexPath.row];
        [self.books removeObject:book];
        self.tableView.editing = NO;
        [self.tableView reloadData];

        [Book deleteBook:book];
    }
}

- (IBAction)trashButtonTapped:(UIBarButtonItem *)sender
{
    [self deleteAllBooksAlert];
}

- (IBAction)editButtonTapped:(UIBarButtonItem *)sender {

    self.tableView.editing = !self.tableView.editing;
}

-(void)deleteAllBooksAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Book(s)?" message:@"Choosing Yes will delete all books!" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [Book deleteAllBooks];
        [self.books removeAllObjects];
        [self.tableView reloadData];

    }];

    [alert addAction:no];
    [alert addAction:yes];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
