//
//  CustomCell.m
//  ReaderTest
//
//  Created by 能登 要 on 13/06/07.
//
//

#import "CustomCell.h"
#import "CustomBackgroundView.h"

@interface CustomCell () <IDPCellBackgroundViewDelegate>

@end

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if( _cellBackgroundView.hittestLink != YES ){
        NSLog(@"setSelected: selected=%@", selected ? @"YES" : @"NO");
        [super setSelected:selected animated:animated];
        [_cellBackgroundView setSelected:selected];
        [_cellBackgroundView setNeedsDisplay];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if( _cellBackgroundView.hittestLink != YES ){
        NSLog(@"setSelected: call");
        [super setHighlighted:highlighted animated:animated];
        [_cellBackgroundView setHighlighted:highlighted];
        [_cellBackgroundView setNeedsDisplay];
    }
}

- (void )cellBackground:(IDPCellBackgroundView*)IDPCellBackgroundView didSelectURL:(NSURL*)URL
{
    [_delegate customCell:self didSelectURL:URL];
}

- (void )cellBackground:(IDPCellBackgroundView*)IDPCellBackgroundView didActionURL:(NSURL*)URL
{
    [_delegate customCell:self didActionURL:URL];
}

@end
