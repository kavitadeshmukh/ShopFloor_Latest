//
//  APIsManager.h
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Kavita. All rights reserved.

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface APIsManager : NSObject

@property (strong, nonatomic) NSString *strOrderId;
+ (APIsManager *)sharedManager;

/* NCMExpediter service calls */
-(void)getMaterialDescription:(NSString*)aMaterialID completionBlock:(void (^)(NSDictionary *))completionBlock;
-(void)getBinNumber:(NSString*)aMaterialID storageLocation:(NSString*)aStorageLocation completionBlock:(void (^)(NSDictionary *))completionBlock;
-(void)setInventoryMovement:(NSString*)aMaterialID quantity:(NSString*)aQuantity reason:(NSString*)aReason postingDate:(NSString*)aPostingDate storageLocation:(NSString*)aStorageLocation workStation:(NSString*)aWorkStation comments:(NSString*)aComments bin:(NSString*)aBin completionBlock:(void (^)(NSDictionary *))completionBlock;


-(void)sample;


//- (void)getOrderSerachResult:(NSString *)endpoint params:(NSDictionary *)params productNumber:(NSString*)aProductNumber orderNumber:(NSString*)aOrderNumber choosedDateType:(NSString*)aChoosedDateType selectedDate:(NSString*)aSelectedDate withTimeout:(NSTimeInterval)withTimeout completionBlock:(void (^)(NSMutableArray *))completionBlock;
//- (void)loginService:(NSString *)endpoint params:(NSDictionary *)params
//completionBlock:(void (^)(NSMutableArray *))completionBlock;
//- (void)loginServiceForGRS:(NSString *)endpoint params:(NSDictionary *)params
//     completionBlock:(void (^)(NSMutableArray *))completionBlock;
@end
