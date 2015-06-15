//
//  LFOActionCollectionViewCell.h
//  TestTechnique
//
//  Created by Jeremie Janoir on 14/06/15.
//  Copyright (c) 2015 Jeremie Janoir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFOActionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *pictures;
@property (weak, nonatomic) IBOutlet UIButton *rate;
@property (weak, nonatomic) IBOutlet UIButton *map;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateCountLabel;

@end
