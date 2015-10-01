//
//  AddBookVC.m
//  Swag Library 2
//
//  Created by Justin Haar on 9/30/15.
//  Copyright © 2015 Justin Haar. All rights reserved.
//

#import "AddBookVC.h"
#import "Contants.h"
#import "Book.h"

@interface AddBookVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITextField *textfieldTitle;
@property (weak, nonatomic) IBOutlet UITextField *textfieldAuthor;
@property (weak, nonatomic) IBOutlet UITextField *textfieldPublisher;
@property (weak, nonatomic) IBOutlet UITextField *textfieldCategories;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddBook;

@property Book *book;
@end

@implementation AddBookVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textfieldTitle.delegate = self;
    self.textfieldAuthor.delegate = self;
    self.textfieldPublisher.delegate = self;
    self.textfieldCategories.delegate = self;

    self.book = [Book new];
    
}


- (IBAction)dismissButtonTapped:(UIBarButtonItem *)sender
{

    //Get alert view to confirm cancel adding book
    [self getDismissAlertView];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitButtonTapped:(UIButton *)sender
{
    [self validateRequiredFields];
    
}

-(void)validateRequiredFields
{
    NSMutableArray *errors = [NSMutableArray new];
    if ([self.textfieldTitle.text isEqual:@""]) {
        [errors addObject:self.textfieldTitle.placeholder];
    }
    if ([self.textfieldAuthor.text isEqual:@""]) {
        [errors addObject:self.textfieldAuthor.placeholder];
    }

    if (errors.count > 0) {
        [self getErrorsAlertViewFromArray:errors];
    }else
    {
        [self postBook];
    }
}

-(void)getDismissAlertView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Don't Save?" message:@"Are you sure you want to leave without saving changes?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:no];
    [alert addAction:yes];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)getErrorsAlertViewFromArray:(NSMutableArray*)array
{
    NSString *string = [array componentsJoinedByString:@"\n"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Errors" message:[NSString stringWithFormat:@"The following field(s) are required:\n%@", string] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];


    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)postBook
{

}

#pragma mark - TextField Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *string = [NSString new];

    switch (textField.tag) {
        case kTitle:
            [self.textfieldAuthor becomeFirstResponder];
            self.book.title = textField.text;
            break;
        case kAuthor:
            [self.textfieldPublisher becomeFirstResponder];
            self.book.author = textField.text;
            break;
        case kPublisher:
            [self.textfieldCategories becomeFirstResponder];
            self.book.publisher = textField.text;
            break;
        case kCategories:
//            [self.textfieldCategories resignFirstResponder];
//            string = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//            self.book.categories =[[string componentsSeparatedByString:@","] mutableCopy];

            [self validateCategoriesTextField];
            break;
        default:
            break;
    }
}

-(void)validateCategoriesTextField
{
//    BOOL valid;
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    blockedCharacters
    NSRange range = [self.textfieldCategories.text rangeOfCharacterFromSet:blockedCharacters];

//    if (range.length > 0) {
//        <#statements#>
//    }

}
@end
