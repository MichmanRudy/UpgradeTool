<?php
set_time_limit(300);
#echo exec('whoami');
$scriptName = $_SERVER['DOCUMENT_ROOT'].'/PS/disableSMBV1.ps1';
$fileName='/disableSMBV1_'.date('m-d-Y_H.i.s').'_'.$_POST['IP'].'.php';
$logName=$_SERVER['DOCUMENT_ROOT'].'/logs/PS'.$fileName ;
$logSource=$_SERVER['DOCUMENT_ROOT'].'/upgradeResult.php';
copy($logSource,$logName);

exec('PowerShell  -file "'.$scriptName.'" -IP "'.$_POST['IP'].'" -password "'.$_POST['password'].'" -user "'.$_POST['user'].'" -logName  "'.$logName.'" ');
$header='Location: logs/PS'.$fileName;
if(file_exists($scriptName))
{
	header($header);
}
else{
	echo nl2br("PowerShell script was not found \n \n");
}

?>