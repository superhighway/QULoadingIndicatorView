#import <QuartzCore/QuartzCore.h>
#import "QUThunderView.h"

@interface QUThunderLayer : CALayer
- (void)setupContent;
@end

@interface QUThunderLayer ()
@property (strong, nonatomic) CAShapeLayer *leftTriangleLayer;
@property (strong, nonatomic) CAShapeLayer *rightTriangleLayer;
@end

@implementation QUThunderLayer

- (void)setupContent {
    self.backgroundColor = [UIColor clearColor].CGColor;
    [self setupLeftTriangle];
    [self setupRightTriangle];
}

- (void)setupLeftTriangle {
    self.leftTriangleLayer = [CAShapeLayer layer];
    self.leftTriangleLayer.fillColor = [UIColor whiteColor].CGColor;
    UIBezierPath *triangle = [UIBezierPath bezierPath];

    CGFloat minX = 0, minY = 0;
    CGFloat maxX = CGRectGetMidX(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds)*0.66;
    [triangle moveToPoint:(CGPoint){maxX, minY}];
    [triangle addLineToPoint:(CGPoint){maxX, maxY}];
    [triangle addLineToPoint:(CGPoint){minX, maxY}];
    [triangle closePath];
    self.leftTriangleLayer.path = triangle.CGPath;

    [self addSublayer:self.leftTriangleLayer];
}

- (void)setupRightTriangle {
    self.rightTriangleLayer = [CAShapeLayer layer];
    self.rightTriangleLayer.fillColor = [UIColor whiteColor].CGColor;

    UIBezierPath *triangle = [UIBezierPath bezierPath];

    CGFloat minX = CGRectGetMidX(self.bounds), minY = CGRectGetMaxY(self.bounds)*0.33;
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    [triangle moveToPoint:(CGPoint){minX, minY}];
    [triangle addLineToPoint:(CGPoint){maxX, minY}];
    [triangle addLineToPoint:(CGPoint){minX, maxY}];
    [triangle closePath];
    self.rightTriangleLayer.path = triangle.CGPath;

    [self addSublayer:self.rightTriangleLayer];
}

@end


@implementation QUThunderView

- (void)awakeFromNib {
    [super awakeFromNib];
    QUThunderLayer *layer = [QUThunderLayer layer];
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    [layer setupContent];
}

@end
