<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>Route Setup</title>
<script type="text/javascript" src="util_gw.js"> </script>
<script>
var wan_type=<% write(getIndex("wanDhcp")); %>;	
var system_opmode =<% write(getIndex("opMode")); %>;
var total_StaticNumber=<% write(getIndex("staticRouteNum"));%>;
function validateNum(str)
{
  for (var i=0; i<str.length; i++) {
   	if ( !(str.charAt(i) >='0' && str.charAt(i) <= '9')) {
		alert("Invalid value. It should be in decimal number (0-9).");
		return false;
  	}
  }
  return true;
}
function checkIpSubnetAddr(field, msg)
{
  if (field.value=="") {
	alert("IP address cannot be empty! It should be filled with 4 digit numbers as xxx.xxx.xxx.xxx.");
	field.value = field.defaultValue;
	field.focus();
	return false;
  }
   if ( validateKey(field.value) == 0) {
      alert(msg + ' value. It should be the decimal number (0-9).');
      field.value = field.defaultValue;
      field.focus();
      return false;
   }
   if ( !checkDigitRange(field.value,1,1,223) ) {
      alert(msg+' range in 1st digit. It should be 1-223.');
      field.value = field.defaultValue;
      field.focus();
      return false;
   }
   if ( !checkDigitRange(field.value,2,0,255) ) {
      alert(msg + ' range in 2nd digit. It should be 0-255.');
      field.value = field.defaultValue;
      field.focus();
      return false;
   }
   if ( !checkDigitRange(field.value,3,0,255) ) {
      alert(msg + ' range in 3rd digit. It should be 0-255.');
      field.value = field.defaultValue;
      field.focus();
      return false;
   }
   if ( !checkDigitRange(field.value,4,0,255) ) {
      alert(msg + ' range in 4th digit. It should be 0-255.');
      field.value = field.defaultValue;
      field.focus();
      return false;
   }
   return true;
}
function checkSubnet(ip, mask)
{
  
  ip_d = getDigit(ip.value, 1);
  mask_d = getDigit(mask.value, 1);
  ip_d = ip_d & mask_d ;
  strIp = ip_d + '.' ;

  ip_d = getDigit(ip.value, 2);
  mask_d = getDigit(mask.value, 2);
  ip_d = ip_d & mask_d ;
  strIp += ip_d + '.' ;
  

  ip_d = getDigit(ip.value, 3);
  mask_d = getDigit(mask.value, 3);
  ip_d = ip_d & mask_d ;
  strIp += ip_d + '.' ;
  

  ip_d = getDigit(ip.value, 4);
  mask_d = getDigit(mask.value, 4);
  ip_d = ip_d & mask_d ;
  strIp += ip_d ;
  ip.value = strIp ;  
 
  return true ;
}

function addClick()
{
    var t1; 	
    var first_ip;
    var route_meteric;
  if (!document.formRouteAdd.enabled.checked)
  	return true;

  if (document.formRouteAdd.ipAddr.value=="" && document.formRouteAdd.subnet.value==""
  		&& document.formRouteAdd.gateway.value=="" )
	return true;
  if ( checkIpSubnetAddr(document.formRouteAdd.ipAddr, 'Invalid IP address value! ') == false )
              return false;

t1=document.formRouteAdd.ipAddr.value.indexOf('.');
if(t1 !=-1)
first_ip=document.formRouteAdd.ipAddr.value.substring(0,t1);
if(first_ip=='127'){
	alert('Invalid IP address value! ');
	return false;
}

  if (checkIPMask(document.formRouteAdd.subnet) == false)
		        return false ;
  
  if ( checkIpAddr(document.formRouteAdd.gateway, 'Invalid Gateway address! ') == false )
              return false;
  checkSubnet(document.formRouteAdd.ipAddr, document.formRouteAdd.subnet);
  
  if ( validateNum(document.formRouteAdd.metric.value) == 0 ) {
  	document.formRouteAdd.metric.focus();
	return false;
  }
  route_metric = parseInt(document.formRouteAdd.metric.value);
  if((document.formRouteAdd.metric.value=="") || (route_metric > 15 ) || (route_metric < 1)){
  	alert('Invalid metric value! The range of Metric is 1 ~ 15.');
  	return false
  }
   return true;
}


function deleteClick()
{
  if ( !confirm('Do you really want to delete the selected entry?') ) {
	return false;
  }
  else
	return true;
}

function deleteAllClick()
{
   if ( !confirm('Do you really want to delete the all entries?') ) {
	return false;
  }
  else
	return true;
}

function disableDelButton()
{
	disableButton(document.formRouteDel.deleteSelRoute);
	disableButton(document.formRouteDel.deleteAllRoute);
}

function Route_updateState()
{
  if (document.formRouteAdd.enabled.checked) {
 	enableTextField(document.formRouteAdd.ipAddr);
 	enableTextField(document.formRouteAdd.subnet);
 	enableTextField(document.formRouteAdd.gateway);
 	enableTextField(document.formRouteAdd.metric);
 	document.formRouteAdd.iface.disabled=false;
  }
  else {
 	disableTextField(document.formRouteAdd.ipAddr);
 	disableTextField(document.formRouteAdd.subnet);
 	disableTextField(document.formRouteAdd.gateway);
 	disableTextField(document.formRouteAdd.metric);
 	document.formRouteAdd.iface.disabled=true;
  }
}
function updateStateRip()
{
	var dF=document.formRouteRip;
  if (document.formRouteRip.enabled.checked) {
 	enableRadioGroup(document.formRouteRip.nat_enabled);
	enableRadioGroup(document.formRouteRip.rip_tx);
	enableRadioGroup(document.formRouteRip.rip_rx);
	//ppp wan type will force NAT is enabled
	  if ((wan_type != 0) && (wan_type != 1)){
   			dF.nat_enabled[0].disabled = true;
   			dF.nat_enabled[1].disabled = true;
   			dF.nat_enabled[0].checked=true;
	}
	nat_setting_ripTx();
  }
  else {
  	disableRadioGroup(document.formRouteRip.nat_enabled);
	disableRadioGroup(document.formRouteRip.rip_tx);
	disableRadioGroup(document.formRouteRip.rip_rx);
  }
  
}

function StaticRouteTblClick(url) {
		openWindow(url, 'RouteTbl',600, 400 );
}

function nat_setting_ripTx(){
	var dF=document.forms[0];
	var nat = get_by_name("nat_enabled");
	var tx = get_by_name("rip_tx");
	var dynamic_route=document.formRouteRip.enabled.checked;
	for (var i = 0; i < 3; i++){
		if(dynamic_route==true)
			tx[i].disabled = nat[0].checked;
		else
			tx[i].disabled=true;
	}
	
	if (nat[0].checked){
		tx[0].checked = true;
	}
}

function RIP_LoadSetting()
{
	var dF=document.formRouteRip;
	var nat_setting=<% write(getIndex("nat_enabled")); %>;
	var rip_tx_setting=<% write(getIndex("ripLanTx")); %>;
	var rip_rx_setting=<% write(getIndex("ripLanRx")); %>;
	var rip_enabled = <%write(getIndex("ripEnabled"));%>;
	if(rip_enabled==1){
		dF.enabled.checked=true;
	}else
		dF.enabled.checked=false;
		
	updateStateRip();	
	if(nat_setting==1){
		dF.nat_enabled[0].checked=true;
	}else{
		dF.nat_enabled[1].checked=true;
	}
	
	//ppp wan type will force NAT is enabled
	  if ((wan_type != 0) && (wan_type != 1)){
   			dF.nat_enabled[0].disabled = true;
   			dF.nat_enabled[1].disabled = true;
   			dF.nat_enabled[0].checked=true;
	}
	dF.rip_tx[rip_tx_setting].checked=true;
	dF.rip_rx[rip_rx_setting].checked=true;
	nat_setting_ripTx();
}	
function Route_LoadSetting()
{
	var dF=document.formRouteAdd;
	var dFDel=document.formRouteDel;
	var static_route_enabled=<%write(getIndex("staticRouteEnabled"));%>;
	if(static_route_enabled==1)
		dF.enabled.checked=true;
	else
		dF.enabled.checked=false;
	Route_updateState();
	if(dF.enabled.checked==false){
		for(entry_index=1;entry_index<=total_StaticNumber;entry_index++){
			dFDel.elements["select"+entry_index].disabled=true;
		}
	}
}

function SetRIPClick()
{
	var dF=document.formRouteRip;
	 if ((wan_type != 0) && (wan_type != 1)){
	 	if(dF.enabled.checked==true){
	 		if(dF.nat_enabled[1].checked==true){
	 			alert("You can not disable NAT in PPP wan type!");
	 			return false;
	 		}
	 	}
	}
}
function Route_Reset()
{
	var dF=document.formRouteAdd;
	dF.ipAddr.value="";
	dF.subnet.value="";
	dF.gateway.value="";
	dF.iface.selectedIndex=0;
}
function Set_Opmode()
{
	var dF;
	var entry_index;
	if(system_opmode == 1){
		dF=document.formRouteRip;
		dF.enabled.disabled=true;
		dF.nat_enabled[0].disabled=true;
		dF.nat_enabled[1].disabled=true;
		dF.rip_tx[0].disabled=true;
		dF.rip_tx[1].disabled=true;
		dF.rip_tx[2].disabled=true;
		dF.rip_rx[0].disabled=true;
		dF.rip_rx[1].disabled=true;
		dF.rip_rx[2].disabled=true;
		dF.ripSetup.disabled=true;
		dF.reset.disabled=true;
		dF=document.formRouteAdd;
		dF.enabled.disabled=true;
		dF.ipAddr.disabled=true;
		dF.subnet.disabled=true;
		dF.gateway.disabled=true;
		dF.iface.disabled=true;
		dF.addRoute.disabled=true;
		dF.reset.disabled=true;
		dF.showRoute.disabled=true;
		dF=document.formRouteDel;
		dF.deleteSelRoute.disabled=true;
		dF.deleteAllRoute.disabled=true;
		dF.reset.disabled=true;
		for(entry_index=1;entry_index<=total_StaticNumber;entry_index++){
			dF.elements["select"+entry_index].disabled=true;
		}
	}
}



</script>
</head>

<body onload="RIP_LoadSetting();Route_LoadSetting();Set_Opmode();">
<blockquote>
<h2><font color="#0000FF">Routing Setup</font></h2>

<table border=0 width="500" cellspacing=4 cellpadding=0>
<tr><td colspan= 2><font size=2>
 This page is used to setup dynamic routing protocol or edit static route entry.
</font></td></tr>

<tr><td colspan=2><hr size=1 noshade align=top></td></tr>
<form action=/goform/formRoute method=POST name="formRouteRip">
<tr><td colspan=2><font size=2><b>
   	<input type="checkbox" name="enabled" value="ON" onclick="updateStateRip()">&nbsp;&nbsp;Enable Dynamic Route</b><br>
</tr>


 <tr>
      <td width="30%"><font size=2><b>NAT:</b></td>
      <td width="70%"><font size=2>
      <input type="radio" name="nat_enabled" value="0" onClick="nat_setting_ripTx()">Enabled&nbsp;&nbsp;
      <input type="radio" name="nat_enabled" value="1" onClick="nat_setting_ripTx()">Disabled</td>
    </tr>
	<tr>
      <td width="30%"><font size=2><b>Transmit:</b></td>
      <td width="70%"><font size=2>
      <input type="radio" name="rip_tx" value="0">Disabled&nbsp;&nbsp;
      <input type="radio" name="rip_tx" value="1">RIP 1
      <input type="radio" name="rip_tx" value="2">RIP 2</td>
    </tr>
<tr>
      <td width="30%"><font size=2><b>Receive:</b></td>
      <td width="70%"><font size=2>
      <input type="radio" name="rip_rx" value="0">Disabled&nbsp;&nbsp;
      <input type="radio" name="rip_rx" value="1">RIP 1
      <input type="radio" name="rip_rx" value="2">RIP 2</td>
    </tr>

   <tr><td colspan=2><p><input type="submit" value="Apply Changes" name="ripSetup" onClick="return SetRIPClick()" >&nbsp;&nbsp; 
   	<input type="button" value="Reset" name="reset" onClick="RIP_LoadSetting()"></td></tr>
   <tr><td colspan=2> <hr size=1 noshade align=top></td></tr>
   <input type="hidden" value="/route.asp" name="submit-url">
  
</form>
<form action=/goform/formRoute method=POST name="formRouteAdd">
<tr><td colspan=2><font size=2><b>
   	<input type="checkbox" name="enabled" value="ON" onclick="Route_updateState()">&nbsp;&nbsp;Enable Static Route</b><br>
    </td>
</tr>

  <tr>
       <td width="30%"><font size=2><b>IP Address:</b></td>
       <td width="70%"><font size=2>
        <input type="text" name="ipAddr" size="18" maxlength="15" value="">
      </td>
    </tr>
    <tr>
      <td width="30%"><font size=2><b>Subnet Mask:</b></td>
      <td width="70%"><font size=2><input type="text" name="subnet" size="18" maxlength="15" value=""></td>
    </tr>
    
    <tr>
      <td width="30%"><font size=2><b>Gateway:</b></td>
      <td width="70%"><font size=2><input type="text" name="gateway" size="18" maxlength="15" value=""></td>
    </tr>
     <tr>
 	<td width="30%"><font size=2><b>Metric:</b></td>
 	<td width="70%"><input type="text" id="metric" name="metric" size="3" maxlength="2" value=""></td>
 	</tr>
 <tr>
 <td width="30%"><font size=2><b>Interface:</b></td>
 <td width="70%"><font size=2>
 <select size="1" id="iface" name="iface">
 <option value="0">LAN</option>
 <option value="1">WAN</option>
 </select>
 </td>
 </tr>
 
    <tr><td colspan=2>
     <p><input type="submit" value="Apply Changes" name="addRoute" onClick="return addClick()">&nbsp;&nbsp;
        <input type="button" value="Reset" name="reset" onClick="Route_Reset();Route_LoadSetting();">
        <input type="hidden" value="/route.asp" name="submit-url">
        <input type="button" value="Show Route Table" name="showRoute" onClick="StaticRouteTblClick('/routetbl.asp')">
     </p>
     </td></tr>
<!--     
<script> Route_updateState(); </script>
-->
</td><tr>
</form>
</table>

<br>
<form action=/goform/formRoute method=POST name="formRouteDel">
  <table border="0" width=500>
  <tr><font size=2><b>Static Route Table:</b></font></tr>
  <% staticRouteList(); %>
  </table>
  <br>
  <input type="submit" value="Delete Selected" name="deleteSelRoute" onClick="return deleteClick()">&nbsp;&nbsp;
  <input type="submit" value="Delete All" name="deleteAllRoute" onClick="return deleteAllClick()">&nbsp;&nbsp;&nbsp;
  <input type="reset" value="Reset" name="reset">
  <input type="hidden" value="/route.asp" name="submit-url">
</form>
 <script>
   	<% entryNum = getIndex("staticRouteNum");
   	  if ( entryNum == 0 ) {
      	  	write( "disableDelButton();" );
       	  } %>
 </script>
</blockquote>
</body>
</html>
