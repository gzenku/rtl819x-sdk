<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>Realtek WLAN AP Webserver</title>

<script language=JavaScript>
	<!--
		var count = <% getInfo("countDownTime"); %>*1;
		var pocketRouter_Mode="<% getInfo("pocketRouter_Mode_countdown"); %>"*1; /* 1:client 2:AP */

		var browser=eval ( '"' + top.location + '"' );
		var ip_lan = "<% getInfo('ip-lan'); %>";
		var domainName = "<% getInfo('domainName'); %>";
		var connect_url;

		if(pocketRouter_Mode != 0)
		{
			if(pocketRouter_Mode == 1)
				domainName = domainName+"cl";
			else
				domainName = domainName+"ap";
				
			domainName = domainName.toLowerCase();
//alert("domainName="+domainName);
			
			if (browser.indexOf(ip_lan) == -1 && browser.indexOf(domainName) == -1)
			{				
				connect_url = domainName+".com";
				parent.location.href = 'http://'+connect_url;
			}							
		}
	//-->
</script>		
</head>

<FRAMESET ROWS="60,1*" COLS="*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="NO">

  <FRAME SRC="title.htm" NAME="title" FRAMEBORDER="NO" SCROLLING="NO" MARGINWIDTH="0" MARGINHEIGHT="0">

  <FRAMESET COLS="180,1*">

    <frameset frameborder="0" framespacing="0" border="0" cols="*" rows="0,*">
      <frame marginwidth="0" marginheight="0" src="code.asp" name="code" noresize scrolling="no" frameborder="0">
      <frame marginwidth="5" marginheight="5" src="menu_empty.html" name="menu" noresize scrolling="auto" frameborder="0">
    </frameset>
    <frame SRC="<% getInfo("initpage"); %>" NAME="view" SCROLLING="AUTO" MARGINWIDTH="0" TOPMARGIN="0" MARGINHEIGHT="0" FRAMEBORDER="NO">

  </FRAMESET>
</FRAMESET>

<NOFRAMES>
<BODY BGCOLOR="#FFFFFF">

</BODY></NOFRAMES>
</HTML>
