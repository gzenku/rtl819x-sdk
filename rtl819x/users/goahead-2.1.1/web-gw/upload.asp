<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>Firmware Update</title>
<style>
.on {display:on}
.off {display:none}
</style>
<script type="text/javascript" src="util_gw.js"></script>
<script>
var MWJ_progBar = 0;
var time=0;
var delay_time=1000;
var loop_num=0;
var usb_update_img_enabled=<%write(getIndex("usb_update_img_enabled"));%>;

function show_usb_update_img()
{
  if(usb_update_img_enabled == 0)
  { 
	get_by_id("usb_update_img_ln").style.display = "none";
	get_by_id("usb_update_img_nt").style.display = "none";
	get_by_id("usb_update_img_bt").style.display = "none";
	return false;
  }
  else
  {
	get_by_id("usb_update_img_ln").style.display = "";
	get_by_id("usb_update_img_nt").style.display = "";
	get_by_id("usb_update_img_bt").style.display = "";
	return true;
  }
}


function usb_img_upload(F)
{
  if(show_usb_update_img() == false)
  {
	alert("usb update image function is not enabled!");
          return false;
  }

  F.submit();
  show_div(true, "progress_div");   
  progress();
}

function progress()
{
  if (loop_num == 3) {
	alert("Update firmware failed!");
	return false;
  }
  if (time < 1) 
	time = time + 0.033;
  else {
	time = 0;
	loop_num++;
  }
  setTimeout('progress()',delay_time);  
  myProgBar.setBar(time); 
}


function sendClicked(F)
{
  if(document.upload.binary.value == ""){
      	document.upload.binary.focus();
  	alert('File name can not be empty !');
  	return false;
  }
  F.submit();
  show_div(true, "progress_div");   
  progress();
}

</script>

</head>
<BODY onload="show_usb_update_img()">
<blockquote>
<h2><font color="#0000FF">Upgrade Firmware</font></h2>

<form method="post" action="goform/formUpload" enctype="multipart/form-data" name="upload">
<table border="0" cellspacing="4" width="500">
 <tr><font size=2>
 This page allows you upgrade the Access Point firmware to new version. Please note,
 do not power off the device during the upload because it may crash the system.
 </tr>
  <tr><hr size=1 noshade align=top></tr>

<!--
  <tr>
      <td width="20%"><font size=2><b>Start Address:</b></td>
      <td width="80%"><font size=2><input type="text" name="readAddr" size="10" maxlength="8" value=20000>(hex)</td>
  </tr>
  <tr>
      <td width="20%"><font size=2><b>Size:</b></td>
      <td width="80%"><font size=2><input type="text" name="size" size="10" maxlength="8" value=F0000>(hex)</td>
  </tr>
  <tr>
      <td width="20%"><font size=2><b>Save File:</b></td>
      <td width="80%"><font size=2>
      <p><input type="submit" value="Save..." name="save"></p></td>
  </tr>
-->
<tr>
                <td width="50%"><font size=2><b>Firmware Version:</b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td width="50%"><font size=2><% getInfo("fwVersion"); %></td>
</tr>
  <tr>
      <td width="20%"><font size=2><b>Select File:</b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td width="80%"><font size=2><input type="file" name="binary" size=20></td>
  </tr>
  </table> 
    <p> <input onclick=sendClicked(this.form) type=button value="Upload" name="send">&nbsp;&nbsp;    
	<input type="reset" value="Reset" name="reset">
<!--
	<input type="hidden" value="0x10000" name="writeAddrWebPages">
	<input type="hidden" value="0x20000" name="writeAddrCode">
-->
	<input type="hidden" value="/upload.asp" name="submit-url">

    </p>
 </form>
 
<form  method="post" action="goform/formUploadFromUsb" enctype="multipart/form-data" name="usb_upload">
<table border="0" cellspacing="4" width="500">
  <tr><hr size=1 noshade align=top></tr>
 <tr ><font size=2>
 <td id="usb_update_img_nt"  style="display:"  >This page allows you upgrade the  firmware from usb storage device(ex. /tmp/usb/sda1/fw.bin). Please note,
 do not power off the device during the upload because it may crash the system.</td>
 </tr>

  </table> 
    <p> <input id="usb_update_img_bt"  style="display:" onclick=usb_img_upload(this.form) type=button value="Upload from usb" name="submit_usb">&nbsp;&nbsp;  
    </p>
 </form>

<tr><td colspan=2> <hr  id="usb_update_img_ln"  style="display:" size=1 noshade align=top></td></tr>

 <script type="text/javascript" language="javascript1.2">
		var myProgBar = new progressBar(
			1,         //border thickness
			'#000000', //border colour
			'#ffffff', //background colour
			'#043db2', //bar colour
			300,       //width of bar (excluding border)
			15,        //height of bar (excluding border)
			1          //direction of progress: 1 = right, 2 = down, 3 = left, 4 = up
		);
</script>
 
<script>
	
	function click_dual_fw(clickValue)
	{

		if(clickValue)
		{
			document.formDualFirmware.boot_2bank.disabled =false;			
		}
		else
		{
 			document.formDualFirmware.boot_2bank.disabled =true;			
		}
		
	}
	
	function load_dual_fw()
	{
		if(get_by_id("enable_dual_bank").value == 1)
			get_by_id("dualFw").checked = true;
		else
			get_by_id("dualFw").checked = false;
			
		get_by_id("act_bank").innerHTML = get_by_id("currFwBank").value;
		get_by_id("bak_bank").innerHTML = get_by_id("backFwBank").value;		
	}
	function saveChanges(actValue)
	{
		get_by_id("active").value = actValue;		
	}
</script>

<form action=/goform/formDualFirmware method=POST name="formDualFirmware">
<input type="hidden" value="/upload.asp" name="submit-url">	
<input type="hidden" value="<% getInfo("enable_dualFw"); %>" name="enable_dual_bank" id="enable_dual_bank">	
<input type="hidden" value="<% getInfo("currFwBank"); %>" name="currFwBank" id="currFwBank">	
<input type="hidden" value="<% getInfo("backFwBank"); %>" name="backFwBank" id="backFwBank">	
<input type="hidden" value="no" name="active" id="active">

<% getInfo("onoff_dual_firmware_start");%> 
<table border="0" >
	<tr><td colspan=2><font size=2><b>
	   	<input type="checkbox" id="dualFw" name="dualFw" value="ON">&nbsp;&nbsp;Enable Dual Firmware</b><br>
	    </td>
	</tr>
	
	<tr>
		<td width="10%"></td>
		<td><font size=2>Active Bank: <SPAN id=act_bank></SPAN></td>
	</tr>
	<tr>
		<td width="10%"></td>
		<td><font size=2>Backup Bank: <SPAN id=bak_bank></SPAN></td>
	</tr>



</table>
<p>
<input type="submit" value="Apply Changes" name="save" onClick="return saveChanges('save')">&nbsp;&nbsp;
<input type="submit" id="boot_2bank" name="boot_2bank" value="Reboot Form Backup Bank Now" onClick="return saveChanges('reboot')">
<script>
	load_dual_fw();
	click_dual_fw(1*get_by_id("enable_dual_bank").value);
	
	
</script>

<% getInfo("onoff_dual_firmware_end");%> 
</form> 

 
 </blockquote>
</body>
</html>
