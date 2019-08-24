#!/usr/bin/perl 
package Logging;
use Time::Piece;

sub new 
{
   my $class = shift;
   my $self = {
      };
   bless $self, $class;
   return $self;
}

sub AddLog {
    my $file_handle  = shift;
    my $message      = shift;

    my $time = gmtime();;
    my $logline = $time."\s".$message;
    print $fh $logline;
}

1;