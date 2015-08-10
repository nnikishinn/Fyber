//
//  FYBAllOffersViewController.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBAllOffersViewController.h"
#import "FYBOfferCell.h"
#import "FyberSDK.h"

typedef NS_ENUM(NSUInteger, FYBFYBAllOffersViewControllerState) {
    FYBAllOffersViewControllerStateNoData          = 0,
    FYBAllOffersViewControllerStateDefault,
};

@interface FYBAllOffersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewNoData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) FYBFYBAllOffersViewControllerState viewState;
@end

@implementation FYBAllOffersViewController

#pragma mark -
#pragma mark Accessors - Setters
- (void)setViewState:(FYBFYBAllOffersViewControllerState)viewState {
    
    switch (viewState) {
        case FYBAllOffersViewControllerStateNoData:
        {
            self.tableView.hidden = YES;
            self.viewNoData.hidden = NO;
            
        }
            break;
            
        default:
        {
            self.tableView.hidden = NO;
            self.viewNoData.hidden = YES;
        }
            break;
    }
    
    _viewState = viewState;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UIView LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNavigationBarAppearance];
    [self setupTableView];
}

- (void)setupTableView {
    [self.tableView registerNib:[FYBOfferCell nibCell] forCellReuseIdentifier:[FYBOfferCell reuseIdentifier]];
    [self.tableView setEstimatedRowHeight:[FYBOfferCell defaultCellHeight]];
    [self.tableView setRowHeight:[FYBOfferCell defaultCellHeight]];
}

#pragma mark -
#pragma mark Appearance
- (void)updateNavigationBarAppearance {
    self.title = @"Offers";
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYBOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                NSStringFromClass([FYBOfferCell class])];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = [self.dataArray count];
    
    self.viewState = numberOfRows ? FYBAllOffersViewControllerStateDefault : FYBAllOffersViewControllerStateNoData;
    
    return numberOfRows;
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)anIndexPath {
    NSDictionary *offerDict = self.dataArray[anIndexPath.row];
    FYBOfferObject *offerObject = [FYBOfferObject offerObjectFromJSON:offerDict];
    FYBOfferCell *cell = (FYBOfferCell *)aCell;
    [cell updateWithObject:offerObject];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FYBOfferCell defaultCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FYBOfferCell defaultCellHeight];
}


@end
