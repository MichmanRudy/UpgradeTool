<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<style type="text/css">
html, body {
                
                margin: 0;
                padding: 0;
                background-color: #EFECE6;
					background:url('/res/back.jpg');
			background-size:100%;	
            }
            tab1 { padding-left: 4em; }
            tab2 { padding-left: 3.3em; }
            tab3 { padding-left: 1.15em; }
            tab4 { padding-left: 1.95em; }
            tab5 { padding-left: 20em; }
            tab6 { padding-left: 2em; width:2em; }
            tab7 { padding-left: 28em; }
            tab8 { padding-left: 32em; }
            tab9 { padding-left: 36em; }
            tab10 { padding-left: 40em; }
            tab11 { padding-left: 44em; }
            tab12 { padding-left: 48em; }
            tab13 { padding-left: 52em; }
            tab14 { padding-left: 56em; }
            tab15 { padding-left: 60em; }
            tab16 { padding-left: 64em; }
		
			#subcontainer1, #subcontainer2, #subcontainer3 {display: inline-block; *display: inline; zoom: 1; vertical-align: top; font-size: 12px;}
			#subcontainer1
{   
top:1%;
left:3%;
padding-top:0;
margin:left; position:relative;
width:10%;
height:10%;
#border:1px solid #000;
}
#subcontainer2
{   
top:1%;
left:3%;
padding-top:0;
margin:left; position:relative;
width:10%;
height:10%;
#border:1px solid #000;
}
        </style>
</head>
<body>

    <h2><tab6>Upgrade/install menu</tab6></h2>
	<h5><tab6>Specify the remote machine's creds and version to Upgrade/Install Core or Agent</tab6></h5>
	<h5><tab6>After launch the page will be loading about a minute</tab6></h5>
		
<form action="upgrade.php" method="post">
<tab1><input type="text" name="IP" value="" placeholder="IP or mane" required/></tab1><br>
<tab1><input type="text" name="user" value="Administrator" placeholder="User" value="Administrator" required/></tab1><br>
<tab1><input type="password" name="password"  placeholder="Password" required/> <font color="brown"></font></tab1><br>
 <?php  
 

function drawArray(DirectoryIterator $directory)
{
    $result=array();
    foreach($directory as $object)
    {
        if($object->isDir()&&!$object->isDot())
        {
			//if($object->getFilename()== '7.'||$object->getFilename()== '6.' ||$object->getFilename()== '5.')
			//{
            $result[]=$object->getFilename();
			//}
        }
           
    }
    return $result;
}
$lines=file('C:\Users\Administrator\Documents\UpgradeToolSettings.txt');
$array=drawArray(new DirectoryIterator($lines[9]));
/* Array Contents */
//$array1 = array('Sydney','Melbourne','Brisbane','Tasmania','Adelaide','Perth','Darwin','ACT');
 
echo '<tab1><select name="version" required>'; 
 
/* For each value of the array assign variable name "city" */

foreach($array as $value){ 

 echo '<option value="' . $value . '">' . $value . '</option>';

} 
echo'</select></tab1><br>';
?> 
<!-- <tab1><input type="text" name="version" placeholder="Installer version" required/></tab1> <br> -->
 <tab2><input type="radio"  name="type" value="1" required/> Core
  <input type="radio" name="type" value="2" required/> Agent64
  <input type="radio" name="type" value="3" required/> Agent32<br><br>
<tab1> <input type="submit">
</form>





</body>
</html>