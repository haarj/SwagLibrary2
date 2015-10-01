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
    self.textfieldAuthor.borderStyle = UITextBorderStyleNone;
    self.textfieldPublisher.borderStyle = UITextBorderStyleNone;
    self.textfieldCategories.borderStyle = UITextBorderStyleNone;
}


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
        [self dismissViewControllerAnimated:YES completion:nil];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error(s)" message:[NSString stringWithFormat:@"The following field(s) are required:\n%@", string] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];


    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)postBook
{
    NSString *post = [NSString stringWithFormat:@"title=%@&author=%@&publisher=%@&categories=%@", self.book.title, self.book.author, self.book.publisher, self.book.categories];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/560b7c9763600c00097c4a84/books"]];
    [request setHTTPMethod:@"POST"];
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
//    NSString *string = [NSString new];

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
            [self validateCategoriesTextField];
            break;
        default:
            break;
    }
}

-(void)validateCategoriesTextField
{
//    BOOL valid;
    NSCharacterSet *blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvqxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789, "] invertedSet];
    NSRange range = [self.textfieldCategories.text rangeOfCharacterFromSet:blockedCharacters];

    if (range.length == 0) {
            [self.textfieldCategories resignFirstResponder];
        NSString *string = [NSString new];
        string = [self.textfieldCategories.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.book.categories =[[string componentsSeparatedByString:@","] mutableCopy];
    }else{
        [self getInvalidCategoriesTextFieldAlert];
    }

}

-(void)getInvalidCategoriesTextFieldAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Categories Textfield contains invalid characters." preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];

}

@end
