//
//  TimeUtils.h
//  BJEducation
//
//  Created by yanglei on 14-7-7.
//  Copyright (c) 2014年 com.bjhl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TYPE_YMDHMS "yyyy-MM-dd HH:mm:ss"
#define TYPE_YMD "yyyy-MM-dd"


const static long long TIME_ONE_DAY_SECOND= 24 * 60 * 60 ;
const static long long TIME_WEEK_SECOND = TIME_ONE_DAY_SECOND * 7;

@interface TimeUtils : NSObject

/*
 获取当前日期
 */
+(NSDate*) getNow;

/*
    获取一个日期，${num} 个星期之后的日期
 */
+(NSDate*) afterDateWeek: (NSDate *)date num:(int) num;

/*
 获取当前日期的年份
*/
+(int) getYear :(NSDate*) date;

/*
  字符串转化为日期
 */
+(NSDate*) parse:(NSString*) string ;

/*
  日期转换为字符串 yyyy-MM-dd
 */
+(NSString*) format:(NSDate*) date;

/*
 日期转换为字符串 MM月dd日
 */
+(NSString*) formatMD:(NSDate*) date;



/*
  获取日期所属当前周的星期几， 周一为第一天.
 */
+(int) getDayInWeek:(NSDate*) date;

/*
    获取日期在当月的第几天
 */
+(int) getDayInMonth:(NSDate*) date;

/*
 
  获取日期所在周，属于哪那一年
 */
+(int) yearOfWeek:(NSDate*) date;

/*
  根据日期，获取所属的周的日期。 从星期一开始
 */
+(NSArray*) thisWeek:(NSDate*) date;

/*
  获取日期所在周是当年的第几周
*/
+(int) weekInYear :(NSDate*) date;

/*
 判断日期是否在当前日期之前
 */
+(BOOL) beforNow:(NSDate *) date;

/*
    判断日期是否在当前日期之后
 */
+(BOOL) afterNow:(NSDate *) date;

/*
    是否是同一天
 */
+(BOOL) isSameDay:(NSDate *)date andDate2:(NSDate *)date2;

/*
 根据时间转换成相应的文字
 */
+ (NSString *) getTimeString: (NSTimeInterval) time;

/*
 根据时间字符串转换成相应的文字 字符串格式：yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)getTimeStringWithStr:(NSString *)aDateStr;

@end
