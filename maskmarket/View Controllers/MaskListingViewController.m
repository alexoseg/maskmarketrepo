//
//  MaskListingViewController.m
//  maskmarket
//
//  Created by Alex Oseguera on 7/13/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import "MaskListingViewController.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "ParseMaskListing.h"
#import "HomeListingCell.h"
#import "ParseGetter.h"
#import "MaskListingBuilder.h"
#import "BuyDetailViewController.h"
#import "LoadingPopupView.h"
#import "UIColor+AppColors.h"
#import "ErrorPopupViewController.h"

#pragma mark - Interface

@interface MaskListingViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
ErrorPopupViewControllerDelegate,
UIScrollViewDelegate>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray<ParseMaskListing *> *listingsArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isMoreDateLoading;

@end

#pragma mark - Implementation

@implementation MaskListingViewController

#pragma mark - Constants

static int const cellPaddingSize = 15;

#pragma mark - Lifecylce

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
    [LoadingPopupView showLoadingPopupAddedTo:self.view
                                  withMessage:@"Loading..."];
    [self fetchListings];
}

#pragma mark - Networking

- (void)fetchListings
{
    typeof(self) __weak weakSelf = self;
    [ParseGetter fetchAllListingsWithCompletion:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        
        [strongSelf.refreshControl endRefreshing];
        [LoadingPopupView hideLoadingPopupAddedTo:strongSelf.view];
        if (error) {
            ErrorPopupViewController *const errorPopupViewController = [[ErrorPopupViewController alloc] initWithMessage:error.localizedDescription
                                                                                                               addCancel:YES];
            errorPopupViewController.delegate = strongSelf; 
            [strongSelf presentViewController:errorPopupViewController
                                     animated:YES
                                   completion:nil];
        } else {
            strongSelf.listingsArray = [MaskListingBuilder buildParseMaskListingsFromArray:objects];
            [strongSelf.collectionView reloadData];
        }
    }];
}

- (void)loadMoreData
{
    ParseMaskListing *const lastListing = _listingsArray[_listingsArray.count - 1];
    NSLog(@"%@", lastListing.listingId);
    typeof(self) __weak weakSelf = self;
    [ParseGetter fetchListingsBoughtAfter:lastListing.createdAt
                           withCompletion:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        
        if (error) {
            NSLog(@"There was an error fetching more listings");
        }
        if (objects.count == 0) {
            return;
        } else {
            NSArray<ParseMaskListing *> *const newListings = [MaskListingBuilder buildParseMaskListingsFromArray:objects];
            NSMutableArray *newListingsArray = [[NSMutableArray alloc] initWithArray:strongSelf.listingsArray];
            [newListingsArray addObjectsFromArray:newListings];
            strongSelf.listingsArray = [newListingsArray copy];
            strongSelf.isMoreDateLoading = NO;
            [strongSelf.collectionView reloadData];
        }
    }];
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isMoreDateLoading) {
        NSInteger const scrollViewContentHeight = _collectionView.contentSize.height;
        NSInteger const scrollOffsetThreshold = scrollViewContentHeight - _collectionView.bounds.size.height;
        
        if (scrollView.contentOffset.y > scrollOffsetThreshold && _collectionView.isDragging) {
            _isMoreDateLoading = YES;
            [self loadMoreData];
        }
    }
}

#pragma mark - Error Popup delegate methods

- (void)tryAgainAction {
    [LoadingPopupView showLoadingPopupAddedTo:self.view
                                  withMessage:@"Loading..."];
    [self fetchListings];
}

#pragma mark - Collection View Code

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    HomeListingCell *const cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeListingCell"
                                                                      forIndexPath:indexPath];
    ParseMaskListing *const listing = self.listingsArray[indexPath.item];
    [cell setUpViewsWithParseMaskListing:listing];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return _listingsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int totalwidth = self.collectionView.bounds.size.width;
    int numberOfCellsPerRow = 2;
    int paddingSize = cellPaddingSize * 3;
    int itemWidth = (CGFloat)((totalwidth - paddingSize) / numberOfCellsPerRow);
    int itemHeight = itemWidth * 1.05;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(cellPaddingSize, cellPaddingSize, 0, cellPaddingSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return cellPaddingSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return cellPaddingSize;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    UICollectionViewCell *const tappedCell = sender;
    NSIndexPath *const indexPath = [self.collectionView indexPathForCell:tappedCell];
    ParseMaskListing *const maskListing = self.listingsArray[indexPath.item];
    BuyDetailViewController *const destinationViewController = [segue destinationViewController];
    destinationViewController.maskListing = maskListing;
}

#pragma mark - Gesture Recognizers

- (IBAction)onTapLogout:(id)sender
{
    [LoadingPopupView showLoadingPopupAddedTo:self.view
                                  withMessage:@"Logging Out..."];
    typeof(self) __weak weakSelf = self;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        [LoadingPopupView hideLoadingPopupAddedTo:strongSelf.view];
        SceneDelegate *const sceneDelegate = (SceneDelegate *)strongSelf.view.window.windowScene.delegate;
        UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                   bundle:nil];
        UINavigationController *const viewController = [storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        sceneDelegate.window.rootViewController = viewController;
    }];
}

#pragma mark - Setup

- (void)setUpViews
{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                       action:@selector(fetchListings)
             forControlEvents:UIControlEventValueChanged];
    _refreshControl.tintColor = [UIColor primaryAppColor];
    _refreshControl.layer.zPosition = -1;
    [_collectionView insertSubview:_refreshControl
                           atIndex:0];
}

@end
