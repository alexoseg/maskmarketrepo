//
//  HomeListingCell.m
//  maskmarket
//
//  Created by Alex Oseguera on 7/15/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import "HomeListingCell.h"

@implementation HomeListingCell

- (void)setUpViewsWithParseMaskListing:(ParseMaskListing *)listing
{
    _titleTextField.text = listing.title;
    NSString *const locationString = [NSString stringWithFormat:@"%@, %@", listing.city, listing.state];
    _locationTextField.text = locationString;
    _priceTextField.text = [NSString stringWithFormat:@"$%d", listing.price];
    
    typeof(self) __weak weakSelf = self;
    [listing.maskImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        UIImage *const image = [UIImage imageWithData:data];
        [strongSelf.listingImageView setImage:image];
    }];
}

@end
