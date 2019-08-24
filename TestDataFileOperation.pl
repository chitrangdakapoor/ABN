#!/usr/bin/perl 
use strict;
use warnings;
use Test::More tests => 2;
use DataFileOperations; 
use Data::Dumper;
use File::HomeDir;
use ClientTransactionInfo;

# Initialize variables 
my $obj = new DataFileOperations();

# Test GetFileName
my $file1 = $obj->GetFileName();
my $homeDir =  File::HomeDir->my_home;
my $pattern = quotemeta $homeDir.'\output-';
my $fileExtension = '.csv';
$file1 =~ m/^$pattern.\d+.$fileExtension/;
is($&, $file1, "Test filename format");

sleep(1);
my $file2 = $obj->GetFileName();
isnt($file1, $file2, "@ files generated are unique");

# Test GenerateDataInJsonFormat
my $filename = "TestData.txt";
open(my $fh, '<:encoding(UTF-8)', $filename)
        or die "Could not open file '$filename' $!";
        
$obj = new DataFileOperations();
my %json_data = $obj->GenerateDataInJsonFormat($fh);
my %expectedResult = {"4321" => {"FUCME" => -6,
                                 "FUSGX" => 2
                                },
                       "1234" => {"FUCME" => 2,
                                 "FUSGX" => 2
                                }
                     };
is($expectedResult{"4321"}{"FUCME"}, $json_data{$client}{"product_list"}{$product}{"total_transaction"});
foreach my $client (keys %expectedResult)
{
      foreach my $product (keys $expectedResult{$client})
      {
          my $expected = $expectedResult{$key}{$product};
          my $actual =  $json_data{$client}{"product_list"}{$product}{"total_transaction"};
          is($expected,$actual);
      }
     
}
done_testing();