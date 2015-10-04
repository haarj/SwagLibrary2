//
//  Book.h
//  Swag Library 2
//
//  Created by Justin Haar on 9/30/15.
//  Copyright © 2015 Justin Haar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookListVC.h"

@interface Book : NSObject

@property NSString *author;
@property NSString *category;
@property NSString *lastCheckedOut;
@property NSString *lastCheckedOutBy;
@property NSString *publisher;
@property NSString *title;
@property NSString *url;

+(void)getBooksWithBlock:(void(^)(NSArray*))complete;

+(void)deleteAllBooks;

+(void)deleteBook:(Book*)book;

+(void)postBook:(Book*)book;

+(void)updateBook:(Book*)book;




//+(NSMutableArray*)getBooks;


@end
