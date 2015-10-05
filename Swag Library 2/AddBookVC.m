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
#import "BookListVC.h"

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
    //Set Title, textfield delegates, and UI
    self.title = @"Add Book";
    [self setDelegateAndTextfieldUI];
    self.book = [Book new];

}

-(void)setDelegateAndTextfieldUI
{
    self.textfieldTitle.delegate = self;
    self.textfieldAuthor.delegate = self;
    self.textfieldPublisher.delegate = self;
    self.textfieldCategories.delegate = self;

    self.textfieldTitle.borderStyle = UITextBorderStyleNone;
    self.textfieldTitle.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textfieldTitle.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.textfieldAuthor.borderStyle = UITextBorderStyleNone;
    self.textfieldAuthor.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textfieldAuthor.clearButtonMode = UITextFieldViewModeWhileEditing;


    self.textfieldPublisher.borderStyle = UITextBorderStyleNone;
    self.textfieldPublisher.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textfieldPublisher.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.textfieldCategories.borderStyle = UITextBorderStyleNone;
    self.textfieldCategories.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.textfieldCategories.clearButtonMode = UITextFieldViewModeWhileEditing;

}

#pragma mark - Button Methods

- (IBAction)dismissButtonTapped:(UIBarButtonItem *)sender
{

    //All textfields are empty
    if ([self.textfieldTitle.text isEqual:@""] && [self.textfieldAuthor.text isEqual:@""] && [self.textfieldPublisher.text isEqual:@""] && [self.textfieldCategories.text isEqual:@""]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else//there is text in at least one field
    {
        [self getDismissAlertView];
    }
}

//Validate Title and Author fields have text
- (IBAction)submitButtonTapped:(UIButton *)sender
{
    [self validateRequiredFields];
    
}

#pragma mark - Helper Methods

-(void)validateRequiredFields
{
    NSMutableArray *errors = [NSMutableArray new];
    //Title is empty
    if ([self.textfieldTitle.text isEqual:@""]) {
        [errors addObject:self.textfieldTitle.placeholder];
    }
    //Author is empty
    if ([self.textfieldAuthor.text isEqual:@""]) {
        [errors addObject:self.textfieldAuthor.placeholder];
    }

    //Title and/or Author is missing
    if (errors.count > 0) {
        [self getErrorsAlertViewFromArray:errors];
    }
    //Post book and dismiss
    else
    {
        
        [self.view endEditing:YES];
        [Book postBook:self.book :^(BOOL error) {
            if (error) {
                [self getConnectionErrorAlert];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];

            }
        }];
//        [Book postBook:self.book];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//Alert with Title and/or author errors
-(void)getErrorsAlertViewFromArray:(NSMutableArray*)array
{
    NSString *string = [array componentsJoinedByString:@"\n"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error(s)" message:[NSString stringWithFormat:@"The following field(s) are required:\n%@", string] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];


    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
}

//Alert called when there is text in any field
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

-(void)getConnectionErrorAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was a problem with the connection to the server" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];


    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
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

//Set text in respective textfield to a book objects property
-(void)textFieldDidEndEditing:(UITextField *)textField
{
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
            self.book.category = textField.text;
            break;
        default:
            break;
    }
}

//-(void)validateCategoriesTextField
//{
//    BOOL valid;
//    NSCharacterSet *blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvqxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789, "] invertedSet];
//    NSRange range = [self.textfieldCategories.text rangeOfCharacterFromSet:blockedCharacters];
//
//    if (range.length == 0) {
//            [self.textfieldCategories resignFirstResponder];
//        NSString *string = [NSString new];
//        string = [self.textfieldCategories.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//        self.book.categories =[[string componentsSeparatedByString:@","] mutableCopy];
//    }else{
//        [self getInvalidCategoriesTextFieldAlert];
//    }

//}

//-(void)getInvalidCategoriesTextFieldAlert
//{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Categories Textfield contains invalid characters." preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//
//    [alert addAction:ok];
//
//    [self presentViewController:alert animated:YES completion:nil];
//
//}

@end
