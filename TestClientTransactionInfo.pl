
#!/usr/bin/perl use strict;
use warnings;use Test::More tests => 5;
use ClientTransactionInfo; 
use Data::Dumper;

# Initialize variables 
my $clientObj = new ClientTransactionInfo();
my $row = "315CL  432100020001SGXDC FUSGX NK    20100910JPY01B 0000000001 0000000000000000000060DUSD000000000030DUSD000000000000DJPY201008200012380     688032000092500000000             O";
my %clientData = $clientObj->ExtractClientInfo($row);


# Check values of client info keys and values
my @clientKeys = keys %clientData;
my @expectedKeys = ("client_type","client_number", "client_account_number" , "client_subaccount_number");
my $actual =  join("", sort @clientKeys);
my $expected =  join("", sort @expectedKeys);
is($actual,$expected, "checkKeys of client info");

my @clientValues = values %clientData;
my @expectedValues = ("CL","0002", "4321" , "0001");
$actual =  join("", sort @clientValues);
$expected =  join("", sort @expectedValues);
is($actual,$expected, "checkValues of client info");

# Check values of Product info
my %productData = $clientObj->ExtractProductInformation($row);
my @productKeys = keys %productData;
@expectedKeys = ("exchange_code" , "product_group_code" , "symbol", "expiration_date");
$actual = join("", sort @productKeys);
$expected = join("", sort @expectedKeys);
is($actual,$expected, "checkKeys of product info");

@productValues = values %productData;
print ("@productValues\n");
@expectedValues = ("NK", "SGX", "FU", "20100910");
$actual =  join("", sort @productValues);
$expected =  join("", sort @expectedValues);
is($actual,$expected, "checkValues of product info");
# Check Values for Total Transaction
my $totalTransaction = $clientObj->ExtractProductTotalTransaction($row);
print("transaction is -----------------------> $totalTransaction");
my $expectedTransaction = "1";
is($totalTransaction,$expectedTransaction, "check total transaction");

done_testing();