//
//  AddBookVC.m
//  Swag Library 2
//
//  Created by Justin Haar on 9/30/15.
//  Copyright © 2015 Justin Haar. All rights reserved.
//

#import "AddBookVC.h"

@interface AddBookVC ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITextField *textfieldTitle;
@property (weak, nonatomic) IBOutlet UITextField *textfieldAuthor;
@property (weak, nonatomic) IBOutlet UITextField *textfieldPublisher;
@property (weak, nonatomic) IBOutlet UITextField *textfieldCategory;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddBook;

@end

@implementation AddBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)dismissButtonTapped:(UIBarButtonItem *)sender {

    //Get alert view to confirm cancel adding book
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submitButtonTapped:(UIButton *)sender {

    
}

@end
