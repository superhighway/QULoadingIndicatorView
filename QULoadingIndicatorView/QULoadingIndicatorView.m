#import "QUThunderView.h"
#import "QUAlternatingCirclesView.h"
#import "QULoadingIndicatorView.h"

@interface QULoadingIndicatorView ()
@property (weak, nonatomic) IBOutlet QUAlternatingCirclesView *alternatingCirclesView;
@property (weak, nonatomic) IBOutlet QUThunderView *thunderView;

@end

@implementation QULoadingIndicatorView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self stopAnimating];
}

- (void)setColors:(NSArray *)colors {
    self.alternatingCirclesView.colors = colors;
}

- (NSArray *)colors {
    return self.alternatingCirclesView.colors;
}

- (BOOL)isAnimating {
    return self.alternatingCirclesView.isAnimating;
}

- (void)startAnimating {
    [self.alternatingCirclesView startAnimating];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.thunderView.alpha = 1;
    }];
}

- (void)stopAnimating {
    [self.alternatingCirclesView stopAnimating];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.thunderView.alpha = 0;
    }];
}

@end
