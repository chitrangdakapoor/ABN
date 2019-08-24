#!/usr/bin/perl
use strict;
use warnings;
use GenerateReport;

my $obj = new GenerateReport();
$obj->GenerateReportWithTotalTransactionPerCustomer();
