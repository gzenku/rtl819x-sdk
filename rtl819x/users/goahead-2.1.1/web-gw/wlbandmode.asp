<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>Operation Mode</title>
<script type="text/javascript" src="util_gw.js"> </script>
<script>
wlan_num =<% write(getIndex("wlan_num")); %> ;
var isPocketRouter="<% getInfo("isPocketRouter"); %>"*1;
var pocketRouter_Mode="<% getInfo("pocketRouter_Mode"); %>"*1;
var POCKETROUTER_GATEWAY = 3;
var POCKETROUTER_BRIDGE_AP = 2;
var POCKETROUTER_BRIDGE_CLIENT = 1;
</script>
</head>
<body>
<blockquote>
<h2><font color="#0000FF">Wireless Band Setting</font></h2>


<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><font size=2>
  <!--Support switchable 802.11n dual-band radio frequency (2.4GHz/5GHz). -->
  Support switchable 802.11n single-band or dual-band radio frequency.
  </tr>
  <tr><hr size=1 noshade align=top></tr>
</table>
<form action=/goform/formWlanBand2G5G method=POST name="fmWlBandMode">
<table border="0" width=500>
	

	<tr>
		<td width ="40%" valign="top">
		<% getInfo("single_band");%> 		
		<font size=2> <b> 2.4G/5G Selective Mode: </b> </font>
		</td>
		<td>
			<font size=2>This mode can supports 2.4G or 5G by 2x2.</font>
		</td>
	</tr>
	<tr><td colspan="2" height="10"></tr>
		
<% getInfo("onoff_dmdphy_comment_start");%> 
	<tr>
		<td width ="40%" valign="top">
		<input type="radio" value="2" name="wlBandMode" onClick="" ></input>
		<font size=2> <b> 2.4G/5G Concurrent Mode: </b> </font>
		</td>
		<td>
			<font size=2>This mode can simultaneously supports 2.4G and 5G wireless network connection.</font>
		</td>
	</tr>
<% getInfo("onoff_dmdphy_comment_end");%> 

</table>
<script>
	wlBandMode = <% write(getIndex("wlanBand2G5GSelect")); %> ;
	var radioIndex=0;
	while(document.fmWlBandMode.wlBandMode[radioIndex])
	{
		if(document.fmWlBandMode.wlBandMode[radioIndex].value == wlBandMode)
		{
			document.fmWlBandMode.wlBandMode[radioIndex].defaultChecked= true;
			document.fmWlBandMode.wlBandMode[radioIndex].checked= true;
			break;
		}
		radioIndex++;
	}	
	
	if( (isPocketRouter==1) && (pocketRouter_Mode == POCKETROUTER_BRIDGE_CLIENT))
	{
		document.fmWlBandMode.wlBandMode[0].disabled= true;
		document.fmWlBandMode.wlBandMode[1].disabled= true;
	}
	
</script>
  <input type="hidden" value="/wlbandmode.asp" name="submit-url">
  <p><input type="submit" value="Apply Change" name="apply">
&nbsp;&nbsp;
  <input type="reset" value="Reset" name="set" >
&nbsp;&nbsp;
</form>
</blockquote>
</font>
</body>

</html>
