//
//  TimeUtils.m
//  BJEducation
//
//  Created by yanglei on 14-7-7.
//  Copyright (c) 2014年 com.bjhl. All rights reserved.
//

#import "TimeUtils.h"

#include "CTime.h"

@implementation TimeUtils

+(NSDate*) getNow
{
  long long time = bj_get_mstime();
  NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/1000];
  return date;
}

+(NSDate*) afterDateWeek: (NSDate *)date num:(int) num
{
    long long time = [date timeIntervalSince1970];
    time += num * TIME_WEEK_SECOND;
    return [NSDate dateWithTimeIntervalSince1970:time];
}

/*
 获取当前日期的年份
 */
+(int) getYear :(NSDate*) date
{
  NSCalendar *calendar = [NSCalendar currentCalendar];
 NSDateComponents* components = [calendar components:NSYearCalendarUnit fromDate:date];
  return (int)[components year];
}

/*
 字符串转化为日期
 */
+(NSDate*) parse:(NSString*) string
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@TYPE_YMDHMS];
  
  NSDate * date = [dateFormatter dateFromString:string];
  return date;
}

/*
 日期转换为字符串 yyyy-MM-dd HH:mm:ss
 */
+(NSString*) format:(NSDate*) date
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@TYPE_YMDHMS];
  NSString* string = [dateFormatter stringFromDate:date];
  return string;
}

/*
 日期转换为字符串 yyyy-MM-dd
 */
+(NSString*) formatOnlyDay:(NSDate*) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@TYPE_YMD];
    NSString* string = [dateFormatter stringFromDate:date];
    return string;
}

+(NSString *) formatMD:(NSDate *)date
{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents* comp = [c components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    int month = (int)comp.month;
    int day = (int)comp.day;
    return [NSString stringWithFormat:@"%d月%d日", month, day];
}



/*
 获取日期所属当前周的星期几， 周一为第一天., start from 0;
 */
+(int) getDayInWeek:(NSDate*) date
{
  NSCalendar *c = [NSCalendar currentCalendar];
  NSDateComponents* comp = [c components:NSWeekdayCalendarUnit fromDate:date];
 int week = (int)[comp weekday];
  if (week == 1) {
    week = 6;
  } else {
    week -= 2;
  }
  return week;
}

+(int) getDayInMonth:(NSDate*) date
{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents* comp = [c components:NSDayCalendarUnit fromDate:date];
    return (int)comp.day;
}

/*
 
 获取日期所在周，属于哪一年
 */
+(int) yearOfWeek:(NSDate*) date
{
  long long time = [date timeIntervalSince1970];
  int day = [TimeUtils getDayInWeek:date];
  
  time += (3 - day) * TIME_ONE_DAY_SECOND;
  
  NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
  
  return (int)comp.year;
}

+(NSArray*) thisWeek:(NSDate*) date
{
  
  NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:7];
  int day = [TimeUtils getDayInWeek:date];
  long long time = [date timeIntervalSince1970];
  for (int i = 0; i < 7; ++ i) {
    long long temp = time + (i - day) * TIME_ONE_DAY_SECOND;
    [arr addObject:[NSDate dateWithTimeIntervalSince1970:temp]];
  }
  return arr;
}

+(int) weekInYear :(NSDate*) date
{
  long long time = [date timeIntervalSince1970];
  int day = [TimeUtils getDayInWeek:date];
 time += (3 - day) * TIME_ONE_DAY_SECOND;
  
  NSDateComponents* comp = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
  
  time -= (comp.hour * 3600 + comp.minute * 60 + comp.second);
 
  int year = (int)comp.year;
  
  NSDate *yearDate = [TimeUtils parse:[NSString stringWithFormat:@"%d-01-01 00:00:00", year]];
  long long year_start = [yearDate timeIntervalSince1970];
  
  int weekNo = ceil(((time-year_start)/TIME_ONE_DAY_SECOND + 1)/(double)7);
  
  return weekNo;
}

+(BOOL) beforNow:(NSDate *)date
{
    long long current = bj_get_mstime()/1000;
    long long time = [date timeIntervalSince1970];
    return (current - time) > 0;
}

+(BOOL) afterNow:(NSDate *)date
{
    long long current = bj_get_mstime()/1000;
    long long time = [date timeIntervalSince1970];
    return (time - current) > 0;
}

//yyyy-MM-dd HH:mm
+ (NSString *)getTimeStringWithStr:(NSString *)aDateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:aDateStr];
    return [TimeUtils getTimeString:[date timeIntervalSince1970]];
}

+ (NSString *) getTimeString: (NSTimeInterval) time  {
    NSTimeInterval postTime = time;// - 60 * 60 * 8;
    NSDate* dateNow = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dateNow timeIntervalSince1970] * 1;
    NSTimeInterval diffTime = now - postTime;
    if (diffTime < 0) {
        diffTime = 0;
    }
    
    NSString* strTime = nil;
    
    if (diffTime < 1.0)
    {
        strTime = @"刚刚";
    }
    else if(diffTime / 60 < 1)
    {
        strTime = [NSString stringWithFormat:@"%f", diffTime];
        strTime = [strTime substringToIndex:strTime.length - 7];
        strTime = [NSString stringWithFormat:@"%@秒前", strTime];
    }
    else if(diffTime / 3600 < 1)
    {
        strTime = [NSString stringWithFormat:@"%f", diffTime / 60];
        strTime = [strTime substringToIndex:strTime.length - 7];
        strTime = [NSString stringWithFormat:@"%@分钟前", strTime];
    }
    else if(diffTime / 3600 > 1 && diffTime / 86400 < 1)
    {
        strTime = [NSString stringWithFormat:@"%f", diffTime / 3600];
        strTime = [strTime substringToIndex:strTime.length - 7];
        strTime = [NSString stringWithFormat:@"%@小时前", strTime];
        
    }
    else if(diffTime / 86400 > 1 && diffTime / (86400 * 365) < 1)
    {
        
        if (diffTime / 86400 < 1) {
            NSDate* postDat = [NSDate dateWithTimeIntervalSince1970:postTime];
            NSDateFormatter* form = [[NSDateFormatter alloc] init];
            [form setDateFormat:@"HH:mm"];
            strTime = [form stringFromDate:postDat];
        }
        else if (diffTime / 86400 < 2) {
            NSDate* postDat = [NSDate dateWithTimeIntervalSince1970:postTime];
            NSDateFormatter* form = [[NSDateFormatter alloc] init];
            [form setDateFormat:@"昨天 HH:mm"];
            strTime = [form stringFromDate:postDat];
        }
        else if (diffTime / 86400 < 3) {
            NSDate* postDat = [NSDate dateWithTimeIntervalSince1970:postTime];
            NSDateFormatter* form = [[NSDateFormatter alloc] init];
            [form setDateFormat:@"前天 HH:mm"];
            strTime = [form stringFromDate:postDat];
        }
        else
        {
            NSDate* postDat = [NSDate dateWithTimeIntervalSince1970:postTime];
            NSDateFormatter* form = [[NSDateFormatter alloc] init];
            [form setDateFormat:@"MM-dd HH:mm"];
            strTime = [form stringFromDate:postDat];
        }
    }
    else
    {
        NSDate* postDat = [NSDate dateWithTimeIntervalSince1970:postTime];
        NSDateFormatter* form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"yyyy-MM-dd HH:mm"];
        strTime = [form stringFromDate:postDat];
    }
    return strTime;
}

+(BOOL) isSameDay:(NSDate *)date andDate2:(NSDate *)date2
{
    NSString *str1 = [TimeUtils formatOnlyDay:date];
    NSString *str2 = [TimeUtils formatOnlyDay:date2];
    if ([str1 isEqualToString:str2]) {
        return YES;
    }else
        return NO;
}
@end
