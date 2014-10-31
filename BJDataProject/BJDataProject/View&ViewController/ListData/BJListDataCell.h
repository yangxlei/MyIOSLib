
#import <UIKit/UIKit.h>

/**
 *  BJListDataViewController 的 cell的根类，所有使用此视图控制器的cell都必须继承这个
 */

@interface BJListDataCell : UITableViewCell
@property (nonatomic,strong,readonly)id infoDic;

-(void)setCellInfo:(NSDictionary*)dic NS_REQUIRES_SUPER;

@end
