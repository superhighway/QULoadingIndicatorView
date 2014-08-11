@interface QULoadingIndicatorView : UIView
@property (strong, nonatomic) NSArray *colors;
@property (nonatomic, readonly, getter = isAnimating) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;
@end
