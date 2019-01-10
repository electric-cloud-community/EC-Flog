my %runFlog = (
    label       => "Flog - Code Analysis",
    procedure   => "runFlog",
    description => "Integrates Flog analysis into Electric Commander",
    category    => "Code Analysis"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/Flog - Code Analysis");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Flog - runFlog");

@::createStepPickerSteps = (\%runFlog);
