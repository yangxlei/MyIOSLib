
#import <UIKit/UIKit.h>

@interface NoDataCell : UITableViewCell

- (void) setNodataText:(NSString*)text;
@property (nonatomic, strong) IBOutlet UILabel *infoLableView;
@property (nonatomic, strong) IBOutlet UIButton *button;
@end
