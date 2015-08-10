//
//  FYBBaseCell.m
//  Fyber Demo
//
//  Created by Nickolai Nikishin on 8/8/15.
//  Copyright (c) 2015 Nickolai Nikishin. All rights reserved.
//

#import "FYBBaseCell.h"

@implementation FYBBaseCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (UINib *)nibCell {
    UINib *cellNib = [UINib nibWithNibName:[self reuseIdentifier] bundle:nil];
    return cellNib;
}

+ (CGFloat)defaultCellHeight {
    return 42.0f;
}

@end
