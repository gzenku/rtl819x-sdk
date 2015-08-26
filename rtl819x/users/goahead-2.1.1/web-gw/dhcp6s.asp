<html>
<head>
<meta http-equiv="Content-Type" content="text/html">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<title>Configuring DHCPv6</title><SCRIPT LANGUAGE="JavaScript">
function onclick_func()
{
	if(Dhcp6form.enable_dhcpv6s.checked == false)	{		
		Dhcpv6form.interfacenameds.disabled=true;
	}	else
	{
		Dhcpv6form.interfacenameds.disabled=false;	}
}
</SCRIPT>
</head>

<body bgcolor="#ffffff" text="#000000">
<form method="POST" action="/goform/formDhcpv6s" name=Dhcpv6form>
<b>Configuring DHCPv6</b><BR>  <BR>
<td bgColor=#aaddff>Enable</td><td bgColor=#ddeeff><input type=checkbox name=enable_dhcpv6s value =1 <% getIPv6Info("enable_dhcpv6s"); %> onclick="onclick_func()"></td>
<table cellSpacing=1 cellPadding=2 border=0>
<tr><td bgColor=#aaddff>DNS Addr:</td><td bgColor=#ddeeff><input type=text name=dnsaddr size=48 maxlength=48 value="<% getIPv6Info("dnsaddr"); %>"></td></tr>
<tr><td bgColor=#aaddff>Interface Name:</td><td bgColor=#ddeeff><input type=text name=interfacenameds size=48 maxlength=48 value="<% getIPv6Info("interfacenameds"); %>"></td></tr>
<td bgColor=#aaddff>Addrs Pool:</td>
<tr><td bgColor=#aaddff>	From:</td><td bgColor=#ddeeff><input type=text name=addrPoolStart size=48 maxlength=48 value="<% getIPv6Info("addrPoolStart"); %>"></td></tr>
<tr><td bgColor=#aaddff>	To:</td><td bgColor=#ddeeff><input type=text name=addrPoolEnd size=48 maxlength=48 value="<% getIPv6Info("addrPoolEnd"); %>"></td></tr>
</table>
<input type="hidden" value="/dhcp6s.asp" name="submit-url">
<tr><td colspan=2><input type=submit name="submit" value="Save"></td></tr>
</form>
</body>
</html> 
