//
//  APIsManager.m
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Kavita. All rights reserved.

#import "APIsManager.h"
#import "Constants.h"
#import "XMLReader.h"
#import "Global.h"

@implementation APIsManager

#pragma mark - Shared instance
+ (APIsManager *)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

#pragma mark - NCMExpediter service calls

-(void)getMaterialDescription:(NSString*)aMaterialID completionBlock:(void (^)(NSDictionary *))completionBlock {
    
    NSURL* baseURL;
        if ([SELECTED_ENVIRONMENT isEqualToString:@"QA"])
            baseURL = [NSURL URLWithString:@"http://hdaqmdm02.hdmc.harley-davidson.com:56500/XMII/Runner"];
        else if ([SELECTED_ENVIRONMENT isEqualToString:@"PROD"])
            baseURL = [NSURL URLWithString:@""];
        else
            baseURL = [NSURL URLWithString:@""];
    
    NSLog(@"material des url %@",baseURL);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:baseURL];
    request.HTTPMethod = @"POST";
    NSLog(@"fffff %@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:MATERIAL_ID], [[NSUserDefaults standardUserDefaults]valueForKey:STORAGE_LOCATION] );
 
//    NSDictionary* bodyParameters =  @{@"Transaction":@"HdmcNCMScrap/GetMaterialList",
//                                      @"Material":@"32001-08A",
//                                      @"StorageLocation":@"S101",
//                                      @"OutputParameter":@"MaterialDescription",
//                                      @"j_user":@"$mii_env",
//                                      @"j_password":@"miitstusr2"};
    NSDictionary* bodyParameters =  @{@"Transaction":@"HdmcNCMScrap/GetMaterialList",
                                      @"Material":[[NSUserDefaults standardUserDefaults]valueForKey:MATERIAL_ID],
                                      @"StorageLocation":[[NSUserDefaults standardUserDefaults]valueForKey:STORAGE_LOCATION],
                                      @"OutputParameter":@"MaterialDescription",
                                      @"j_user":USERNAME,
                                      @"j_password":PASSWORD};
     NSLog(@"material des para %@",bodyParameters);
    request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"XML: %@ \n\n %@", responseObject,operation);
         NSError *error;
         NSDictionary *responseDictonary = [XMLReader dictionaryForXMLData:responseObject
                                                                     error:error];
         NSMutableDictionary *tempDictionary;
         if (tempDictionary == nil)
             tempDictionary = [[NSMutableDictionary alloc] init];
         
         NSLog(@"response %@",responseDictonary);
    
         // if materialdescription key is not present then
         if ([[[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"] objectForKey:@"Row"]
               allKeys]containsObject:@"MaterialDescription"] &&
             ![[[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"] objectForKey:@"Row"]
                objectForKey:@"MaterialDescription"]  isKindOfClass:[NSNull class]] &&
             [[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"] objectForKey:@"Row"]
               objectForKey:@"MaterialDescription"] !=nil){
             [tempDictionary setObject:[[[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"]
                                          objectForKey:@"Row"] objectForKey:@"MaterialDescription"] objectForKey:@"text"]
                                forKey:@"MaterialDescription"];
         }
         else {
             [tempDictionary setObject:@"Material ID not found in the Storage Location"
                                  forKey:@"Message"];
         }
         NSLog(@"final %@", tempDictionary);
         completionBlock(tempDictionary);
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ \n  %@", error,operation);
         NSMutableDictionary *responseDictonary;
         [responseDictonary setObject:@"Server not responsing. Please try after sometime." forKey:@"Error"];
         completionBlock(responseDictonary);
     }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

-(void)getBinNumber:(NSString*)aMaterialID storageLocation:(NSString*)aStorageLocation
 completionBlock:(void (^)(NSDictionary *))completionBlock{
 
    NSURL* baseURL;
    if ([SELECTED_ENVIRONMENT isEqualToString:@"QA"])
        baseURL = [NSURL URLWithString:@"http://hdaqmdm02.hdmc.harley-davidson.com:56500/XMII/Runner"];
    else if ([SELECTED_ENVIRONMENT isEqualToString:@"PROD"])
        baseURL = [NSURL URLWithString:@""];
    else
        baseURL = [NSURL URLWithString:@""];
    
    NSLog(@"bin url %@",baseURL);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:baseURL];
    request.HTTPMethod = @"POST";
    
//    NSDictionary* bodyParameters =  @{@"Transaction":@"HdmcNCMScrap/GetMaterialBins",
//                                      @"MaterialNumber":@"32001-08A",
//                                      @"Plant":@"1001",
//                                      @"StorageLocation":@"S101",
//                                      @"StorageType":@"100",
//                                      @"OutputParameter":@"OutputXML",
//                                      @"j_user":@"$mii_env",
//                                      @"j_password":@"miitstusr2"};
    NSDictionary* bodyParameters =  @{@"Transaction":@"HdmcNCMScrap/GetMaterialBins",
                                      @"MaterialNumber":[[NSUserDefaults standardUserDefaults] valueForKey:MATERIAL_ID],
                                      @"Plant":PLANT,
                                      @"StorageLocation":[[NSUserDefaults standardUserDefaults] valueForKey:STORAGE_LOCATION],
                                      @"StorageType":STORAGE_TYPE,
                                      @"OutputParameter":@"OutputXML",
                                      @"j_user":USERNAME,
                                      @"j_password":PASSWORD};
    NSLog(@"bin para %@",bodyParameters);
    request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"XML: %@ \n\n %@", responseObject,operation);
         NSError *error;
         NSDictionary *responseDictonary = [XMLReader dictionaryForXMLData:responseObject
                                                                     error:error];
         NSMutableDictionary *tempDictionary;
         if (tempDictionary == nil)
             tempDictionary = [[NSMutableDictionary alloc] init];
         
         NSLog(@"response %@",responseDictonary);
         
         // if materialdescription key is not present then
         if ([[[[[responseDictonary objectForKey:@"Rowsets"] objectForKey:@"Rowset"]
                objectForKey:@"Row"] allKeys]containsObject:@"StorageBin"] &&
             ![[[[[responseDictonary objectForKey:@"Rowsets"] objectForKey:@"Rowset"] objectForKey:@"Row"]
                objectForKey:@"StorageBin"] isKindOfClass:[NSNull class]] &&
             [[[[responseDictonary objectForKey:@"Rowsets"] objectForKey:@"Rowset"] objectForKey:@"Row"]
               objectForKey:@"StorageBin"]!=nil){
            
             [tempDictionary setObject:[[[[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"]
                                           objectForKey:@"Row"] objectForKey:@"StorageBin"] objectForKey:@"text"] stringByReplacingOccurrencesOfString:@"\n" withString:@""]
                                forKey:@"StorageBin"];
         }
         else {
             [tempDictionary setObject:@"No BINS Found in Storage Location"
                                forKey:@"Message"];
         }
         NSLog(@"final %@", tempDictionary);
         completionBlock(tempDictionary);
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ \n  %@", error,operation);
         NSMutableDictionary *responseDictonary;
         [responseDictonary setObject:@"No Inventory Found" forKey:@"Error"];
         completionBlock(responseDictonary);
     }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

-(void)setInventoryMovement:(NSString*)aMaterialID quantity:(NSString*)aQuantity
                     reason:(NSString*)aReason postingDate:(NSString*)aPostingDate
            storageLocation:(NSString*)aStorageLocation workStation:(NSString*)aWorkStation
                   comments:(NSString*)aComments bin:(NSString*)aBin
            completionBlock:(void (^)(NSDictionary *))completionBlock {

    NSURL* baseURL;
    if ([SELECTED_ENVIRONMENT isEqualToString:@"QA"])
        baseURL = [NSURL URLWithString:@"http://hdaqmdm02.hdmc.harley-davidson.com:56500/XMII/Runner"];
    else if ([SELECTED_ENVIRONMENT isEqualToString:@"PROD"])
        baseURL = [NSURL URLWithString:@""];
    else
        baseURL = [NSURL URLWithString:@""];
    
    NSLog(@"inventory url %@",baseURL);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:baseURL];
    request.HTTPMethod = @"POST";
    
//    NSDictionary* bodyParameters =  @{@"Transaction":@"HdmcNCMScrap/CreateGoodsMovement",
//                                      @"Plant":@"1001",
//                                      @"Material":@"32001-08A",
//                                      @"Quantity":@"2",
//                                      @"Reason":@"001",
//                                      @"PostingDate":@"20150922",
//                                      @"StorageLocation":@"S101",
//                                      @"Workstation":@"HYRKSF15161E",
//                                      @"Comments":@"cccc",
//                                      @"StorageType":@"100",
//                                      @"StorageBin":@"D03R-17",
//                                      @"OutputParameter":@"Output",
//                                      @"j_user":@"$mii_env",
//                                      @"j_password":@"miitstusr2"};//D03R-17
    NSDictionary* bodyParameters =  @{@"Transaction":@"HdmcNCMScrap/CreateGoodsMovement",
                                      @"Plant":PLANT,
                                      @"Material":[[NSUserDefaults standardUserDefaults] valueForKey:MATERIAL_ID],
                                      @"Quantity":[[NSUserDefaults standardUserDefaults] valueForKey:QUANTITY],
                                      @"Reason":[[NSUserDefaults standardUserDefaults] valueForKey:REASON],
                                      @"PostingDate":[[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_DATE],
                                      @"StorageLocation":[[NSUserDefaults standardUserDefaults] valueForKey:STORAGE_LOCATION],
                                      @"Workstation":[[NSUserDefaults standardUserDefaults] valueForKey:PRINTER_SELECTED],
                                      @"Comments":[[NSUserDefaults standardUserDefaults] valueForKey:COMMENTS],
                                      @"StorageType":STORAGE_TYPE,
                                      @"StorageBin":[[NSUserDefaults standardUserDefaults] valueForKey:BIN],
                                      @"OutputParameter":@"Output",
                                      @"j_user":USERNAME,
                                      @"j_password":PASSWORD};//D03R-17
    NSLog(@"inventory para %@",bodyParameters);
    request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"XML: %@ \n\n %@", responseObject,operation);
         NSError *error;
         NSDictionary *responseDictonary = [XMLReader dictionaryForXMLData:responseObject
                                                                     error:error];
         NSMutableDictionary *tempDictionary;
         if (tempDictionary == nil)
             tempDictionary = [[NSMutableDictionary alloc] init];
         
         NSLog(@"response %@",responseDictonary);
         
         // if materialdescription key is not present then
         if ([[[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"]
                objectForKey:@"Row"] allKeys]containsObject:@"Output"] &&
             ![[[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"]
                 objectForKey:@"Row"] objectForKey:@"Output"] isKindOfClass:[NSNull class]] &&
             [[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"]
                objectForKey:@"Row"] objectForKey:@"Output"] !=nil){
             
             [tempDictionary setObject:[[[[[responseDictonary objectForKey:@"Rowsets"]objectForKey:@"Rowset"]
                                          objectForKey:@"Row"] objectForKey:@"Output"] objectForKey:@"text"]
                                forKey:@"Inventory"];
         }
         else {
             [tempDictionary setObject:@"Server not responsing. Please try after sometime."
                                forKey:@"Error"];
         }
         NSLog(@"final %@", tempDictionary);
         completionBlock(tempDictionary);
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@ \n  %@", error,operation);
         NSMutableDictionary *responseDictonary;
         [responseDictonary setObject:@"Server not responsing. Please try after sometime." forKey:@"Error"];
         completionBlock(responseDictonary);
     }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

-(void)sample {
   /* NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:@"http://hdaqmdm02.hdmc.harley-davidson.com:56500/XMII/Runner"]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString =[NSString stringWithFormat:@"Transaction=HdmcNCMScrap/GetMaterialList=Material=%@&StorageLocation=%@&OutputParameter=%@&j_user=%@&j_password=%@",@"32001-08A",@"S101",@"MaterialDescription",@"$Mii_env",@"miitstusr2"];
    
    [request setValue:[NSString
                       stringWithFormat:@"%d", [postString length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[postString
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    NSLog(@"tetsts %@", [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);*/
    
    
    NSURL* URL = [NSURL URLWithString:@"http://hdaqmdm02.hdmc.harley-davidson.com:56500/XMII/Runner"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    // Form URL-Encoded Body
    
//    NSDictionary* bodyParameters =  @{@"Transaction":@"HdmcNCMScrap/GetMaterialList",
//                                      @"Material":@"32001-08A",
//                                      @"StorageLocation":@"S101",
//                                      @"OutputParameter":@"MaterialDescription",
//                                      @"j_user":@"$mii_env",
//                                      @"j_password":@"miitstusr2"};
    NSDictionary* bodyParameters =  @{@"Transaction":@"HdmcNCMScrap/GetMaterialList",
                                      @"Material":[[NSUserDefaults standardUserDefaults] valueForKey:MATERIAL_ID],
                                      @"StorageLocation":[[NSUserDefaults standardUserDefaults] valueForKey:STORAGE_LOCATION],
                                      @"OutputParameter":@"MaterialDescription",
                                      @"j_user":@"$mii_env",
                                      @"j_password":@"miitstusr2"};
    request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];
    
    // Connection
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    
    NSLog(@"tetsts %@", [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
    
//    NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
//    [connection start];
    
}
/*
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Did Receive Response %@", response);
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    NSLog(@"Did Receive Data %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Did Fail");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Did Finish");
    // Do something with responseData
}*/

/*
 * Utils: Add this section before your class implementation
 */

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
/*static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    return [NSURL URLWithString:URLString];
}*/
@end
