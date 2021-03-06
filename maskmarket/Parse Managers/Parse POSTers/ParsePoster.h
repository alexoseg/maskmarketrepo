//
//  ParsePoster.h
//  maskmarket
//
//  Created by Alex Oseguera on 7/13/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "UserBuilder.h"
#import "MaskListing.h"
#import "PurchasedObjBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParsePoster : NSObject

+ (void)setPurchaseCompleteWithID:(NSString *)purhcaseListingID
                    maskListingID:(NSString *)maskListingID
                   trackingNumber:(NSString *)trackingNumber
                   withCompletion:(PFBooleanResultBlock)completion;

+ (void)purchaseListingWithId:(NSString *)maskListingId
             amountToPurchase:(int)amountToPurchase
                  amountSpent:(int)amountSpent
               withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)createListingFromListing:(MaskListing *)maskListing
                  withCompletion:(PFBooleanResultBlock)completion;

+ (void)createAccountWithUsername:(NSString *)username
                            email:(NSString *)email
                         password:(NSString *)password
            shippingStreetAddress:(NSString *)shippingStreetAddress
                     shippingCity:(NSString *)shippingCity
                    shippingState:(NSString *)shippingState
                  shippingZipCode:(NSString *)shippingZipCode
                   withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
           withCompletion:(void (^)(PFUser * _Nullable, NSError * _Nullable))completion;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
