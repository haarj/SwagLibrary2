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

    self.title = @"Swag Library";

    [Book getBooksWithBlock:^(NSArray *array) {
        self.books = [array mutableCopy];
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
//    [Book getBooksWithBlock:^(NSArray *array) {
//        self.books = [array mutableCopy];
//    }];

//    self.books = [Book getBooks];

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
//        [self deleteBook:book];

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

//        [self deleteAllBooks];
        [Book deleteAllBooks];
        [self viewWillAppear:YES];
        [self.tableView reloadData];

    }];

    [alert addAction:no];
    [alert addAction:yes];

    [self presentViewController:alert animated:YES completion:nil];
    
}

//-(void)deleteAllBooks
//{
//    NSMutableURLRequest *request = [NSMutableURLRequest new];
//    [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/560b7c9763600c00097c4a84/clean"]];
//    [request setHTTPMethod:@"DELETE"];
////    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//
//    if(conn) {
//        NSLog(@"Connection Successful:%@", conn);
//    } else {
//        NSLog(@"Connection could not be made");
//    }
//}

//-(void)deleteBook:(Book*)book
//{
//    NSMutableURLRequest *request = [NSMutableURLRequest new];
//    NSString *string = [NSString stringWithFormat:@"http://prolific-interview.herokuapp.com/560b7c9763600c00097c4a84%@", book.url];
//    [request setURL:[NSURL URLWithString:string]];
//    [request setHTTPMethod:@"DELETE"];
//    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//
//    if(conn) {
//        NSLog(@"Connection Successful:%@", conn);
//    } else {
//        NSLog(@"Connection could not be made");
//    }
//}

@end
