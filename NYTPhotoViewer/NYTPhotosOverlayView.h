//
//  NYTPhotosOverlayView.h
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 *  A view that overlays an `NYTPhotosViewController`, and houses the left and right bar button items, a title, and a caption view.
 */
@interface NYTPhotosOverlayView : UIView

/**
 *  The internal navigation bar used to set the bar button items and title of the overlay.
 */
@property (nonatomic, readonly) UIView *topBar;

/**
 *  The title of the overlay. Centered between the left and right bar button items.
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
 *  The attributes of the overlay's title.
 */
@property(nonatomic, copy, nullable) NSDictionary <NSString *, id> *titleTextAttributes;

@property(nonatomic, copy, nullable) UIView *leftItemView;
@property(nonatomic, assign) UIEdgeInsets leftItemInsets;

@property(nonatomic, copy, nullable) UIView *rightItemView;
@property(nonatomic, assign) UIEdgeInsets rightItemInsets;

/**
 *  A view representing the caption for the photo, which will be set to full width and locked to the bottom. Can be any `UIView` object, but is expected to respond to `intrinsicContentSize` appropriately to calculate height.
 */
@property (nonatomic, nullable) UIView *captionView;

@end

NS_ASSUME_NONNULL_END
