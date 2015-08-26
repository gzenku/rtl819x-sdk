<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>Operation Mode</title>
<script type="text/javascript" src="common.js"> </script>
<script>
wlan_num =<% write(getIndex("wlan_num")); %> ;
wispWanId = <% write(getIndex("wispWanId")); %> ;
function opModeClick()
{
	if(wlan_num > 1){
		if(document.fmOpMode.opMode[2].checked)
			enableTextField(document.fmOpMode.wispWanId);
		else
			disableTextField(document.fmOpMode.wispWanId);
	}
}
</script>
</head>
<body>
<blockquote>
<h2><font color="#0000FF">Operation Mode</font></h2>


<table border=0 width="500" cellspacing=0 cellpadding=0>
  <tr><font size=2>
  You can setup different modes to LAN and WLAN interface for NAT and bridging function. 
  </tr>
  <tr><hr size=1 noshade align=top></tr>
</table>
<form action=/goform/formOpMode method=POST name="fmOpMode">
<table border="0" width=500>
	<tr>
		<td width ="23%" valign="top">
		<input type="radio" value="0" name="opMode" onClick="opModeClick()" ></input>
		<font size=2> <b> Gateway: </b> </font>
		</td>
		<td width ="77%">
			<font size=2>In this mode, the device is supposed to connect to internet via ADSL/Cable Modem. The NAT is enabled and PCs in  LAN ports share the same IP to ISP through WAN port. The connection type can be setup in WAN page by using PPPOE, DHCP client, PPTP client or static IP.</font>
		</td>
	</tr>
	<td colspan="2" height="10"></tr>
	<tr>
		<td width ="23%" valign="top">
		<input type="radio" value="1" name="opMode" onClick="opModeClick()" ></input>
		<font size=2> <b> Bridge: </b> </font>
		</td>
		<td width ="77%">
			<font size=2>In this mode, all ethernet ports and wireless interface are bridged together and NAT function is disabled. All the WAN related function and firewall are not supported.</font>
		</td>
	</tr>
	<td colspan="2" height="10"></tr>
	
	<tr>
		<td width ="23%" valign="top">
		<input type="radio" value="2" name="opMode" onClick="opModeClick()" ></input>
		<font size=2> <b> Wireless ISP: </b> </font>
		</td>
		<td width ="77%">
			<font size=2>In this mode, all  ethernet ports  are bridged together and the wireless client will connect to ISP access point. The NAT is enabled and PCs in ethernet ports share the same IP to ISP through wireless LAN. You must set the wireless to client mode first and connect to the ISP AP in Site-Survey page.  The connection type can be setup in WAN page by using PPPOE, DHCP client, PPTP client or static IP.</font>
		</td>
	</tr>
	<tr>
		<td width ="23%" valign="top"> </td>
		<td width ="77%">
			<script>
			if(wlan_num > 1){
				document.write('<font size=2><b>WAN Interface : </b>');
				document.write('<select size="1" name="wispWanId">');
				for(i=0 ; i < wlan_num ; i++)
					document.write('<option value="'+i+'">wlan'+(i+1)+'</option>');
				document.write('</select>');
			}
			</script>
		</td>
	</tr>
</table>
<script>
	opmode = <% write(getIndex("opMode")); %> ;
	document.fmOpMode.opMode[opmode].defaultChecked= true;
	document.fmOpMode.opMode[opmode].checked= true;
	if(wlan_num > 1){
		document.fmOpMode.wispWanId.defaultSelected= wispWanId;
		document.fmOpMode.wispWanId.selectedIndex= wispWanId;
	}
	opModeClick();
</script>
  <input type="hidden" value="/opmode.asp" name="submit-url">
  <p><input type="submit" value="Apply Change" name="apply">
&nbsp;&nbsp;
  <input type="reset" value="Reset" name="set" >
&nbsp;&nbsp;
</form>
</blockquote>
</font>
</body>

</html>
