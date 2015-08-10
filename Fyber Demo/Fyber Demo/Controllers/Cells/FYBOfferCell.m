//
//  FYBOfferCell.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBOfferCell.h"
#import "FYBOfferObject.h"
#import "UIImageView+AFNetworking.h"

@interface FYBOfferCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewThumb;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelPayout;
@property (weak, nonatomic) IBOutlet UILabel *labelTeaser;

@end


@implementation FYBOfferCell

+ (CGFloat)defaultCellHeight {
    return 87.0;
}

- (void)updateWithObject:(FYBOfferObject *)offerObject {
    self.labelTitle.text = offerObject.title;
    self.labelTeaser.text = offerObject.teaser;
    self.labelPayout.text = [NSString stringWithFormat:@"%@", @([offerObject.payout integerValue])];
    
    if (offerObject.thumbnail_hires_url) {
        [self.imageViewThumb setImageWithURL:offerObject.thumbnail_hires_url];
    } else {
        self.imageViewThumb.image = nil;
    }
}

@end
