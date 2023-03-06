
use strict;

my $file = shift;



open(my $F, "<", $file) || die "Can't open file $file. We are done here.";

open(my $G, ">", $file.".obo") || die "Can't open file $file.obo for writing. We are done here.";

# write standard header (from cassava obo file)

print $G <<HEADER;

format-version: 1.2
date: 06:03:2023 17:10
saved-by: Lukas
auto-generated-by: OBO-Edit 2.3.1
default-namespace: blueberry_trait
ontology: BTO
    
[Term]
id: BTO:0000000
name: Blueberry Trait Ontology
def: "a controlled vocabulary to describe blueberry traits"    
    
HEADER

    while (<$F>) {
    chomp;

    my ($trait_number, $trait_name, $trait_abbr, $trait_synonym, $trait_description, $method_name, $method_description, $method_class, $method_formula, $scale_name, $scale_categories) = split /\t/;
    
    print STDERR "Formatting trait $trait_number, $trait_name...\n";

    my @synonym_lines = ();
    if ($trait_synonym) {
	push @synonym_lines, "synonym: \"$trait_synonym\" EXACT []\n"; 
    }

    if ($trait_abbr) {
	push @synonym_lines, "synonym: \"$trait_abbr\" EXACT []\n";
    }
    
    print $G <<TERM;

[Term]
id: $trait_number
name: $trait_name
namespace: blueberry_trait    
def: $trait_description, $method_name, $method_class, $scale_name, $scale_categories
relationship: variable_of BTO:0000000 ! Blueberry Trait Ontology
TERM

    if (@synonym_lines) {
	foreach my $s (@synonym_lines) {
	    print $G $s;
	}
    }
}

close($F);
close($G);


print STDERR "Done!\n";
