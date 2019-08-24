#!/usr/bin/perl 
package GenerateReport;


use DataFileOperations;


sub new 
{
   my $class = shift;
   my $self = {};
   bless $self, $class;
   return $self;
}


{
    print "Enter the fileName:\n";
    my $filename = <>;
    chomp $filename;
    open(my $fh, '<:encoding(UTF-8)', $filename)
        or die "Could not open file '$filename' $!";
    my $obj = new DataFileOperations();
    my %json_data = $obj->GenerateDataInJsonFormat($fh);
    my $outputfile =  $obj->WriteCsvFile(\%json_data);
    print ("Generated report is :\n");
    print ("$outputfile\n");    
}

