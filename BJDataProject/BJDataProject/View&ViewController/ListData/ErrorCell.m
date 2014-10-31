
#import "ErrorCell.h"

@implementation ErrorCell
@synthesize title;

- (void) setErrorText:(NSString*)text
{
    [title setText:text];
}


-(void) viewLoadFromNib:(id)params
{
  UIView* view = [[UIView alloc] initWithFrame:self.frame];
  view.backgroundColor = [UIColor clearColor];
  //view.backgroundColor = [UIColor blackColor];
  self.backgroundView = view;
}

@end
