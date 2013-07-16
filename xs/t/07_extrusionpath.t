#!/usr/bin/perl

use strict;
use warnings;

use Slic3r::XS;
use Test::More tests => 7;

my $points = [
    [100, 100],
    [200, 100],
    [200, 200],
];

my $path = Slic3r::ExtrusionPath->new(
    polyline => Slic3r::Polyline->new(@$points),
    role     => Slic3r::ExtrusionPath::EXTR_ROLE_EXTERNAL_PERIMETER,
);
isa_ok $path->polyline, 'Slic3r::Polyline', 'path polyline';
is_deeply $path->polyline->pp, $points, 'path points roundtrip';

$path->reverse;
is_deeply $path->polyline->pp, [ reverse @$points ], 'reverse path';

$path->append([ 150, 150 ]);
is scalar(@$path), 4, 'append to path';

$path->pop_back;
is scalar(@$path), 3, 'pop_back from path';

$path = $path->clone;

is $path->role, Slic3r::ExtrusionPath::EXTR_ROLE_EXTERNAL_PERIMETER, 'role';
$path->role(Slic3r::ExtrusionPath::EXTR_ROLE_FILL);
is $path->role, Slic3r::ExtrusionPath::EXTR_ROLE_FILL, 'modify role';

__END__
