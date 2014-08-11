#import "QULoadingIndicatorView.h"
#import "QUViewController.h"

@interface QUViewController ()
@property (weak, nonatomic) IBOutlet QULoadingIndicatorView *loadingIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *animationToggleButton;

@end

@implementation QUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)didTouchUpInsideButton:(UIButton *)button {
    BOOL isAnimating = self.loadingIndicatorView.isAnimating;
    button.selected = !isAnimating;

    if (isAnimating) {
        [self.loadingIndicatorView stopAnimating];
    } else {
        [self.loadingIndicatorView startAnimating];
    }
}

@end
