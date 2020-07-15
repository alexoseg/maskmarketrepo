//
//  ParseMaskListing.m
//  maskmarket
//
//  Created by Alex Oseguera on 7/15/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import "ParseMaskListing.h"

@implementation ParseMaskListing

- (instancetype)initWithListingId:(NSString *)listingId
                        createdAt:(NSDate *)createdAt
                  maskDescription:(NSString *)maskDescription
                            title:(NSString *)title
                             city:(NSString *)city
                            state:(NSString *)state
                           author:(User *)author
                            price:(int)price
                        purchased:(BOOL)purchased
                      purchasedBy:(User *)purchasedBy
                        maskImage:(PFFileObject *)maskImage
{
    self = [super initWithMaskDescription:maskDescription
                                    title:title
                                     city:city
                                    state:state
                                   author:author
                                    price:price
                                purchased:purchased
                                maskImage:maskImage];
    
    if (self) {
        _listingId = listingId;
        _createdAt = createdAt;
        _purchasedBy = purchasedBy;
    }
    
    return self;
}

@end