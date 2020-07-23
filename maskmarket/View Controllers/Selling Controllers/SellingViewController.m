//
//  SellingViewController.m
//  maskmarket
//
//  Created by Alex Oseguera on 7/16/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import "SellingViewController.h"
#import "SellingListingCell.h"
#import "ParseMaskListing.h"
#import "ParseGetter.h"
#import "MaskListingBuilder.h"
#import "LoadingPopupView.h"

#pragma mark - Interface

@interface SellingViewController ()
<UITableViewDelegate,
UITableViewDataSource>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<ParseMaskListing *> *sellingListings;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

#pragma mark - Implementation

@implementation SellingViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
    [LoadingPopupView showLoadingPopupAddedTo:self.view
                                  withMessage:@"Loading"];
    [self fetchListings];
}

#pragma mark - Networking

- (void)fetchListings
{
    typeof(self) __weak weakSelf = self;
    [ParseGetter fetchCurrentUserSellingsWithCompletion:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            NSLog(@"Failed self referencing");
            return;
        }
        
        [strongSelf.refreshControl endRefreshing];
        [LoadingPopupView hideLoadingPopupAddedTo:strongSelf.view];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"Fetched Selling Listings!");
            strongSelf.sellingListings = [MaskListingBuilder buildParseMaskListingsFromArray:objects];
            [strongSelf.tableView reloadData];
        }
    }];
}

#pragma mark - Tableview Code

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SellingListingCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"SellingCell"];
    ParseMaskListing *const maskListing = self.sellingListings[indexPath.row];
    [cell setUpCellWithParseMaskListing:maskListing];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _sellingListings.count;
}

#pragma mark - Setups

- (void)setUpViews
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                       action:@selector(fetchListings)
             forControlEvents:UIControlEventValueChanged];
    _refreshControl.tintColor = [UIColor colorWithRed:38.0f/255.0f
                                                green:184.0f/255.0f
                                                 blue:153.0f/255.0f
                                                alpha:1.0f];
    _refreshControl.layer.zPosition = -1;
    [_tableView insertSubview:_refreshControl
                           atIndex:0];
}

@end
