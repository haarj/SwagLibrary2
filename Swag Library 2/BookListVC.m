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
#import "BookListVCCell.h"
#import "Swag Library 2-Bridging-Header.h"
#import <Swag_Library_2-Swift.h>

@interface BookListVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)  NSMutableArray *books;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property UIRefreshControl *refreshControl;


@end

@implementation BookListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Swag Library";
    self.view.backgroundColor = [UIColor yellowColor];

    //Add refresh control at tableView[0]
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    self.refreshControl.backgroundColor = [UIColor blueColor];

    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView setContentOffset:CGPointMake(0, -60) animated:YES];
    self.tableView.alwaysBounceVertical = YES;

    //Only show once
    [self.refreshControl beginRefreshing];

}

-(void)viewDidAppear:(BOOL)animated
{
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    indicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
//
//    indicator.hidden = NO;
//    indicator.color = [UIColor blueColor];
//    indicator.hidesWhenStopped = YES;
//
//    [self.view addSubview:indicator];
//
//    [indicator startAnimating];

    [self handleRefresh];

    self.tableView.editing = NO;
}

-(void)setBooks:(NSMutableArray *)books
{
    _books = books;
    [self.tableView reloadData];
}

#pragma mark - TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookListVCCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellid];
    //Array has book objects
    if ([self.books[0] isKindOfClass:[Book class]]) {


        Book *book = self.books[indexPath.row];

        //Set label UI
        cell.label.font = [UIFont systemFontOfSize:16];
        cell.label.textColor = [UIColor blueColor];
        cell.label.alpha = 0.4;
        cell.label.numberOfLines = 0;
        cell.label.lineBreakMode = NSLineBreakByWordWrapping;
        cell.label.text = [NSString stringWithFormat:@"%@\n%@", book.title, book.author];

        //Set imageView UI
        cell.imageView.image = [UIImage imageNamed:@"Bookshelf"];
        cell.imageView.clipsToBounds = YES;
        cell.imageView.layer.cornerRadius = 20;
//        cell.imageView.layer.borderWidth = 1;
//        cell.imageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }else
    {
        cell.label.text = nil;
        cell.imageView.image = nil;
    }

    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

//Go to BookDetailVC
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BookDetailVC2 *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"bookdetail"];

    Book *book = self.books[indexPath.row];
    detailVC.book = book;
    
    [self showViewController:detailVC sender:self];

}

//Set Edting style
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}

//Allows user to swipe cell left
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Delete book from array, tableview, and server
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Book *book = self.books[indexPath.row];
        [self.books removeObject:book];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.tableView.editing = NO;

        [Book deleteBook:book];
    }
}

#pragma mark - Button Methods

//Get Trash alert
- (IBAction)trashButtonTapped:(UIBarButtonItem *)sender
{
    [self deleteAllBooksAlert];
}

//- (IBAction)editButtonTapped:(UIBarButtonItem *)sender {
//
//    self.tableView.editing = !self.tableView.editing;
//}

#pragma mark - Helper Methods

//Delete from server, array, and reload tableview
-(void)deleteAllBooksAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Book(s)?" message:@"Choosing Yes will delete all books!" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        [Book deleteAllBooks];
        [self.books removeAllObjects];
        [self.tableView reloadData];
        self.trashButton.enabled = NO;
        self.editButton.enabled = NO;

    }];

    [alert addAction:no];
    [alert addAction:yes];

    [self presentViewController:alert animated:YES completion:nil];
}

//Get books from server
-(void)handleRefresh
{

    [Book getBooksWithBlock:^(NSArray *array) {
        self.books = [array mutableCopy];

        if (array.count>0) {

            //If array contains an error
            if ([array[0] isKindOfClass:[NSError class]])
            {
                [self getErrorAlert];
                self.trashButton.enabled = NO;
                self.editButton.enabled = NO;

            //Iff array contains books
            }else if ([array[0] isKindOfClass:[Book class]])
            {

                self.books = [array mutableCopy];
                self.trashButton.enabled = YES;
                self.editButton.enabled = YES;
            }
        }else
        {
            self.trashButton.enabled = NO;
            self.editButton.enabled = NO;
        }

        [self.refreshControl endRefreshing];
    }];

}

//NSError from server alert
-(void)getErrorAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error connecting to the server" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];


    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
