
#import "NoDataCell.h"

@implementation NoDataCell
@synthesize infoLableView;

- (void) setNodataText:(NSString*)text
{
    infoLableView.text = text;
}


-(void) viewLoadFromNib:(id)params
{
  UIView* view = [[UIView alloc] initWithFrame:self.frame];
  //view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:240.0/255.0 blue:237.0/255.0 alpha:1.0];
  //view.backgroundColor = [UIColor blackColor];
  self.backgroundView = view;
}
@end
