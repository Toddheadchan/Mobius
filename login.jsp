<%@ page language="java" import="java.util.*,java.io.*,java.sql.*,java.text.*,java.net.*" pageEncoding="UTF-8" 
contentType="text/html;charset=UTF-8"%>

<%
	String msg = "";
	String error_msg = "";

	// get the account
	String account = "";
	Object accountObject = request.getParameter("account");
	if (accountObject != null) account = accountObject.toString();

	// get the password
	String password = "";
	Object passwordObject = request.getParameter("password");
	if (passwordObject != null) password = passwordObject.toString();

	// get if it is submitted
	Object submitObject = request.getParameter("submit");
	// it is submitted
	if (submit != null) {
		if (account.equals("")) error_msg="账号不能为空";
		else if (password.equals("")) error_msg="密码不能为空";
		// check if the password match the account
		// from the database
		else {
			try{ // get the database

				String connectString = "jdbc:mysql://localhost:3306/chatroom"
								+ "?autoReconnect=true&useUnicode=true"
								+ "&characterEncoding=UTF-8";

				Class.forName("com.mysql.jdbc.Driver");
				Connection con=DriverManager.getConnection(connectString, "chatroom", "chatroom");
				Statement stmt=con.createStatement();
				ResultSet rs=stmt.executeQuery("select * from userinfo where account = '" + account + "'");
				if (rs.next()) {
					String correctPassword = rs.getString("password");
					if (password.equals("correctPassword") == false) 
						error_mst = "密码错误";
				} else {
					error_msg="账号不存在";
				}
				rs.close();
				stmt.close();
				con.close();
			}
			catch (Exception e){
	  			msg = e.getMessage();
			}

			// no error message, means log in success
			if (error.msg.equals(""))
				response.sendRedirect("action_server.jsp?action=");

		}
	}
%>

<!DOCTYPE html>
<html>
<head>
	<title>log in</title>
</head>
<body>
	<form action="login.jsp" method="get">
		<input type="hidden" name="action" value="verify_login">
		账号：<input type="text" name="account" value="<%=account%>">
		密码：<input type="password" name="password">
		<input type="submit" name="submit" value="登录">
	</form>
</body>
</html>