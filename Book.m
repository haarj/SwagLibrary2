//
//  Book.m
//  Swag Library 2
//
//  Created by Justin Haar on 9/30/15.
//  Copyright © 2015 Justin Haar. All rights reserved.
//

#import "Book.h"

@implementation Book

//set book properties from dictionary
-(instancetype)initWithDictionary:(NSDictionary*)dict
{
//    {
//        "author": "Ash Maurya",
//        "categories": "process",
//        "lastCheckedOut": null,
//        "lastCheckedOutBy": null,
//        "publisher": "O'REILLY",
//        "title": "Running Lean",
//        "url": "/books/1"
//    },
    if (self) {
        self.author = dict[@"author"];
        self.categories = dict[@"categories"];
        self.lastCheckedOut = dict[@"lastCheckedOut"];
        self.lastCheckedOutBy = dict[@"lastCheckedOutBy"];
        self.publisher = dict[@"publisher"];
        self.title = dict[@"title"];
        self.url = dict[@"url"];

    }

    return self;
}

+(void)getBooksWithBlock:(void(^)(NSArray*))complete
{
    NSMutableArray *tempArray = [NSMutableArray new];
    NSString *string = @"https://prolific-interview.herokuapp.com/560b7c9763600c00097c4a84/books";
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];


    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

//        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSArray *books = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        NSArray *books = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        for (NSDictionary *dict in books) {
            Book *book = [[Book alloc]initWithDictionary:dict];
            [tempArray addObject:book];
        }
//    return tempArray;
        complete(tempArray);
    }];
}

@end
