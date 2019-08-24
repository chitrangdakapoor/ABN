#!/usr/bin/perl 
package DataFileOperations;

use strict;
use warnings;
use Data::Dumper;
use Text::Trim qw(trim);
use Text::CSV;
use File::HomeDir;
use File::Temp;
use ClientTransactionInfo;
use Logging;

sub new 
{
   my $class = shift;
   my $self = {};
   bless $self, $class;
   return $self;
}
sub GenerateDataInJsonFormat
{
    my ($self,$fh) = @_;
    my %client_product_transac ;   
    my $object = new ClientTransactionInfo( );  
    my $count = 0;
    open(my $logfile, '>', 'result.log')  or die "Could not open file 'result.log' $!";
    while (my $row = <$fh>)
    {
        chomp $row; 
        my $time = gmtime();
        if(length($row) != 176)
        {
            print $logfile gmtime()." "."row $count is not valid length dropped\n";
            next;
        }
        my $transac = $object->ExtractProductTotalTransaction($row);
        my %product_info = $object->ExtractProductInformation($row);
        my %customer_info = $object->ExtractClientInfo($row);
        my $code = $product_info{"product_group_code"}.$product_info{"exchange_code"};
        if (! exists $client_product_transac{$customer_info{"client_number"}})
        {
            my %client_number_detail;
            my %product_trans_info ;
            my %product_code_info;
            $product_code_info{"total_transaction"} = $transac;
            $product_code_info{"product_info"} = \%product_info;
            $product_trans_info{$code} = \%product_code_info;
            $client_number_detail{"client_info"} = \%customer_info;
            $client_number_detail{"product_list"} = \%product_trans_info;
            $client_product_transac{$customer_info{"client_number"}} = \%client_number_detail;
      }
      else
      {
            if(! exists $client_product_transac{$customer_info{"client_number"}}{"product_list"}{$code})
            {
                my %product_code_info;

                $product_code_info{"total_transaction"} = $transac;
                $product_code_info{"product_info"} = \%product_info;
                $client_product_transac{$customer_info{"client_number"}}{"product_list"}{$code} = \%product_code_info;     
            }
            else
            {
                $client_product_transac{$customer_info{"client_number"}}{"product_list"}{$code}{"total_transaction"}+= $transac;
            }
        }
        print $logfile gmtime()." "."row $count processed successfully\n";
        $count++;
    }
    close($logfile);
    return %client_product_transac;
}

sub WriteCsvFile
{
    my ($self,$data) = @_;
    my %json_data = %$data;
    my $filename = GetFileName();
    my $csv = Text::CSV->new({binary => 1, eol => $/ })
                    or die "Failed to create a CSV handle: $!";
    open my $fh, ">:encoding(utf8)", $filename or die "failed to create $filename: $!";
    my(@heading) = ("Client_Information", "Product_Information","Total_Transaction_Amount");
    $csv->print($fh, \@heading);    # Array ref!

    foreach my $client_code (keys %json_data)
    {
        my %client_info_hash = %{$json_data{$client_code}{"client_info"}};
        my $client_info = $client_info_hash{"client_type"}."-".$client_info_hash{"client_account_number"}."-".$client_info_hash{"client_number"}."-".$client_info_hash{"client_subaccount_number"};
        foreach my $product_code (keys %{$json_data{$client_code}{"product_list"}})
        {
            my $total_transaction = $json_data{$client_code}{"product_list"}{$product_code}{"total_transaction"};
            my %product_info_hash = %{$json_data{$client_code}{"product_list"}{$product_code}{"product_info"}};
            my $product_info = $product_info_hash{"symbol"}."-".$product_info_hash{"product_group_code"}.$product_info_hash{"exchange_code"}."-".$product_info_hash{"expiration_date"};
            
            my(@datarow) = ($client_info, $product_info, $total_transaction);
            $csv->print($fh, \@datarow); 
        }
    }
    close $fh or die "failed to close $filename: $!";
    return $filename;
}

sub GetFileName
{
    my $dir = File::HomeDir->my_home;
    my $filename = $dir.'\output-'.time().".csv";
    return $filename;
}

1;
