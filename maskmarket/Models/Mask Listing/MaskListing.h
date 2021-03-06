//
//  MaskListing.h
//  maskmarket
//
//  Created by Alex Oseguera on 7/13/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ParseUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaskListing : NSObject

@property (nonatomic, strong, readonly) NSString *maskDescription;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *city;
@property (nonatomic, strong, readonly) NSString *state;
@property (nonatomic, strong, readonly) ParseUser *author;
@property (nonatomic, readonly) int price;
@property (nonatomic, readonly) int maskQuantity;
@property (nonatomic, strong, readonly) PFFileObject *maskImage;

- (instancetype)initWithMaskDescription:(NSString *)maskDescription
                                  title:(NSString *)title
                                   city:(NSString *)city
                                  state:(NSString *)state
                                 author:(ParseUser *)author
                                  price:(int)price
                              maskQuantity:(int)maskQuantity
                              maskImage:(PFFileObject *)maskImage;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
