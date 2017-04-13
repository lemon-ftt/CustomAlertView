//
//  ListTableViewCell.h
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/24.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"

@protocol  ListTableViewCellDelegate <NSObject>

- (void)callbackInputContent:(NSString  *)text index:(NSInteger)index ;

@end

@interface ListTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak) id<ListTableViewCellDelegate>delegate;

- (void)setupUIWithIndex:(NSInteger)index;

- (void)setDataWith:(ListModel *)model;

@end
