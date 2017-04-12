<?php
set_time_limit(300);
#echo exec('whoami');
ini_set('max_execution_time',300); 
$settingsFileName = 'C:\Users\Administrator\Documents\UpgradeToolSettings.txt';
unlink($settingsFileName);
// Write the contents to the file, 
// using the FILE_APPEND flag to append the content to the end of the file
// and the LOCK_EX flag to prevent anyone else writing to the file at the same time
file_put_contents($settingsFileName, $_POST['localServerAdmin']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['localServerPassword']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['localServerIP']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['feedBackShareName']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['buildsSharePassword']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['buildsShareUser']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['buildsShareAddress']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['emailLogin']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['emailDomain']."\n", FILE_APPEND | LOCK_EX);
file_put_contents($settingsFileName, $_POST['emailPassword']."\n", FILE_APPEND | LOCK_EX);
$header='Location: \..\ ';
//echo $header;


	header($header);

?>