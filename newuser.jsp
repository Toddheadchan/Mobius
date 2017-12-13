<%@ page language="java" import="java.util.*,java.io.*,java.sql.*,java.text.*,java.net.*" pageEncoding="UTF-8" 
contentType="text/html;charset=UTF-8"%>

<%
	String error_msg = "";
	String msg = "";

	Object roomidObject = request.getParameter("roomid");
	String roomid = "";
	if (roomidObject == null) ;
		// redirect to 404
	// get the roomid
	else {
		roomid = roomidObject.toString();
	}

	String username = "";

	long currentTime = 100,lastTime = 0;

	Object submit = request.getParameter("submit");
	// a new user name is submit
	// then verify if it is valid
	if (submit != null) {

		username = request.getParameter("account").toString();

		try {

			// connect to the chatroom database
			String connectString = "jdbc:mysql://172.18.94.83:3306/chatroom"
									+ "?autoReconnect=true&useUnicode=true"
									+ "&characterEncoding=UTF-8";

			Class.forName("com.mysql.jdbc.Driver");
			Connection con=DriverManager.getConnection(connectString, "chatroom", "chatroom");
			Statement stmt=con.createStatement();
			ResultSet rs=stmt.executeQuery("select max(time_long) as 'lastTime' from room0 where username='" + username + "';");

			// set down all the information of the query
			while (rs.next()) {
				java.util.Date date = new java.util.Date();
				currentTime = date.getTime();
				String lastTimeString = rs.getString("lastTime");
				lastTime = Long.parseLong(lastTimeString);
				if (currentTime - lastTime < 3600000) {
					error_msg = "this user name is still occupied";
				}
			}

		}

		catch (Exception ex) {
			msg = ex.getMessage();
		} 

		// the new username will be set
		// and will be add into the database
		// then will to the chatroom
		if (error_msg.equals("")) {
			response.sendRedirect("action_server.jsp?action=set_new_user&username=" 
									+ username + "&roomid=" + roomid);
		}

	}
%>

<!DOCTYPE html>
<html>
<head>
	<title>create new user</title>
</head>
<body>
	<form action="newuser.jsp?roomid=<%=roomid%>" method="post">
		用户名：<input type="text" name="account" value="<%=username%>"><br>
		<input type="submit" name="submit" value="提交">
	</form>
	<%=error_msg%>
</body>
</html>