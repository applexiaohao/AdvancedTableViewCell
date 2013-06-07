//
//  CustomCell.h
//  ReaderTest
//
//  Created by 能登 要 on 13/06/07.
//
//

#import <UIKit/UIKit.h>

@class CustomBackgroundView;
@protocol CustomCellDelegate;

@interface CustomCell : UITableViewCell

@property(nonatomic,weak) IBOutlet id<CustomCellDelegate> delegate;
@property(nonatomic,weak) IBOutlet CustomBackgroundView* cellBackgroundView;

@end

@protocol CustomCellDelegate <NSObject>

- (void) customCell:(CustomCell*)customCell didSelectURL:(NSURL*)URL;
- (void) customCell:(CustomCell*)customCell didActionURL:(NSURL*)URL;

@end

