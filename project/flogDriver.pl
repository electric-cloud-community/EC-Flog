use warnings;
use strict; 
$|=1;

use ElectricCommander;

my $ec = ElectricCommander->new();
$ec->abortOnError(0);

$::gInstallPath           = ($ec->getProperty( "installpath" ))->findvalue('//value')->string_value;
$::gTarget                = ($ec->getProperty( "target" ))->findvalue('//value')->string_value;
$::gVerbosity             = ($ec->getProperty( "verbose" ))->findvalue('//value')->string_value;
$::gDisplayAll            = ($ec->getProperty( "displayall" ))->findvalue('//value')->string_value;
$::gEnableContinuousMode  = ($ec->getProperty( "continuousmode" ))->findvalue('//value')->string_value;
$::gGroupResults          = ($ec->getProperty( "groupresults" ))->findvalue('//value')->string_value;
$::gDisplayScore          = ($ec->getProperty( "displayscore" ))->findvalue('//value')->string_value;
$::gAdditionalCommands    = ($ec->getProperty( "commands" ))->findvalue('//value')->string_value;


########################################################################
# main - contains the whole process to be done by the plugin, it builds the
#        command line, sets the properties and the working directory
#
# Arguments:
#   -none
#
# Returns:
#   -nothing
#
########################################################################
sub main() {
    
    # create args array
    my @args = ();
    
    #properties' map
    my %props;
    
    my $pathToReport;
    
    #add path to exec if entered
    my $executable = '';
    
    if($::gInstallPath && $::gInstallPath ne '' && uc($::gInstallPath)ne("FLOG")){
        $executable = qq{"$::gInstallPath"};
    }else{
        $executable = 'flog';
    }
        
    push(@args, $executable);
    
     if($::gTarget && $::gTarget ne '') {
        push(@args, qq{"$::gTarget"} );
    } 
    
    if($::gAdditionalCommands  && $::gAdditionalCommands  ne '') {
        foreach my $command (split(' +', $::gAdditionalCommands)) {
	    	push(@args, "$command");
		}
    }

    if($::gVerbosity && $::gVerbosity ne '') {
        push(@args, '--verbose');
    }
    
    if($::gDisplayAll && $::gDisplayAll ne '') {
        push(@args, '--all');
    }

    if($::gEnableContinuousMode && $::gEnableContinuousMode ne '') {
        push(@args, '--continue');
    }
    
    if($::gGroupResults && $::gGroupResults ne '') {
        push(@args, '--group');
    }
    
    if($::gDisplayScore && $::gDisplayScore ne '') {
        push(@args, '--score');
    }
    
     
    #generate the command to execute in console
    $props{'commandLine'} = createCommandLine(\@args);
    
    setProperties(\%props);
    
}

########################################################################
# createCommandLine - creates the command line for the invocation
# of the program to be executed.
#
# Arguments:
#   -arr: array containing the command name and the arguments entered by 
#         the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################
sub createCommandLine($) {

  	my ($arr) = @_;

    my $commandName = @$arr[0];

    my $command = $commandName;

    shift(@$arr);

	foreach my $elem (@$arr) {
        $command .= " $elem";
    }

    return $command;
    
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties 
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties($) {

    my ($propHash) = @_;

    # get an EC object
    my $ec = new ElectricCommander();
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
}

main();

