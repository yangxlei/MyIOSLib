//
//  BJCodeDefine.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-26.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum _error_code
{
    BJ_ERROR_NETWORK= -1,
    BJ_ERROR_UNKNOW = -100,
    
    BJ_ERROR_REQUEST_FAIL = 0,
    BJ_ERROR_SUCCESSFULL = 1,
    BJ_ERROR_CANCEL = 2,
    BJ_ERROR_OAUTH_LOGIN = 100,
    
    BJ_ERROR_ANOTHER_LOGIN = 1003,
    BJ_ERROR_OAUTH_TOKEN_BROKEN = 1004,
    BJ_ERROR_NEED_REFRESH_OAUTH_TOKEN = 1005,
    
}BJDATA_ERROR_CODE;

typedef enum _status_code
{
    BJ_STATUS_NO_CONNECT_AND_NO_DATA = 0,
    BJ_STATUS_NETWORK_ERROR_AND_NO_DATA = 1,
    BJ_STATUS_EMPTY = 2,
    BJ_STATUS_HAVE_DATA = 3,
//    STATUS_DATA_DELETED = 4,
//    STATUS_NO_PERMISSION = 5,
}BJDATA_STATUS_CODE;

/**
 数据操作类型
 */
typedef enum _ope_code
{
    BJ_OPERATION_REFRESH = 1,
    BJ_OPERATION_GET_MORE = 2,
    BJ_OPERATION_ADD_ITEM = 3,
    BJ_OPERATION_REMOVE_ITEM = 4,
    BJ_OPERATION_SAVE_ITEM = 5,
    BJ_OPERATION_DATA_CHANGED = 6,
    BJ_OPERATION_ALL = 7,
}BJDATA_OPERATION_CODE;
