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

    <h2><tab6>Configure Local Settings for Upgrade Utility instance</tab6></h2>
		<h4><tab3>Submit following values. This must be done once the Upgrade Utility Server is installed</tab3><br>
		<tab3>They will be written to settings file C:\Users\Administrator\Documents\UpgradeUtility\settings.txt </tab3><br>
		<tab3>Don't forget to set Administrator as start-up user for the Apache server in Services </tab3></h4><br><br>
<form action="configure.php" method="post">
<tab1><input type="text" name="localServerAdmin" value="Administrator" placeholder="Local Administrator Login" required size = "40"/></tab1><br>
<tab1><input type="password" name="localServerPassword"  placeholder="Local Administrator Password" required size = "40"/></tab1><br>
<tab1><input type="text" name="localServerIP"  placeholder="Local Server IP" required size = "40"/> </tab1><br>
<tab1><input type="text" name="feedBackShareName"  placeholder="Any Name for Temp Local Share (for Reporting)" required size = "40"/> </tab1><br>
<tab1><input type="password" name="buildsSharePassword"  placeholder="Password for Remote Share with Builds" required size = "40"/></tab1><br>
<tab1><input type="text" name="buildsShareUser"  placeholder="User for Remote Share with Builds" required size = "40"/> </tab1><br>
<tab1><input type="text" name="buildsShareAddress"  placeholder="Network Address for Share with Builds" required size = "40"/> </tab1><br>
<tab1><input type="text" name="emailLogin"  placeholder="email login" required size = "15"/> </tab1>@
<input type="text" name="emailDomain"  placeholder="email domain name" required size = "15"/> </tab1><br>
<tab1><input type="password" name="emailPassword"  placeholder="email password" required size = "40"/></tab1><br>

<tab1> <input type="submit">
</form>





</body>
</html>