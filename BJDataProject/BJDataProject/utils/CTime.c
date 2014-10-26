#include <time.h>
#include <stdio.h>
#include <sys/time.h>

#include "CTime.h"


long long bj_get_time()
{
	return (long long)time(NULL);
}

int bj_time_from(int t)
{
    return (int)time(NULL) - t;
}

long long bj_get_mstime()
{
	struct timeval t;
	gettimeofday(&t, NULL);
    unsigned long long temp = t.tv_sec;
    temp *= 1000;
    temp += t.tv_usec/1000;
	return temp;
}
