
#import <UIKit/UIKit.h>

@interface ErrorCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* title;
- (void) setErrorText:(NSString*)text;

@end
