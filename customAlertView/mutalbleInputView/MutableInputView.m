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
@property (nonatomic,copy)NSString *mark;

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
    
    if ([self.mark isEqualToString:@"1"]) {
        return;
    }
//    [self dismissMutableInputView];

    [self.vc alertViewControllerWithTitle:title btnTitles:btnTitleArr dataArr:inputArr andLeftBlock:^(NSMutableArray *arr) {
        leftBlock(arr);
    } rightBlock:^(NSMutableArray *arr) {
        rightBlock(arr);
    }];
    self.vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    __weak typeof(self) weakSelf = self;
    self.mark = @"0";
    [viewController presentViewController:self.vc animated:NO completion:^{
        weakSelf.mark = @"1";
        weakSelf.vc.view.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }];
}

//- (UIViewController *)viewController:(UIView *)view{
//    /// Finds the view's view controller.
//    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
//    UIResponder *responder = view;
//    while ((responder = [responder nextResponder]))
//        if ([responder isKindOfClass: [UIViewController class]])
//            return (UIViewController *)responder;
//    // If the view controller isn't found, return nil.
//    return nil;
//}
//
//- (UIViewController *)theTopviewControler{
//    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
//    
//    UIViewController *parent = rootVC;
//    
//    while ((parent = rootVC.presentedViewController) != nil ) {
//        rootVC = parent;
//    }
//    
//    while ([rootVC isKindOfClass:[UINavigationController class]]) {
//        rootVC = [(UINavigationController *)rootVC topViewController];
//    }
//    
//    return rootVC;
//}
//
//- (UIViewController *)getPresentedViewController
//{
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    if (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    
//    return topVC;
//}

- (void)dismissMutableInputView {
    self.mark = @"0";
    [self.vc dismissListView];
}

@end
