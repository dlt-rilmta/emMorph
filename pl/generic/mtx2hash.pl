################################################## START OF LICENSE ##################################################
#
#  This file is part of the emMorph / Humor morphological analyzer description for Hungarian.
#  Copyright (C) 2001-2016 Attila Novák
#  
#  The author of the database and the database compilation environment is Attila Novák (novakat@gmail.com).
#  The resource is available from: https://github.com/dlt-rilmta/emMorph
#  
#  The database files are licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0
#  (CC BY-NC-SA) license, the compilation scripts under the GNU General Public License (GPL v3)
#  with the following amendments:
#  
#  By downloading/cloning/using this database and tools you accept the following terms:
#  
#  1. Please inform the author at [novakat@gmail.com](mailto:novakat@gmail.com) about your use of the database/tools
#  clearly indicating what you use this database or tool for in your application/experiment/resource.
#  
#  2. If possible, please publish a scientific paper about each application, experimental system
#  or linguistic resource you create or experiment you perform using this resource quoting the articles below,
#  and inform the author at [novakat@gmail.com](mailto:novakat@gmail.com) about each article you publish. 
#  
#  Articles to quote are listed at https://github.com/dlt-rilmta/emMorph, the list is currently the following:
#  (See the BibTeX file quotethis.bib in the root directory):
#  
#  Attila Novák (2014): A New Form of Humor – Mapping Constraint-Based Computational Morphologies to a Finite-State Representation.
#  In: Proceedings of the 9th International Conference on Language Resources and Evaluation (LREC-2014). Reykjavík, pp. 1068–1073 (ISBN 978-2-9517408-8-4)
#  
#  Attila Novák; Borbála Siklósi; Csaba Oravecz (2016): A New Integrated Open-source Morphological Analyzer for Hungarian
#  In: Proceedings of the Tenth International Conference on Language Resources and Evaluation (LREC 2016). Portorož, pp. 1315–1322.
#  
#  Novák Attila (2003): Milyen a jó Humor? [What is good Humor like?] In: Magyar Számítógépes Nyelvészeti Konferencia (MSZNY 2003). Szegedi Tudományegyetem, pp. 138–145
#  
#  3. Please do share your adaptations of the morphology (vocabulary extensions etc.) using the same licenses.
#  
#  4. If you are interested in using or adapting the resource for commercial purposes, please contact the author.
#  ***
#  
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#
################################################## END OF LICENSE ##################################################

use utf8;
use open qw/:encoding(utf8)/;
use open qw/:std :encoding(utf8)/;

BEGIN{
$hpldir=$ENV{'hpldir'} if !$hpldir;
$hpldir='../..' if !$hpldir;
}

use lib "$hpldir/pl/generic";

require 'm2getopt.pl';
require 'banner.pl';
require 'diewarn.pl';
$store=1;
require 'dumpdata.pl';

start_banner('Matrices to hash converter');
$stm=time;

sub printmsg
{
	print MSG time-$stm,": ",shift,"\n";
}

open(MSG,'>&STDERR');
select(MSG);$|=1;select(STDOUT);

#transpose matrix
sub transpose
{
	my($me)=shift;
	my(@met,$i);
	printmsg("transposing matrix...");
	for($i=0;$i<=$#$me;$i++)
	{
		$j=0;
		for(split / +/,$me->[$i])
		{
			unless($i)
			{
				$met[$j]=$_.' ';
			}
			else
			{
				$met[$j].=$_.' ';
			}
			$j++;
		}
	}
	@$me=@met;
}

sub mtx2hash
{
	my @mtx=map{chomp;$_}(@{$_[0]});
	@mtx=transpose(\@mtx);
	$_=shift @mtx;
	printmsg("converting matrix...");
	my @head=split /\s+#?/;
	shift @head;
	my @idx=(0..$#head);
	my(@row,$code);

	map
	{
		@row=split/\s+/,$_;
		$code=shift @row;
		$code=substr($code,1);
		@row=map{$row[$_] eq '*'?$head[$_]:()}@idx;
		warn("Code $_ unjoinable\n") if !@row;
		$code,[@row];
	}@mtx;
}

my(@a,$mtxname);
for(@ARGV)
{
	open(I,$_) or die "Matrix file $_ missing.\n";
	($mtxname)=/_([^_]*?)\.txt/i;
	@a=(<I>);
	printmsg("processing matrix $mtxname...");
	$mtx->{$mtxname}={mtx2hash(\@a)};
	close I;
}

printmsg("generating output...");
$store=1;
print dumpdata($mtx,'mtx',$OutFileName);
#$a=dump($mtx);
#$a=~s/ {8,}/ /g;
#$a=~s/(\d,|\[)\n/$1/g;
#print "\n\$mtx=\n$a;\n";

die_if_errors();
end_banner();
