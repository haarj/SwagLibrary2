//
//  BookDetailVC.m
//  Swag Library 2
//
//  Created by Justin Haar on 9/30/15.
//  Copyright © 2015 Justin Haar. All rights reserved.
//

#import "BookDetailVC.h"

@interface BookDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitleAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheckout;

@end

@implementation BookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.book.title;


    self.labelTitleAuthor.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelTitleAuthor.numberOfLines = 0;
    self.labelTitleAuthor.text = [NSString stringWithFormat:@"%@\n%@", self.book.title, self.book.author];

    self.labelDetails.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelDetails.numberOfLines = 0;
    self.labelDetails.text = [NSString stringWithFormat:@"Publisher: %@\nCategories: %@\nLastCheckedOutBy:\n%@ on %@", self.book.publisher, self.book.category, self.book.lastCheckedOutBy, self.book.lastCheckedOut];

}

- (IBAction)checkoutButtonTapped:(UIButton *)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Checkout" message:@"Who is checking the book out?" preferredStyle:UIAlertControllerStyleAlert];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter Name";
        [textField addTarget:self action:@selector(alertTextFieldDidChange:) forControlEvents:UIControlEventAllEvents];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *textfield = alert.textFields.firstObject;
        self.book.lastCheckedOutBy = textfield.text;

        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        self.book.lastCheckedOut = dateString;
        [self updateBook];
        [self.navigationController popViewControllerAnimated:YES];
    }];

    [alert addAction:cancel];
    [alert addAction:add];

    [self presentViewController:alert animated:YES completion:nil];
}


- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 0;
    }
}

-(void)updateBook
{
    NSString *post = [NSString stringWithFormat:@"lastCheckedOutBy=%@&lastCheckedOut=%@", self.book.lastCheckedOutBy, self.book.lastCheckedOut];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    NSString *string = [NSString stringWithFormat:@"http://prolific-interview.herokuapp.com/560b7c9763600c00097c4a84%@",self.book.url];
    [request setURL:[NSURL URLWithString:string]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if(conn) {
        NSLog(@"Connection Successful:%@", conn);
    } else {
        NSLog(@"Connection could not be made");
    }
    
}

- (IBAction)shareBook:(UIBarButtonItem *)sender {

    NSMutableArray *items = [NSMutableArray new];
    NSString *message = [NSString stringWithFormat:@"Hey everyone! Check out this amazing book I just got from the Swag library. If you're not reading this book, you don't have your swag on! Here are the details:\nTitle:%@\nAuthor:%@\nPublisher:%@\nCategory:%@", self.book.title, self.book.author, self.book.publisher, self.book.category];

    [items addObject:message];

    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}
@end
