
# Check the Arguments
if ($#ARGV != 0 ) {
	print "Usage: $0 <ConfigFile>\n";
	exit;
}

my $config_file=$ARGV[0];
my %Config = ();


parse_config_file ($config_file, \%Config);  # Call the Function to create the Config hash

# Print the key value pair from the Config Hash
for my $key ( keys %Config ) {
	my $value = $Config{$key};
	#print "$key => $value\n";
}

#print keys %Config,"\n\n",">",$Config{"filename"},"<";

my $input_file = $Config{"filename"};
my $column_with_mut = $Config{"column_with_mut"};
my $column_with_iden = $Config{"column_with_iden"};
my $column_with_gene_name = $Config{"column_with_gene_name"};

print "Script $0 Finished\n";



my $count=1.0;
# my $filename = $input_file;

open APRI2_in, '<', $input_file or die "Can't fetch file $input_file; error $!";
#$APRI2_in=~s/\s//g;
while( <APRI2_in> ) {
	if($_=~/NON_SYNONYMOUS_CODING/){
		my @columns = split /\|/, $_;
		my $mut=$columns[$column_with_mut];
		my $org=substr($mut,0,1);
		my $pos=substr($mut,1,length($mut)-2);
		my $rep=substr($mut,-1);
print $mut "-" $org "-" $pos "-" $rep;
				}
			} else {
				#warn "Could not open file '$where' $!";
			}
		} else {

}

	}

}


# Function to Parse the Environment Variables
sub parse_config_file {
	my ($config_line, $column_with_mut, $column_with_mut_value, $column_with_iden, $column_with_iden_value, $column_with_gene_name, $column_with_gene_name_value, $input_file, $input_file_value, $Config);
	my ($File, $Config) = @_;
	open (CONFIG, "$File") or die "ERROR: Config file not found : $File";
	while (<CONFIG>) {
		$config_line=$_;
		chop ($config_line);          # Remove trailling \n
		$config_line =~ s/\s*//g;     # Remove spaces at the start of the line
		$config_line =~ s/\s*$//;     # Remove spaces at the end of the line
		if ( ($config_line !~ /^#/) && ($config_line ne "") ){    # Ignore lines starting with # and blank lines
			($input_file, $input_file_value) = split (/=/, $config_line);
			($column_with_mut, $column_with_mut_value) = split (/=/, $config_line);			# Split each line into name value pairs
			($column_with_iden, $column_with_iden_value) = split (/=/, $config_line);
			($column_with_gene_name, $column_with_gene_name_value) = split (/=/, $config_line);
			$$Config{$input_file} = $input_file_value;
			$$Config{$column_with_mut} = $column_with_mut_value;
			$$Config{$column_with_iden} = $column_with_iden_value;
			$$Config{$column_with_gene_name} = $column_with_gene_name_value;                             # Create a hash of the name value pairs
		}
	}
	close(CONFIG);
}

