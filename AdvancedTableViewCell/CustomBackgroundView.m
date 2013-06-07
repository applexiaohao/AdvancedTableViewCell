//
//  CustomBackgroundView.m
//  ReaderTest
//
//  Created by 能登 要 on 13/06/07.
//
//

#import "CustomBackgroundView.h"

@interface CustomBackgroundView ()
{
    NSMutableArray* _linkMapCollection;
}
@end

@implementation CustomBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawBackground];
    
    [self drawLink];
}

- (NSArray*) linkMapCollection
{
    if( _linkMapCollection == nil ){
        _linkMapCollection =
        
        _linkMapCollection = [NSMutableArray arrayWithArray:@[
           @{
              kIDPCellBackgroundLinkMapURL:[NSURL URLWithString:@"http://irimasu.com"]
              ,kIDPCellBackgroundLinkMapMaps:@[@{
                 kIDPCellBackgroundLinkMapHittestArea:[NSValue valueWithCGRect:CGRectMake(40.0f,39.0f, 142.0f, 21.0f)]
                ,kIDPCellBackgroundLinkMapDrawArea:[NSValue valueWithCGRect:CGRectMake(40.0f,39.0f, 142.0f, 21.0f) ]
             }]
           }
       ]];
    }
    return _linkMapCollection;
}

- (void) setLinkMapCollection:(NSArray *)linkMapCollection
{
    // nil が渡される事を期待した実装(主に初期化用
    _linkMapCollection = linkMapCollection != nil ? [NSMutableArray arrayWithArray:linkMapCollection] : nil;
}

@end
