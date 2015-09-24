//
// Created by Petr Korolev on 11/08/14.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>


@interface SWActionSheet : UIView
{
     UIView *view;
}
@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIView *view;

- (void)dismissWithClickedButtonIndex:(int)i animated:(BOOL)animated;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

- (id)initWithView:(UIView *)view;
- (void)showInContainerView;
@end