<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<% 
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String message=(String)request.getAttribute("message"); 

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" ></meta>
<title>错误提示</title>
	<link href="<%=basePath %>css/style.css" rel="stylesheet"></link>
</head>

<body>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><table width="419" height="226" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center" background="<%=basePath %>images/error.jpg"><table width="388" height="194" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center"><img src="<%=basePath %>images/error_b.gif" width="31" height="31">&nbsp;&nbsp; <%=message%> <br>
              <br>
              <!--  
              <input name="Submit" type="submit" class="btn_grey" value="返回" onClick="history.back(-1)">--></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>
</body>
</html>
