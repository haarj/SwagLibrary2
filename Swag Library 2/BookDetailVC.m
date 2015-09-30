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
    // Do any additional setup after loading the view.
}

- (IBAction)checkoutButtonTapped:(UIButton *)sender {
}

@end
