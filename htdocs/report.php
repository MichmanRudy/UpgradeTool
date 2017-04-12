<?php
set_time_limit(300);
#echo exec('whoami');
$scriptName = $_SERVER['DOCUMENT_ROOT'].'/PS/Report.ps1';
$fileName='/report_'.date('m-d-Y_H.i.s').'_'.$_POST['reporter'].'.php';
$logName=$_SERVER['DOCUMENT_ROOT'].'/logs/PS'.$fileName ;
$logSource=$_SERVER['DOCUMENT_ROOT'].'/upgradeResult.php';
copy($logSource,$logName);
exec('PowerShell  -file "'.$scriptName.'" -name "'.$_POST['name'].'" -severity "'.$_POST['severity'].'" -description "'.$_POST['description'].'" -reporter "'.$_POST['reporter'].'" -email "'.$_POST['email'].'" -logName  "'.$logName.'" ');
$header='Location: logs/PS'.$fileName;
if(file_exists($scriptName))
{
	header($header);
}
else{
	echo nl2br("PowerShell script was not found \n \n");
}

?>