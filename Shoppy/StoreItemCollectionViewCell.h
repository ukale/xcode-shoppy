//
//  StoreItemCollectionViewCell.h
//  Shoppy
//
//  Created by Admin Dev on 6/6/17.
//  Copyright © 2017 Kinetic Bytes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreItemCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView* imageContainerView;
@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@property (strong, nonatomic) IBOutlet UIImageView* soldImageView;
@property (strong, nonatomic) IBOutlet UILabel* lblName;
@property (strong, nonatomic) IBOutlet UILabel* lblPrice;

@end
