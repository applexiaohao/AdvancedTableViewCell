//
//  IDPCellBackgroundView.m
//  TableDrawTest
//
//  Created by 能登 要 on 13/05/05.
//  Copyright (c) 2013年 Irimasu Densan Planning. All rights reserved.
//

#import "IDPCellBackgroundView.h"
static UIColor* s_IDPLinkLongPressColor = nil;

@interface IDPCellBackgroundView ()
{
    BOOL _canceldHighlighted;
    NSURL* _activeLinkHref;
}
- (NSURL*) testHighlightedCanceledWithLocation:(CGPoint)location;
@end

@implementation IDPCellBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firedTap:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];

    UILongPressGestureRecognizer* longpressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(firedLongPress:)];
    longpressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:longpressGestureRecognizer];
}

- (void) firedTap:(UITapGestureRecognizer*) tapGestureRecognizer
{
    CGPoint location = [tapGestureRecognizer locationInView:self];
    NSURL* URL = [self testHighlightedCanceledWithLocation:location];
    [_delegate cellBackground:self didSelectURL:URL];
}

- (void) firedShowLinkAction:(NSURL*)URL
{
    [_delegate cellBackground:self didActionURL:URL];
}

- (void) firedLongPress:(UILongPressGestureRecognizer*) longpressGestureRecognizer
{
    switch (longpressGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [longpressGestureRecognizer locationInView:self];
            _activeLinkHref = nil;
            
            NSArray* linkMapCollection = self.linkMapCollection;
            for( NSDictionary* linkMap in linkMapCollection ){
                NSURL* URL = linkMap[kIDPCellBackgroundLinkMapURL];
                NSArray* maps = linkMap[kIDPCellBackgroundLinkMapMaps];
                for( NSDictionary* dic in maps ){
                    NSValue* hittestArea = dic[kIDPCellBackgroundLinkMapHittestArea];
                    CGRect rectHittestArea = [hittestArea CGRectValue];
                    
                    if( CGRectContainsPoint(rectHittestArea, location) ){
                        _activeLinkHref = URL;
                        
                        CGRect rectValidate = CGRectNull;
                        for( NSDictionary* dic in maps ){
                            NSValue* hittestArea = dic[kIDPCellBackgroundLinkMapHittestArea];
                            rectValidate = CGRectUnion(rectValidate, [hittestArea CGRectValue] );
                        }
                        
                        [self setNeedsDisplayInRect:rectValidate];
                        
                        [NSObject cancelPreviousPerformRequestsWithTarget:self];
                        [self performSelector:@selector(firedShowLinkAction:) withObject:URL afterDelay:.5f];
                        
                        break;
                    }
                }
                if( _activeLinkHref != nil )
                    break;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        default:
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(firedShowLinkAction:) object:nil];
            
            NSArray* linkMapCollection = self.linkMapCollection;
            for( NSDictionary* linkMap in linkMapCollection ){
                NSURL* URL = linkMap[kIDPCellBackgroundLinkMapURL];
                if( [[_activeLinkHref absoluteString] isEqualToString:[URL absoluteString]] ){
                    NSArray* maps = linkMap[kIDPCellBackgroundLinkMapMaps];
                    
                    CGRect rectValidate = CGRectNull;
                    for( NSDictionary* dic in maps ){
                        NSValue* hittestArea = dic[kIDPCellBackgroundLinkMapHittestArea];
                        rectValidate = CGRectUnion(rectValidate, [hittestArea CGRectValue] );
                    }
                    [self setNeedsDisplayInRect:rectValidate];
                    break;
                }
            }
            
            _activeLinkHref = nil;
        }
            break;
    }
}

- (NSURL*) testHighlightedCanceledWithLocation:(CGPoint)location
{
    NSArray* linkMapCollection = self.linkMapCollection;
    NSURL* URL = nil;
    for( NSDictionary* linkMap in linkMapCollection ){
        NSArray* maps = linkMap[kIDPCellBackgroundLinkMapMaps];
        for( NSDictionary* dic in maps ){
            NSValue* hittestArea = dic[kIDPCellBackgroundLinkMapHittestArea];
            CGRect rectHittestArea = [hittestArea CGRectValue];
            
            if( CGRectContainsPoint(rectHittestArea, location) ){
                URL = linkMap[kIDPCellBackgroundLinkMapURL];
                break;
            }
        }
        if( URL != nil )
            break;
    }
    return URL;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    _canceldHighlighted = [self testHighlightedCanceledWithLocation:[touch locationInView:self]] != nil ? YES : NO;
    
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    _canceldHighlighted =  [self testHighlightedCanceledWithLocation:[touch locationInView:self]] != nil ? YES : NO;

    [super touchesMoved:touches withEvent:event];
}

- (void) touchesTerminated:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    _canceldHighlighted =  [self testHighlightedCanceledWithLocation:[touch locationInView:self]] != nil ? YES : NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesTerminated:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesTerminated:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self];
    
    if( [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] || [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]){
        NSArray* linkMapCollection = self.linkMapCollection;
        for( NSDictionary* linkMap in linkMapCollection ){
            NSArray* maps = linkMap[kIDPCellBackgroundLinkMapMaps];
            for( NSDictionary* dic in maps ){
                NSValue* hittestArea = dic[kIDPCellBackgroundLinkMapHittestArea];
                CGRect rectHittestArea = [hittestArea CGRectValue];
                
                if( CGRectContainsPoint(rectHittestArea, location) )
                    return YES;
            }
            
        }
        
    }
    return NO;
}

- (NSArray*) linkMapCollection
{
        //    if( _linkMapCollection == nil ){
        //        _linkMapCollection = [NSMutableArray array];
    
        //
        // How to make link map
        //
        // @[
        //   @{
        //      kIDPCellBackgroundLinkMapURL:[description URL]
        //      ,kIDPCellBackgroundLinkMapMaps:@[
        //         kIDPCellBackgroundLinkMapHittestArea:[NSValue valueWithCGRect: ]
        //        ,kIDPCellBackgroundLinkMapDrawArea:[NSValue valueWithCGRect: ]
        //      ]
        //   }
        // ]
        //
        //    }
        //    return _linkMapCollection;
    
    return nil;
}

- (void) setLinkMapCollection:(NSArray *)linkMapCollection
{

}

- (BOOL) highlightedInConsiderationLinks
{
    return _canceldHighlighted ? NO : _highlighted;
}

- (BOOL) hittestLink
{
    return _canceldHighlighted;
}

- (void) drawBackground
{
    const CGFloat height = self.frame.size.height;
    const BOOL highlighted = self.highlightedInConsiderationLinks;
    
    if( _selected != YES && highlighted != YES ){
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        UIColor* strokeColor = [UIColor colorWithRed: 0.824 green: 0.824 blue: 0.824 alpha: 1];
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPath];
        [roundedRectanglePath moveToPoint: CGPointMake(-0.5, height)];
        [roundedRectanglePath addLineToPoint: CGPointMake(319.5, height)];
        [roundedRectanglePath addLineToPoint: CGPointMake(319.5, -0.5)];
        [roundedRectanglePath addLineToPoint: CGPointMake(-0.5, -0.5)];
        [roundedRectanglePath addLineToPoint: CGPointMake(-0.5, height)];
        [roundedRectanglePath closePath];
        [fillColor setFill];
        [roundedRectanglePath fill];
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
        [bezier3Path moveToPoint: CGPointMake(320, height-.5f)];
        [bezier3Path addLineToPoint: CGPointMake(0, height-.5f)];
        [bezier3Path addLineToPoint: CGPointMake(320, height-.5f)];
        [bezier3Path closePath];
        [strokeColor setStroke];
        bezier3Path.lineWidth = 1;
        [bezier3Path stroke];
    }else{
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 0 green: 0.427 blue: 0.933 alpha: 1];
        UIColor* strokeColor = [UIColor colorWithRed: 0.824 green: 0.824 blue: 0.824 alpha: 1];
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPath];
        [roundedRectanglePath moveToPoint: CGPointMake(-0.5, height)];
        [roundedRectanglePath addLineToPoint: CGPointMake(319.5, height)];
        [roundedRectanglePath addLineToPoint: CGPointMake(319.5, -0.5)];
        [roundedRectanglePath addLineToPoint: CGPointMake(-0.5, -0.5)];
        [roundedRectanglePath addLineToPoint: CGPointMake(-0.5, height)];
        [roundedRectanglePath closePath];
        [fillColor setFill];
        [roundedRectanglePath fill];
        
        
        //// Bezier 3 Drawing
        UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
        [bezier3Path moveToPoint: CGPointMake(321.5, height-.5f)];
        [bezier3Path addLineToPoint: CGPointMake(0, height-.5f)];
        [bezier3Path addLineToPoint: CGPointMake(321.5, height-.5f)];
        [bezier3Path closePath];
        [strokeColor setStroke];
        bezier3Path.lineWidth = 1;
        [bezier3Path stroke];
    }
}

- (void) drawLink
{
    // 描画用オブジェクトを初期化
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_IDPLinkLongPressColor = [UIColor colorWithRed: 0 green: 0.392 blue: 0.659 alpha: 0.158];
    });
    
    NSArray* linkMapCollection = self.linkMapCollection;
    for( NSDictionary* linkMap in linkMapCollection ){
        NSURL* URL = linkMap[kIDPCellBackgroundLinkMapURL];
        
        if( [[_activeLinkHref absoluteString] isEqualToString:[URL absoluteString]] ){
            NSArray* maps = linkMap[kIDPCellBackgroundLinkMapMaps];
            for( NSDictionary* dic in maps ){
                NSValue* drawArea = dic[kIDPCellBackgroundLinkMapDrawArea];
                CGRect rectDrawArea = [drawArea CGRectValue];
                
                //// Rectangle Drawing
                UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rectDrawArea cornerRadius: 2];
                [s_IDPLinkLongPressColor setFill];
                [rectanglePath fill];
            }
            break;
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect: call");
    
    [self drawBackground];

    [self drawLink];
}

@end
