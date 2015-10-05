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

    //Title/Author label UI
    self.labelTitleAuthor.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelTitleAuthor.numberOfLines = 0;
    self.labelTitleAuthor.font = [UIFont systemFontOfSize:20];
    self.labelTitleAuthor.textColor = [UIColor blueColor];
    self.labelTitleAuthor.text = [NSString stringWithFormat:@"%@\n%@", self.book.title, self.book.author];

    //Detail label UI
    self.labelDetails.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelDetails.numberOfLines = 0;
    self.labelDetails.font = [UIFont systemFontOfSize:14];
    self.labelDetails.textColor = [UIColor grayColor];
    self.labelDetails.text = [NSString stringWithFormat:@"Publisher: %@\nCategories: %@\nLastCheckedOutBy:\n%@ %@", self.book.publisher, self.book.category, self.book.lastCheckedOutBy, self.book.lastCheckedOut];

}


- (IBAction)checkoutButtonTapped:(UIButton *)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Checkout" message:@"Who is checking the book out?" preferredStyle:UIAlertControllerStyleAlert];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter Name";
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [textField addTarget:self action:@selector(alertTextFieldDidChange:) forControlEvents:UIControlEventAllEvents];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *add = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        UITextField *textfield = alert.textFields.firstObject;
        self.book.lastCheckedOutBy = textfield.text;

        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        self.book.lastCheckedOut = dateString;
        
        [Book updateBook:self.book];
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


- (IBAction)shareBook:(UIBarButtonItem *)sender {

    NSMutableArray *items = [NSMutableArray new];
    NSString *message = [NSString stringWithFormat:@"Hey everyone! Check out this amazing book I just got from the Swag library. If you're not reading this book, you don't have your swag on! Here are the details:\nTitle:%@\nAuthor:%@\nPublisher:%@\nCategory:%@", self.book.title, self.book.author, self.book.publisher, self.book.category];

    [items addObject:message];

    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}
@end
