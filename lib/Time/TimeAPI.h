#ifndef _time_api_H_
#define _time_api_H_

#define TIME_API_VERSION 1

struct TimeAPI {
  IV Version;

  /* try to be flexible about the representation */
  I32     (*now_i32)();
  U32     (*now_u32)();
  double  (*now_d)();
  SV *    (*now_sv)();

  void    (*sleep)(double delay, int can_interrupt);
};

#define FETCH_TIME_API(YourName, api)					\
STMT_START {								\
  SV *sv = perl_get_sv("Time::API",0);					\
  if (!sv) croak("Time::API not found");				\
  api = (struct TimeAPI*) SvIV(sv);					\
  if (api->Version != TIME_API_VERSION) {				\
    croak("Time::API version mismatch -- you must recompile %s",	\
	  YourName);							\
  }									\
} STMT_END

#endif
