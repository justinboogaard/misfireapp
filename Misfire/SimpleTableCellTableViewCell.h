//
//  SimpleTableCellTableViewCell.h
//  Misfire
//
//  Created by Justin Boogaard on 4/5/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCellTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;


@end
