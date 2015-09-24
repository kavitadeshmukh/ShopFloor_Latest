//
//  NCMExpiditer.m
//  ShopFloor
//
//  Created by Kavita Deshmukh on 15/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "NCMExpiditer.h"

@implementation NCMExpiditer
static NCMExpiditer *sharedObject = nil;

- (id)init {
    if (! sharedObject) {
        sharedObject = [super init];
    }
    return sharedObject;
}
+(NCMExpiditer*)sharedInstance{
    
    static NCMExpiditer *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance=[[NCMExpiditer alloc] init];
    });
    return sharedInstance;
}

@end
