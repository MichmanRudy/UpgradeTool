<?php
set_time_limit(300);
#echo exec('whoami');
ini_set('max_execution_time',300); 
$scriptName = $_SERVER['DOCUMENT_ROOT'].'/PS/Check.ps1';
$fileName='/checkVersion_'.date('m-d-Y_H.i.s').'_'.$_POST['IP'].'.php';
$logName=$_SERVER['DOCUMENT_ROOT'].'/logs/PS'.$fileName ;
$logSource=$_SERVER['DOCUMENT_ROOT'].'/checkResult.php';
copy($logSource,$logName);

exec('PowerShell  -file "'.$scriptName.'" -IP "'.$_POST['IP'].'" -password "'.$_POST['password'].'" -user "'.$_POST['user'].'" -logName "'.$logName.'" &');


$logEnding = "</div>  </div> </body> </html>";
// Write the contents to the file, 
// using the FILE_APPEND flag to append the content to the end of the file
// and the LOCK_EX flag to prevent anyone else writing to the file at the same time
file_put_contents($logName, $logEnding, FILE_APPEND | LOCK_EX);
$header='Location: \logs\PS'.$fileName;
//echo $header;

if(file_exists($scriptName))
	
{
	header($header);
}
else{
	echo nl2br("PowerShell script was not found \n \n");
}

?>

