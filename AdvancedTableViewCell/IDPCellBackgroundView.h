//
//  IDPCellBackgroundView.h
//  TableDrawTest
//
//  Created by 能登 要 on 13/05/05.
//  Copyright (c) 2013年 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kIDPCellBackgroundLinkMapURL @"URL"
#define kIDPCellBackgroundLinkMapMaps @"maps"
#define kIDPCellBackgroundLinkMapHittestArea @"hittestArea"
#define kIDPCellBackgroundLinkMapDrawArea @"drawArea"

@protocol IDPCellBackgroundViewDelegate;

@interface IDPCellBackgroundView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) BOOL highlighted;
@property (nonatomic,readonly) BOOL highlightedInConsiderationLinks;
@property (nonatomic,readonly) BOOL hittestLink;
@property (nonatomic,weak) IBOutlet id<IDPCellBackgroundViewDelegate> delegate;
@property(nonatomic,getter=linkMapCollection,setter=setLinkMapCollection:) NSArray* linkMapCollection;

// drawRect: method. 
- (void) drawBackground;
- (void) drawLink;

@end

@protocol IDPCellBackgroundViewDelegate <NSObject>
- (void )cellBackground:(IDPCellBackgroundView*)IDPCellBackgroundView didSelectURL:(NSURL*)URL;
- (void )cellBackground:(IDPCellBackgroundView*)IDPCellBackgroundView didActionURL:(NSURL*)URL;
@end