use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'DR::Template',
    VERSION_FROM      => 'lib/DR/Template.pm', # finds $VERSION
    PREREQ_PM         => {
    },
    ABSTRACT_FROM  => 'lib/DR/Template.pm', # retrieve abstract from module
    AUTHOR         => 'Dmitry E. Oboukhov <unera@debian.org>',

    BUILD_REQUIRES      => {
    },
    LICENSE           => 'Artistic License'
);

if (open my $file, '+<', 'Makefile') {
    my @lines = <$file>;
    seek $file, 0, 0;
    truncate $file, 0;
    for (@lines) {
        $_ = "TEST_VERBOSE=1\n" if /^TEST_VERBOSE\s*=\s*.*/;
        print $file $_;
    }

    print $file "\n\nTemplate.xs: Template.rl\n";
    print $file "\tragel -C \$< -o \$@\n";
}
