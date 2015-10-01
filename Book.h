//
//  Book.h
//  Swag Library 2
//
//  Created by Justin Haar on 9/30/15.
//  Copyright © 2015 Justin Haar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property NSString *author;
@property NSMutableArray *categories;
@property NSDate *lastCheckedOut;
@property NSString *lastCheckedOutBy;
@property NSString *publisher;
@property NSString *title;
@property NSString *url;

+(void)getBooksWithBlock:(void(^)(NSArray*))complete;

//+(NSMutableArray*)getBooks;


@end
