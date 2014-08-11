#import "QUAlternatingCirclesView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (QUFlatUIColors)
+ (NSArray *)flatUIColors;
@end

@implementation UIColor (QUFlatUIColors)

+ (NSArray *)flatUIColors
{
    return @[
             UIColorFromRGB(0x1abc9c),
             UIColorFromRGB(0x2ecc71),
             UIColorFromRGB(0x3498db),
             UIColorFromRGB(0x9b59b6),
             UIColorFromRGB(0x34495e),
             UIColorFromRGB(0x16a085),
             UIColorFromRGB(0x27ae60),
             UIColorFromRGB(0x2980b9),
             UIColorFromRGB(0x8e44ad),
             UIColorFromRGB(0x2c3e50),
             UIColorFromRGB(0xf1c40f),
             UIColorFromRGB(0xe67e22),
             UIColorFromRGB(0xe74c3c),
             UIColorFromRGB(0xecf0f1),
             UIColorFromRGB(0x95a5a6),
             UIColorFromRGB(0xf39c12),
             UIColorFromRGB(0xd35400),
             UIColorFromRGB(0xc0392b),
             UIColorFromRGB(0xbdc3c7),
             UIColorFromRGB(0x7f8c8d)
             ];
}

@end



@interface QUAlternatingCirclesView ()
@property (nonatomic, getter = isAnimating) BOOL animating;

@property (strong, nonatomic) NSArray *colorLayers;
@property (nonatomic) NSInteger animatingColorLayerIndex;

@property (strong, nonatomic, readonly) CALayer *backColorLayer;
@property (strong, nonatomic, readonly) CALayer *animatingColorLayer;
@property (strong, nonatomic, readonly) CALayer *frontColorLayer;

@property (nonatomic) NSInteger nextColorIndex;


@end

@implementation QUAlternatingCirclesView

- (CALayer *)backColorLayer
{
    NSInteger backLayerIndex = self.animatingColorLayerIndex - 1;
    if (backLayerIndex < 0) backLayerIndex += self.colorLayers.count;
    return self.colorLayers[backLayerIndex];
}

- (CALayer *)animatingColorLayer
{
    return self.colorLayers[self.animatingColorLayerIndex];
}

- (CALayer *)frontColorLayer
{
    NSInteger frontLayerIndex = (self.animatingColorLayerIndex + 1) % self.colorLayers.count;
    return self.colorLayers[frontLayerIndex];
}

- (NSArray *)colors
{
    if (!_colors) {
        _colors = [UIColor flatUIColors];
    }

    return _colors;
}

#pragma mark - Start/Stop Animation

- (void)startAnimating
{
    [self prepareLayers];

    self.animating = YES;
    [self animateFirst];
}

- (void)stopAnimating
{
    NSTimeInterval duration = 0.3;

    for (CALayer *layer in self.colorLayers) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.fromValue = @1;
        anim.toValue = @0;
        anim.duration = duration;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.delegate = self;
        [layer addAnimation:anim forKey:anim.keyPath];
    }

    self.animating = NO;
}

#pragma mark - Layers

- (void)prepareLayers
{
    self.colorLayers = @[[CALayer layer], [CALayer layer], [CALayer layer]];
    self.clipsToBounds = YES;

    NSArray *colors = self.colors;
    NSInteger colorsCount = colors.count;
    NSInteger colorIndex = 0;
    for (NSInteger colorLayerIndex = self.colorLayers.count - 1; colorLayerIndex >= 0; --colorLayerIndex) {
        CALayer *layer = self.colorLayers[colorLayerIndex];
        layer.backgroundColor = [colors[colorIndex % colorsCount] CGColor];
        layer.frame = self.layer.bounds;
        layer.masksToBounds = YES;
        layer.cornerRadius = layer.frame.size.width/2;
        layer.transform = CATransform3DMakeScale(0, 0, 0);
        [self.layer addSublayer:layer];
        ++colorIndex;
    }
}

- (void)animateFirst
{
    self.animatingColorLayerIndex = 2;
    self.nextColorIndex = 3;

    [self animateColor];
}

- (void)animateNext
{
    CALayer *backColorLayer = self.backColorLayer;
    backColorLayer.transform = CATransform3DMakeScale(0, 0, 0);
    [self.layer addSublayer:backColorLayer];

    CALayer *frontColorLayer = self.frontColorLayer;
    frontColorLayer.transform = CATransform3DMakeScale(0, 0, 0);
    frontColorLayer.backgroundColor = [self.colors[self.nextColorIndex % self.colors.count] CGColor];

    self.animatingColorLayerIndex = (self.animatingColorLayerIndex - 1);
    if (self.animatingColorLayerIndex < 0) self.animatingColorLayerIndex += self.colorLayers.count;
    self.nextColorIndex = (self.nextColorIndex + 1) % self.colors.count;

    [self animateColor];
}

- (void)animateColor
{
    NSTimeInterval duration = 0.7;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)];
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    anim.duration = duration;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.delegate = self;
    [self.animatingColorLayer addAnimation:anim forKey:anim.keyPath];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (finished) {
        if (self.isAnimating) {
            [self animateNext];
        } else {
            for (CALayer *colorLayer in self.colorLayers) {
                [colorLayer removeFromSuperlayer];
            }
        }
    }
}

@end
