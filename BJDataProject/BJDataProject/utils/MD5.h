//
//  MD5.h
//  BJDataProject
//
//  Created by 杨磊 on 14-10-27.
//  Copyright (c) 2014年 杨磊. All rights reserved.
//

#ifndef __BJDataProject__MD5__
#define __BJDataProject__MD5__

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct
{
    unsigned int count[2];
    unsigned int state[4];
    unsigned char buffer[64];
}BJ_MD5_CTX;


#define F(x,y,z) ((x & y) | (~x & z))
#define G(x,y,z) ((x & z) | (y & ~z))
#define H(x,y,z) (x^y^z)
#define I(x,y,z) (y ^ (x | ~z))
#define ROTATE_LEFT(x,n) ((x << n) | (x >> (32-n)))
#define FF(a,b,c,d,x,s,ac) \
{ \
    a += F(b,c,d) + x + ac; \
    a = ROTATE_LEFT(a,s); \
    a += b; \
}
#define GG(a,b,c,d,x,s,ac) \
{ \
    a += G(b,c,d) + x + ac; \
    a = ROTATE_LEFT(a,s); \
    a += b; \
}
#define HH(a,b,c,d,x,s,ac) \
{ \
    a += H(b,c,d) + x + ac; \
    a = ROTATE_LEFT(a,s); \
    a += b; \
}
#define II(a,b,c,d,x,s,ac) \
{ \
    a += I(b,c,d) + x + ac; \
    a = ROTATE_LEFT(a,s); \
    a += b; \
}
void BJ_MD5Init(BJ_MD5_CTX *context);
void BJ_MD5Update(BJ_MD5_CTX *context,unsigned char *input,unsigned int inputlen);
void BJ_MD5Final(BJ_MD5_CTX *context,unsigned char digest[16]);
void BJ_MD5Transform(unsigned int state[4],unsigned char block[64]);
void BJ_MD5Encode(unsigned char *output,unsigned int *input,unsigned int len);
void BJ_MD5Decode(unsigned int *output,unsigned char *input,unsigned int len);
    
    void BJ_md5_encode_str(char *result, unsigned char *src);
    
#ifdef __cplusplus
}
#endif

#endif /* defined(__BJDataProject__MD5__) */
