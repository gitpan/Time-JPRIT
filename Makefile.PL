use ExtUtils::MakeMaker;
WriteMakefile(
	      PREREQ_PM => { Test => 1, },
	      NAME => 'Time',
	      VERSION_FROM => './lib/Time.pm',
	      INC => '-I./lib/Time',
	      H => ['lib/Time/TimeAPI.h'],
);
