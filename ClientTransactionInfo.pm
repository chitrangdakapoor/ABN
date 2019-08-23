#!/usr/bin/perl 
package ClientTransactionInfo;
use Text::Trim qw(trim);


sub new 
{
   my $class = shift;
   my $self = {};
   bless $self, $class;
   return $self;
}

sub ExtractClientInfo
{
    my ($self,$infoString) = @_;
    my $client_type = trim substr $infoString, 3, 4;
    my $client_number = trim substr $infoString, 7, 4;
    my $client_account_number = trim substr $infoString, 11, 4;
    my $client_subaccount_number = trim substr $infoString, 15, 4;
    my %client_info = ("client_type" => $client_type, "client_number"=> $client_number, "client_account_number" => $client_account_number, "client_subaccount_number"=> $client_subaccount_number);
    return %client_info;
}

sub ExtractProductInformation
{
    my ($self,$infoString) = @_;
    my $exchange_code = trim substr $infoString, 27, 4;
    my $product_group_code = trim substr $infoString, 25, 2;
    my $symbol = trim substr $infoString, 31, 6;
    my $expiration_date = trim substr $infoString, 37, 8;
    my %product_info = ("exchange_code" => $exchange_code, "product_group_code" => $product_group_code, "symbol"=> $symbol, "expiration_date"=> $expiration_date);
    return %product_info;
}

sub ExtractProductTotalTransaction
{
    my ($self,$infoString) = @_;
    my $quantity_long = trim substr $infoString, 52, 10;
    my $quantity_short =  trim substr $infoString, 63, 10;
    my $total_transaction = $quantity_long - $quantity_short;
    return $total_transaction;
}

1;