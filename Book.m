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
        self.category = dict[@"categories"];
        if (dict[@"lastCheckedOut"] == [NSNull null]) {
            self.lastCheckedOut = @"";
        }else
        {
            self.lastCheckedOut = dict[@"lastCheckedOut"];

        }
        if (dict[@"lastCheckedOutBy"] == [NSNull null]) {
            self.lastCheckedOutBy = @"";
        }else{
            self.lastCheckedOutBy = dict[@"lastCheckedOutBy"];
        }
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
//
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSArray *books = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        for (NSDictionary *dict in books) {
            Book *book = [[Book alloc]initWithDictionary:dict];
            [tempArray addObject:book];
        }
        complete(tempArray);
    }];
}

+(void)deleteAllBooks
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/560b7c9763600c00097c4a84/clean"]];
    [request setHTTPMethod:@"DELETE"];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if(conn) {
        NSLog(@"Connection Successful:%@", conn);
    } else {
        NSLog(@"Connection could not be made");
    }
}

+(void)deleteBook:(Book*)book
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    NSString *string = [NSString stringWithFormat:@"http://prolific-interview.herokuapp.com/560b7c9763600c00097c4a84%@", book.url];
    [request setURL:[NSURL URLWithString:string]];
    [request setHTTPMethod:@"DELETE"];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if(conn) {
        NSLog(@"Connection Successful:%@", conn);
    } else {
        NSLog(@"Connection could not be made");
    }
}

+(void)postBook:(Book*)book
{
    NSString *post = [NSString stringWithFormat:@"title=%@&author=%@&publisher=%@&categories=%@", book.title, book.author, book.publisher, book.category];
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

+(void)updateBook:(Book*)book
{
    NSString *post = [NSString stringWithFormat:@"lastCheckedOutBy=%@&lastCheckedOut=%@", book.lastCheckedOutBy, book.lastCheckedOut];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    NSString *string = [NSString stringWithFormat:@"http://prolific-interview.herokuapp.com/560b7c9763600c00097c4a84%@",book.url];
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

@end
