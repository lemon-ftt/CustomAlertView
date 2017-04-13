//
//  MutableInputView.m
//  ECGCustomAlertView
//
//  Created by tan on 2017/3/30.
//  Copyright © 2017年 tantan. All rights reserved.
//

#import "MutableInputView.h"

@interface MutableInputView ()

@property (nonatomic,strong)MutableInputViewController *vc;

@end

@implementation MutableInputView
/// Method definition for 'showMutableInputViewWithTitle:btnTitles:dataArr:andLeftBlock:rightBlock:' not found
static MutableInputView *inputView;
+ (instancetype)shareInstancetype {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inputView = [[MutableInputView alloc] init];
    });
    return inputView;
}

- (MutableInputViewController *)vc {
    if (!_vc) {
        _vc = [[MutableInputViewController alloc]init];
    }
    return _vc;
}

- (void)showMutableInputViewWithUIViewController:(UIViewController *)viewController Title:(NSString *)title btnTitles:(NSArray *)btnTitleArr dataArr:(NSArray *)inputArr andLeftBlock:(Completed)leftBlock rightBlock:(Completed)rightBlock {
    [self dismissMutableInputView];//防止crash
    [self.vc alertViewControllerWithTitle:title btnTitles:btnTitleArr dataArr:inputArr andLeftBlock:^(NSMutableArray *arr) {
        leftBlock(arr);
    } rightBlock:^(NSMutableArray *arr) {
        rightBlock(arr);
    }];
    self.vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    __weak typeof(self) weakSelf = self;
    [viewController presentViewController:self.vc animated:NO completion:^{
        weakSelf.vc.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }];
}

- (void)dismissMutableInputView {
    [self.vc dismissListView];
}

@end
