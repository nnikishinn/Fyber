//
//  ViewController.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBRequestViewController.h"
#import "FYBAllOffersViewController.h"
#import "FYBRequestViewModel.h"
#import "FYBAlertController.h"

@interface FYBRequestViewController ()

typedef NS_ENUM(NSUInteger, FYBRequestViewControllerState) {
    FYBRequestViewControllerStateDefault          = 0,
    FYBRequestViewControllerStateLoading,
};


//Outlets
@property (weak, nonatomic) IBOutlet UILabel *labelUid;
@property (weak, nonatomic) IBOutlet UILabel *labelAPIKey;
@property (weak, nonatomic) IBOutlet UILabel *labelAppid;
@property (weak, nonatomic) IBOutlet UILabel *labelMandatoryFields;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUid;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAPIKey;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAppid;

@property (weak, nonatomic) IBOutlet UIButton *buttonRequestOffers;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *navBarButtonReset;

@property (nonatomic, assign) FYBRequestViewControllerState viewState;
//Model
@property (nonatomic, strong) FYBRequestViewModel *viewModel;

@end

#define mandatoryTextFieldBackgroundColor [UIColor colorWithRed:255.0 green:.0 blue:.0 alpha:.3]
#define textFieldBackgroundColor [UIColor clearColor]


@implementation FYBRequestViewController

#pragma mark -
#pragma mark Accessors - Getters
- (FYBRequestViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [FYBRequestViewModel model];
    }
    
    return _viewModel;
}

#pragma mark -
#pragma mark Accessors - Setters
- (void)setViewState:(FYBRequestViewControllerState)viewState {
    switch (viewState) {
        case FYBRequestViewControllerStateLoading:
        {
            [self.activityIndicator startAnimating];
            self.buttonRequestOffers.enabled = NO;
            self.textFieldAPIKey.enabled = NO;
            self.textFieldAppid.enabled = NO;
            self.textFieldUid.enabled = NO;
            self.navBarButtonReset.enabled = NO;
        }
            
            break;
            
        default:
        {
            [self.activityIndicator stopAnimating];
            self.buttonRequestOffers.enabled = YES;
            self.textFieldAPIKey.enabled = YES;
            self.textFieldAppid.enabled = YES;
            self.textFieldUid.enabled = YES;
            self.navBarButtonReset.enabled = YES;
        }
            break;
    }
    
    _viewState = viewState;
}

#pragma mark -
#pragma mark Accessors - UIView LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNavigationBarAppearance];
    [self updateUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Appearance
- (void)updateNavigationBarAppearance {
    self.title = self.viewModel.navigationBarTitle;
}

#pragma mark -
#pragma mark Methods
- (void)updateUI {
    self.textFieldUid.text = self.viewModel.requestUid;
    self.textFieldAPIKey.text = self.viewModel.requestAPIKey;
    self.textFieldAppid.text = self.viewModel.requestAppid;
    [self validateData];
}

- (void)fetchOrders {
    if ([self validateData]) {
       __weak typeof(self) wself = self;
        self.viewState = FYBRequestViewControllerStateLoading;
        [self.viewModel getOffersWithSuccessBlock:^(NSArray *offersArray) {
            wself.viewState = FYBRequestViewControllerStateDefault;
            [wself openAllOffersViewControllerWithDataArray:offersArray];
        } errorBlock:^(NSError *error) {
            wself.viewState = FYBRequestViewControllerStateDefault;
            FYBAlertController *alertCon = [FYBAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:PSTAlertControllerStyleAlert];
            [alertCon addAction:[PSTAlertAction actionWithTitle:@"OK" handler:nil]];
            [alertCon showWithSender:nil controller:wself animated:YES completion:nil];
        }];
        
    }
}

- (BOOL)validateData {
    BOOL validateData = YES;
    if (![[self class] validateTextField:self.textFieldAppid withModelString:self.viewModel.requestAppid]) {
        validateData = NO;
    }
    
    if (![[self class] validateTextField:self.textFieldUid withModelString:self.viewModel.requestUid]) {
        validateData = NO;
    }
    
    if (![[self class] validateTextField:self.textFieldAPIKey withModelString:self.viewModel.requestAPIKey]) {
        validateData = NO;
    }
    self.labelMandatoryFields.hidden = validateData;
    return validateData;
}

- (void)openAllOffersViewControllerWithDataArray:(NSArray *)dataArray {
    FYBAllOffersViewController *vc = [FYBAllOffersViewController controllerWithStoryBoard];
    vc.dataArray = dataArray;
    [self.navigationController pushViewController:vc animated:YES];
}

+ (BOOL)validateTextField:(UITextField *)textField withModelString:(NSString *)modelString {
    BOOL validateTextField = YES;
    
    if ([modelString length]>0) {
        textField.backgroundColor = textFieldBackgroundColor;
    } else {
        textField.backgroundColor = mandatoryTextFieldBackgroundColor;
        validateTextField = NO;
    }
    
    return validateTextField;
}

#pragma mark -
#pragma mark IBActions
- (IBAction)buttonRequestOffersDidTapped:(id)sender {
    [self fetchOrders];
}
- (IBAction)buttonDismissKeyboardDidTapped:(id)sender {
    [self.view endEditing:YES];

}
- (IBAction)navItemResetDidTapped:(id)sender {
    [self.viewModel resetModelWithCompletion:^{
        [self updateUI];
    }];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textFieldUid==textField) {
        [self.textFieldAPIKey becomeFirstResponder];
    } else if (self.textFieldAPIKey==textField) {
        [self.textFieldAppid becomeFirstResponder];
    } else if (self.textFieldAppid==textField) {
        [self.textFieldAppid resignFirstResponder];
        [self fetchOrders];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.textFieldUid==textField) {
        self.viewModel.requestUid = self.textFieldUid.text;
    } else if (self.textFieldAPIKey==textField) {
        self.viewModel.requestAPIKey = self.textFieldAPIKey.text;
    } else if (self.textFieldAppid==textField) {
        self.viewModel.requestAppid = self.textFieldAppid.text;
    }
    
    [self validateData];
}


@end
