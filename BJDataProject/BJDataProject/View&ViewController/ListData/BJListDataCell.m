
#import "BJListDataCell.h"

@interface BJListDataCell ()
@end

@implementation BJListDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

-(void)setCellInfo:(NSDictionary*)dic
{
    _infoDic = dic;
}

@end
