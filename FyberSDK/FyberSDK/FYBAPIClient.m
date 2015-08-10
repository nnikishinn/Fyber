//
//  FYBApiClient.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBAPIClient.h"
#import "NSString+Hashes.h"
#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>
#import "FYBAPIClient_Constants.h"

@interface FYBAPIClient() <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation FYBAPIClient

#pragma mark -
#pragma mark Accessors - Getters
- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _operationQueue;
}

- (NSURLSession *)urlSession {
    if (!_urlSession) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.operationQueue];
    }
    
    return _urlSession;
}

#pragma mark -
#pragma mark Public API
+ (void)getOffersWithParametersAppid:(NSString *)requestAppid
                          requestUid:(NSString *)requestUid
                       requestAPIKey:(NSString *)requestAPIKey
                        successBlock:(void (^)(NSArray * offersArray))sucessBlock
                          errorBlock:(void (^)(NSError *error))errorBlock {
    
    [[self sharedInstance] getOffersWithParametersAppid:requestAppid requestUid:requestUid requestAPIKey:requestAPIKey successBlock:^(NSArray *offersArray) {
        if (sucessBlock) sucessBlock(offersArray);
    } errorBlock:^(NSError *error) {
        if (errorBlock) errorBlock(error);
    }];
}

#pragma mark -
#pragma mark Singelton

+ (instancetype)sharedInstance {
    static FYBAPIClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FYBAPIClient alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark
#pragma mark Private Methods
- (void)getOffersWithParametersAppid:(NSString *)requestAppid
                     requestUid:(NSString *)requestUid
                  requestAPIKey:(NSString *)requestAPIKey
                   successBlock:(void (^)(NSArray * offersArray))sucessBlock
                     errorBlock:(void (^)(NSError *error))errorBlock {
    
    NSURL *url = [[self class] urlWithParameters:requestAppid requestUid:requestUid requestAPIKey:requestAPIKey];
    
    NSURLSessionDataTask *dataTask =
    [self.urlSession dataTaskWithURL:url
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (errorBlock) errorBlock(error);
                        });
                    } else {
                        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        if (error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (errorBlock) errorBlock(error);
                            });
                        } else {
                            
                            if ([[self class] checkIfRseponseIsValid:response body:data requestAPIKey:requestAPIKey error:&error]) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (errorBlock) errorBlock(error);
                                });
                                
                            } else {
                                NSDictionary *jsonDict = (NSDictionary *)json;
                                if ([[self class] checkIfObjectIsError:json urlResponse:response error:&error]) {
                                    if (error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (errorBlock) errorBlock(error);
                                        });
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (sucessBlock) sucessBlock([jsonDict objectForKey:@"offers"]);
                                        });
                                    }
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (sucessBlock) sucessBlock([jsonDict objectForKey:@"offers"]);
                                    });
                                }
                            }
                        }
                    }
    }];
    
    [dataTask resume];
    
}

+ (NSURL *)urlWithParameters:(NSString *)requestAppid
                  requestUid:(NSString *)requestUid
               requestAPIKey:(NSString *)requestAPIKey {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kFYBUrlPrefix, kFYBBaseURL];
    NSDictionary *parameters = @{@"appid" : requestAppid,
                                 @"uid" : requestUid,
                                 @"ip" : [kFYBIp copy],
                                 @"locale" : [kFYBLocale copy],
                                 @"os_version" : [[UIDevice currentDevice] systemVersion],
                                 @"device_id" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                 @"timestamp" : [NSString stringWithFormat:@"%@", @([[NSDate date] timeIntervalSince1970])],
                                 @"offer_types" : [kFYBOfferTypes copy],
                                 @"apple_idfa" : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                                 @"apple_idfa_tracking_enabled" : [ASIdentifierManager sharedManager].advertisingTrackingEnabled ? @"true" : @"false"
                                 };
    
    NSMutableDictionary *parametersWithHash = [parameters mutableCopy];
    NSString *hashKey = [[self class] hashKeyForParamaters:parameters requestAPIKey:requestAPIKey];
    [parametersWithHash setObject:hashKey forKey:@"hashkey"];
    
    NSString *parametersStr = [[self class] parametersStringFromDictionary:parametersWithHash sortKeys:NO];
    urlStr = [NSString stringWithFormat:@"%@%@", urlStr, parametersStr];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:urlStr];
    
    return url;
}

+ (NSString *)parametersStringFromDictionary:(NSDictionary *)dictionary sortKeys:(BOOL)sortKeys {
   
    NSArray *sortedKeys = [dictionary allKeys];
    if (sortKeys) {
        sortedKeys = [sortedKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    __block NSMutableArray *parametersArray = [NSMutableArray array];
    [sortedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *value = [dictionary objectForKey:key];
        NSString *parameter = [NSString stringWithFormat:@"%@=%@", key, value];
        [parametersArray addObject:parameter];
    }];
    
    NSString *parametersStr = [parametersArray componentsJoinedByString:@"&"];
    return parametersStr;
}

+ (NSString *)hashKeyForParamaters:(NSDictionary *)parametersDict requestAPIKey:(NSString *)requestAPIKey {
    
    NSString *parametersStr = [self parametersStringFromDictionary:parametersDict sortKeys:YES];
    parametersStr = [NSString stringWithFormat:@"%@&%@", parametersStr, requestAPIKey];
    parametersStr = [parametersStr sha1];
    return parametersStr;
    
}

+ (NSString *)hashKeyForResponseBody:(NSData *)body requestAPIKey:(NSString *)requestAPIKey {
    NSString *parametersStr = [[NSString alloc] initWithBytes:[body bytes] length:[body length] encoding:NSUTF8StringEncoding];
    parametersStr = [NSString stringWithFormat:@"%@&%@", parametersStr, requestAPIKey];
    parametersStr = [parametersStr sha1];
    return parametersStr;
}

#pragma mark -
#pragma mark Error Handling

+ (BOOL)checkIfRseponseIsValid:(NSURLResponse *)response
                      body:(NSData *)body
                 requestAPIKey:(NSString *)requestAPIKey
                       error:(NSError **)error {
    
#warning Don't really know how to calculate SHA1 for body
    return NO;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSString *hashKey = [[self class] hashKeyForResponseBody:body requestAPIKey:requestAPIKey];
    NSString *serverKey = [httpResponse.allHeaderFields objectForKey:@"X-Sponsorpay-Response-Signature"];
        
    if (![hashKey isEqualToString:serverKey]) {
            NSDictionary* errorDetails = @{NSLocalizedDescriptionKey : @"invalid hash"};
            *error = [NSError errorWithDomain:[errorDomain copy] code:1000 userInfo:errorDetails];
    }
    
    return *error ? YES : NO;
}

+ (BOOL)checkIfObjectIsError:(id)object
                 urlResponse:(NSURLResponse *)response
                       error:(NSError **)error {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode]!=200) {
        
        NSString *errorDescription = nil;
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *objectDict = (NSDictionary *)object;
            errorDescription = [objectDict objectForKey:@"message"];
        }
        
        if (!errorDescription) {
            errorDescription = [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]];
        }
        
        if (!errorDescription) {
            errorDescription = @"Unknown error placeholder";
        }
        
        NSDictionary* errorDetails = @{NSLocalizedDescriptionKey : errorDescription};
        if (error != NULL) *error = [NSError errorWithDomain:[errorDomain copy] code:[httpResponse statusCode] userInfo:errorDetails];
        
        
    }
    
    return error != NULL ? YES : NO;
}


#pragma mark -
#pragma mark NSURLSessionDelegate


@end
