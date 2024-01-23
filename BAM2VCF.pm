# use strict;
my $base_path="/home/amanbioinfo/Aman/Project";

my $config_file = shift @ARGV;

 #parse_config_file ($config_file, \%Config);  # Call the Function to create the Config hash

my @files1 ;

$files1= process_files ($base_path);

foreach (@$files1) {
	if($_=~/.fastq$/){
		#print $_,"\n";
	}
}

# for every fastq file, generate a lock file name
my @filesFQonly= grep {/.fastq$/} @$files1;
my @filesLOCK=@filesFQonly;
my @filesLOCK= map {s/\/(?:.(?!\/))+.fastq$/\/.lock/g; $_;} @filesLOCK;

#print @filesFQonly;

for(my $lockPath_i=0; $lockPath_i<=$#filesLOCK; $lockPath_i++) {
	if(0 && -e $filesLOCK[$lockPath_i]){
		# step 2.1.1: skip this file
		print $lockPath_i." exist; skipping\n";
	} else {
		# step 2.1.2: create the lock file
		open(FH,">".$filesLOCK[$lockPath_i]) or die $!;
		print FH `date`;
		close(FH);
		print "Locked \n";
		
		# run BAM2VCF
		my $bam_file_name = &create_bam_for_VCF($filesFQonly[$lockPath_i]);
		
		}
}



sub create_bam_for_VCF() {
	my $fastQ_fname = shift @_;
	
	my $ref_genome = $Config{'genome_ref'};
	my $base = shift @ARGV;
	
	print "\n\n >> BAM 2 Mpileup \n";
if (! -e "$fastQ_fname.file.mpileup") {
	system("samtools mpileup -E -uf $fastQ_fname $fastQ_fname.sorted.bam > $fastQ_fname.file.mpileup");
} else {
	warn("EXISTS $fastQ_fname.file.mpileup\n");
}

print "\n\n >> Mpileup 2 VCF \n";
if (! -e "$fastQ_fname.file.vcf") {
	system("bcftools view -cg $fastQ_fname.file.mpileup > $fastQ_fname.file.vcf");
} else {
	warn("EXISTS $fastQ_fname.file.vcf\n");
}

print "\n\n >> Mpileup 2 BCF \n";
if (! -e "$fastQ_fname.file.bcf") {
	system("bcftools view -bcg $fastQ_fname.file.mpileup > $fastQ_fname.file.bcf");
} else {
	warn("EXISTS $fastQ_fname.file.bcf\n");
}

# Accepts one argument: the full path to a directory.
# Returns: nothing.
sub process_files {
    my $path = shift;

    # Open the directory.
    opendir (DIR, $path)
        or die "Unable to open $path: $!";

    # Read in the files.
    # You will not generally want to process the '.' and '..' files,
    # so we will use grep() to take them out.
    # See any basic Unix filesystem tutorial for an explanation of the

    my @files = grep { !/^\.{1,2}$/ } readdir (DIR);
	# Close the directory.
    closedir (DIR);

    # At this point you will have a list of filenames
    #  without full paths ('filename' rather than
    #  '/home/count0/filename', for example)
    # You will probably have a much easier time if you make
    #  sure all of these files include the full path,
    #  so here we will use map() to tack it on.
    #  (note that this could also be chained with the grep
    #   mentioned above, during the readdir() ).
    @files = map { $path . '/' . $_ } @files;

    for (@files) {

        # If the file is a directory
        if (-d $_) {
            # Here is where we recurse.
            # This makes a new call to process_files()
            # using a new directory we just found.
            process_files ($_);

        # If it isn't a directory, lets just do some
        # processing on it.
        } else { 
            # Do whatever you want here =) 
			push(@files1,$_);
            # A common example might be to rename the file.
        }
    }
return \@files1;
}
}
