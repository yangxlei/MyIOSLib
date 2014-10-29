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
    ERROR_NETWORK= -1,
    ERROR_UNKNOW = -100,
    
    ERROR_REQUEST_FAIL = 0,
    ERROR_SUCCESSFULL = 1,
    ERROR_CANCEL = 2,
    ERROR_OAUTH_LOGIN = 100,
    
    ERROR_ANOTHER_LOGIN = 1003,
    ERROR_OAUTH_TOKEN_BROKEN = 1004,
    ERROR_NEED_REFRESH_OAUTH_TOKEN = 1005,
    
}BJDATA_ERROR_CODE;

typedef enum _status_code
{
    STATUS_NO_CONNECT_AND_NO_DATA = 0,
    STATUS_NETWORK_ERROR_AND_NO_DATA = 1,
    STATUS_EMPTY = 2,
    STATUS_HAVE_DATA = 3,
//    STATUS_DATA_DELETED = 4,
//    STATUS_NO_PERMISSION = 5,
}BJDATA_STATUS_CODE;

typedef enum _ope_code
{
    OPERATION_REFRESH = 1,
    OPERATION_GET_MORE = 2,
}BJDATA_OPERATION_CODE;
