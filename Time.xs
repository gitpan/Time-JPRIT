#define MIN_PERL_DEFINE 1

#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include "TimeAPI.h"

/*-----------------------------------------------------*/

#ifdef WIN32
#include <time.h>
#else
#include <sys/time.h>
#endif

/* Shamelessly stolen from Time::HiRes! XXX */

#if !defined(HAS_GETTIMEOFDAY) && defined(WIN32)
#define HAS_GETTIMEOFDAY

/* shows up in winsock.h?
struct timeval {
 long tv_sec;
 long tv_usec;
}
*/

static int gettimeofday (struct timeval *tp, void *nothing)
{
 SYSTEMTIME st;
 time_t tt;
 struct tm tmtm;
 /* mktime converts local to UTC */
 GetLocalTime (&st);
 tmtm.tm_sec = st.wSecond;
 tmtm.tm_min = st.wMinute;
 tmtm.tm_hour = st.wHour;
 tmtm.tm_mday = st.wDay;
 tmtm.tm_mon = st.wMonth - 1;
 tmtm.tm_year = st.wYear - 1900;
 tmtm.tm_isdst = -1;
 tt = mktime (&tmtm);
 tp->tv_sec = tt;
 tp->tv_usec = st.wMilliseconds * 1000;
 return 1;
}
#endif

/*-----------------------------------------------------*/

static SV *NowSV;
static double *NowDouble;

static void cache_now()
{
  struct timeval now_tm;
  gettimeofday(&now_tm, 0);
  *NowDouble = now_tm.tv_sec + now_tm.tv_usec / 1000000.0;
}

static I32 default_now_i32()
{
  cache_now();
  return (I32) *NowDouble;
}

static U32 default_now_u32()
{
  cache_now();
  return (U32) *NowDouble;
}

static double default_now_d()
{
  cache_now();
  return *NowDouble;
}

static SV *default_now_sv()
{
  cache_now();
  return NowSV;
}

#include <unistd.h>
static void default_sleep(double tm, int can_intr)
{
  sleep(tm);  /* should replace with fractional sleep XXX */
}

/*-----------------------------------------------------*/
static struct TimeAPI api;

MODULE = Time		PACKAGE = Time

PROTOTYPES: DISABLE

BOOT:
  NowSV = perl_get_sv("Time::Now", 1);
  sv_setnv(NowSV, 0);
  SvREADONLY_on(NowSV);
  NowDouble = &SvNVX(NowSV); /* leaks memory XXX */
  {
    SV *apisv;
    api.Version = TIME_API_VERSION;
    api.now_i32 = default_now_i32;
    api.now_u32 = default_now_u32;
    api.now_d = default_now_d;
    api.now_sv = default_now_sv;
    api.sleep = default_sleep;
    apisv = perl_get_sv("Time::API", 1);
    sv_setiv(apisv, (IV)&api);
    SvREADONLY_on(apisv);
  }
  (void) api.now_sv(); /*initialize*/

void
time()
	PPCODE:
	XPUSHs(api.now_sv());

void
sleep(howlong)
	double howlong
	PPCODE:
	api.sleep(howlong, 1);
