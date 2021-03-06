//
//  SellingDetailsViewController.h
//  maskmarket
//
//  Created by Alex Oseguera on 7/23/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaskListingBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface SellingDetailsViewController : UIViewController

@property (nonatomic, strong) ParseMaskListing *maskListing;

@end

NS_ASSUME_NONNULL_END
