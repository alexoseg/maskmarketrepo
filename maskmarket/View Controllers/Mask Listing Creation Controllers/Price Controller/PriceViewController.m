//
//  PriceViewController.m
//  maskmarket
//
//  Created by Alex Oseguera on 7/14/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import "PriceViewController.h"
#import "ParsePoster.h"
#import "MaskListing.h"
#import "LoadingPopupView.h"
#import "ErrorPopupViewController.h"
#import "SuccessPopupViewController.h"
#import "SellingViewController.h"

#pragma mark - Interface

@interface PriceViewController ()
<UITextFieldDelegate,
SuccessPopupDelegate,
UITextFieldDelegate>

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *maskQuantityTextField;

@end

#pragma mark - Implementation

@implementation PriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
}

#pragma mark - Gesture Recognizers

- (IBAction)onTapPost:(id)sender
{
    [self dismissKeyboard];
    
    if (_priceTextField.text.length == 0
        || _maskQuantityTextField.text.length == 0)
    {
        ErrorPopupViewController *const errorPopupViewController = [[ErrorPopupViewController alloc] initWithMessage:@"Make sure to fill in all fields before continuing."
                                                                                                           addCancel:NO];
        [self presentViewController:errorPopupViewController
                           animated:YES
                         completion:nil];
        return;
    }
    
    NSNumberFormatter *const formatter = [[NSNumberFormatter alloc]init];
    self.builder.listingPrice = [formatter numberFromString:_priceTextField.text];
    self.builder.listingMaskQuantity = [formatter numberFromString:_maskQuantityTextField.text];
    MaskListing *const maskListing = [self.builder buildLocalMaskListing];
    
    [LoadingPopupView showLoadingPopupAddedTo:self.view
                                  withMessage:@"Posting"];
    typeof(self) __weak weakSelf = self;
    [ParsePoster createListingFromListing:maskListing
                           withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        [LoadingPopupView hideLoadingPopupAddedTo:strongSelf.view];
        if (error) {
            ErrorPopupViewController *const errorPopupViewController = [[ErrorPopupViewController alloc] initWithMessage:error.localizedDescription
                                                                                                               addCancel:NO];
            [strongSelf presentViewController:errorPopupViewController
                                     animated:YES
                                   completion:nil];
        } else {
            SuccessPopupViewController *const successPopupViewController = [[SuccessPopupViewController alloc] initWithMessage:@"You successfully created a new mask listing! You can now view your listing."];
            successPopupViewController.delegate = strongSelf;
            [strongSelf presentViewController:successPopupViewController
                                     animated:YES
                                   completion:nil];
        }
    }];
}

- (void)dismissKeyboard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

- (IBAction)onTapClose:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - Success Popup Delegate Methods

- (void)okayAction
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    [self.delegate didCreateListing]; 
}


#pragma mark - Text Field Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_priceTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        UITextPosition *const position = textField.endOfDocument;
        textField.selectedTextRange = [textField textRangeFromPosition:position
                                                            toPosition:position];
        textField.text = @"$";
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSString *const newString = [textField.text stringByReplacingCharactersInRange:range
                                                                        withString:string];
    if (![newString hasPrefix:@"$"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Setup

- (void)setUpViews
{
    _priceTextField.delegate = self;
    UITabBarController *const tabBarController = (UITabBarController *)self.presentingViewController;
    UINavigationController *const sellingNavController = tabBarController.viewControllers[1];
    SellingViewController *const sellingViewController = (SellingViewController *)sellingNavController.topViewController;
    self.delegate = (id<PriceViewControllerDelegate>)sellingViewController;
    _priceTextField.delegate = self;
    _priceTextField.adjustsFontSizeToFitWidth = NO;
    UITapGestureRecognizer *const screenTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:screenTap];
}

@end
