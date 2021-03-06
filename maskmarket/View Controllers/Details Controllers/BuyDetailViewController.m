//
//  BuyDetailViewController.m
//  maskmarket
//
//  Created by Alex Oseguera on 7/16/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import "BuyDetailViewController.h"
#import "ParsePoster.h"
#import "PurchaseViewController.h"
#import "FullImageViewController.h"

#pragma mark - Interface

@interface BuyDetailViewController ()

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

#pragma mark - Implementation

@implementation BuyDetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
}

#pragma mark - Gesture Recognizers

- (IBAction)onTapImage:(id)sender
{
    [self performSegueWithIdentifier:@"fullImageSegue"
                              sender:nil];
}

#pragma mark - Setup Views

- (void)setUpViews
{
    _maskImageView.userInteractionEnabled = NO;
    typeof(self) __weak weakSelf = self;
    [self.maskListing.maskImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil ) {
            return;
        }
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            UIImage *const image = [UIImage imageWithData:data];
            [strongSelf.maskImageView setImage:image];
            strongSelf.maskImageView.userInteractionEnabled = YES;
        }
    }];
    
    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    NSString *const formattedDateString = [formatter stringFromDate:_maskListing.createdAt];
    _dateLabel.text = [NSString stringWithFormat:@"Posted on %@", formattedDateString];
    
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width / 2;
    _priceLabel.text = [NSString stringWithFormat:@"$%d", _maskListing.price];
    _locationLabel.text = [NSString stringWithFormat:@"%@, %@", _maskListing.city, _maskListing.state];
    _titleLabel.text = _maskListing.title;
    _usernameLabel.text = _maskListing.author.username;
    _descriptionLabel.text = _maskListing.maskDescription;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"purchaseSegue"]) {
        PurchaseViewController *const destinationViewController = [segue destinationViewController];
        destinationViewController.maskListing = self.maskListing;
    } else if ([segue.identifier isEqualToString:@"fullImageSegue"]) {
        FullImageViewController *const destinationViewController = [segue destinationViewController];
        destinationViewController.maskImage = _maskImageView.image;
    }
}

@end
