//
//  NYTPhotosOverlayView.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "NYTPhotosOverlayView.h"
#import "NYTPhotoCaptionViewLayoutWidthHinting.h"

@interface NYTPhotosOverlayView ()

@property (nonatomic) UIView *topBar;

@end

@implementation NYTPhotosOverlayView

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupTopBar];
    }
    
    return self;
}

// Pass the touches down to other views: http://stackoverflow.com/a/8104378
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self) {
        return nil;
    }
    
    return hitView;
}

- (void)layoutSubviews {
    // The navigation bar has a different intrinsic content size upon rotation, so we must update to that new size.
    // Do it without animation to more closely match the behavior in `UINavigationController`
    [UIView performWithoutAnimation:^{
        [self.topBar invalidateIntrinsicContentSize];
        [self.topBar layoutIfNeeded];
    }];
    
    [super layoutSubviews];

    if ([self.captionView conformsToProtocol:@protocol(NYTPhotoCaptionViewLayoutWidthHinting)]) {
        [(id<NYTPhotoCaptionViewLayoutWidthHinting>) self.captionView setPreferredMaxLayoutWidth:self.bounds.size.width];
    }
    
    if (_leftItemView) {
        _leftItemView.frame = CGRectMake(_leftItemInsets.left,
                                         _leftItemInsets.top,
                                         _leftItemView.bounds.size.width,
                                         _leftItemView.bounds.size.height);
    }
    if (_rightItemView) {
        _rightItemView.frame = CGRectMake(self.bounds.size.width - _rightItemView.bounds.size.width - _rightItemInsets.right,
                                         _rightItemInsets.top,
                                         _rightItemView.bounds.size.width,
                                         _rightItemView.bounds.size.height);
    }
}

#pragma mark - NYTPhotosOverlayView

- (void)setupTopBar {
    self.leftItemInsets = UIEdgeInsetsMake(32, 8, 0, 0);
    self.rightItemInsets = UIEdgeInsetsMake(32, 0, 0, 8);
    
    self.topBar = [[UIView alloc] init];
    self.topBar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    self.topBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.topBar];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:64.0];
    NSLayoutConstraint *horizontalPositionConstraint = [NSLayoutConstraint constraintWithItem:self.topBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self addConstraints:@[topConstraint, widthConstraint, horizontalPositionConstraint]];
    [self.topBar addConstraint:heightConstraint];
}

- (void)setCaptionView:(UIView *)captionView {
    if (self.captionView == captionView) {
        return;
    }
    
    [self.captionView removeFromSuperview];
    
    _captionView = captionView;
    
    self.captionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.captionView];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.captionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.captionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *horizontalPositionConstraint = [NSLayoutConstraint constraintWithItem:self.captionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self addConstraints:@[bottomConstraint, widthConstraint, horizontalPositionConstraint]];
}

-(void)setLeftItemView:(UIView *)leftItemView {
    [_leftItemView removeFromSuperview];
    _leftItemView = leftItemView;
    [self.topBar addSubview:leftItemView];
    [self setNeedsLayout];
}

-(void)setLeftItemInsets:(UIEdgeInsets)leftItemInsets {
    _leftItemInsets = leftItemInsets;
    [self setNeedsLayout];
}

-(void)setRightItemView:(UIView *)rightItemView {
    [_rightItemView removeFromSuperview];
    _rightItemView = rightItemView;
    [self.topBar addSubview:rightItemView];
    [self setNeedsLayout];
}

-(void)setRightItemInsets:(UIEdgeInsets)rightItemInsets {
    _rightItemInsets = rightItemInsets;
    [self setNeedsLayout];
}

@end
