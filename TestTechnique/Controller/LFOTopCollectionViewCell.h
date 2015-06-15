//
//  LFOTopCollectionViewCell.h
//  TestTechnique
//
//  Created by Jeremie Janoir on 14/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFOTopCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *share;
@property (weak, nonatomic) IBOutlet UIButton *fav;

@end
