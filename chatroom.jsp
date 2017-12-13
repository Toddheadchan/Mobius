<%@ page language="java" import="java.util.*,java.io.*,java.sql.*,java.text.*" pageEncoding="UTF-8" 
contentType="text/html;charset=UTF-8"%>

<% response.setHeader("refresh" , "30" ); %>

<%
	request.setCharacterEncoding("utf-8");

	String roomidObject = request.getParameter("roomid");
	String roomid = "";
	if (roomidObject == null) ; //goto 404
	else roomid = roomidObject.toString();

	String username = "";
	String error_msg = ""; // the message shown
	int header_type = 0;

	// get the time and the time string
	SimpleDateFormat df = new SimpleDateFormat("MM-dd HH:mm:ss");
	TimeZone ti = TimeZone.getTimeZone("GMT+8");
	df.setTimeZone(ti);
	String timer = df.format(Calendar.getInstance().getTime());
	java.util.Date date = new java.util.Date();
	long currentTime = date.getTime();

	String roomName = "";

	Object isubmit = request.getParameter("submit");
	Object text_obj = request.getParameter("text");
	String text = "";
	String msg = "";

	if (session.getAttribute("room" + roomid) == null) // find if it is logged in
		header_type = 1;
	else username = session.getAttribute("room" + roomid).toString();

	if (text_obj != null) // get the input info
		text = text_obj.toString();

	// get the title and the roomname
	try {
		String connectString = "jdbc:mysql://localhost:3306/chatroom"
						+ "?autoReconnect=true&useUnicode=true"
						+ "&characterEncoding=UTF-8";

		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, "chatroom", "chatroom");
		Statement stmt=con.createStatement();
		ResultSet rs=stmt.executeQuery("select roomname from roomlist where roomid=" + roomid);
		while (rs.next()) {
			roomName = rs.getString("roomname");
		}
		rs.close();
		stmt.close();
		con.close();
	}
	catch (Exception e) {
		msg = e.getMessage();
	}

	if (text.equals("")==false) { // a new state should be added into the database
		if (header_type == 1) error_msg = "you should log in first";
		else {
			// insert the new item into the database
			try {
				String connectString = "jdbc:mysql://172.18.94.83:3306/chatroom"
							+ "?autoReconnect=true&useUnicode=true"
							+ "&characterEncoding=UTF-8";

				Class.forName("com.mysql.jdbc.Driver");
				Connection con=DriverManager.getConnection(connectString, "chatroom", "chatroom");
				Statement stmt=con.createStatement();
				stmt.execute("insert into room0 values ('"+ timer + "','" + username + "','" 
														+ text + "','" + currentTime + "')");
				stmt.close();
				con.close();
			}
			catch (Exception e){
				msg = e.getMessage();
			}
		}	
	} else if (isubmit != null) error_msg = "cannot send an empty message";

	String message[] = new String [1000];
	int size=0;

	// get the chat data
	try{
		String connectString = "jdbc:mysql://localhost:3306/chatroom"
						+ "?autoReconnect=true&useUnicode=true"
						+ "&characterEncoding=UTF-8";

		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, "chatroom", "chatroom");
		Statement stmt=con.createStatement();
		ResultSet rs=stmt.executeQuery("select * from room0");
		while (rs.next()) {
			message[size]=rs.getString("time") + "   " + rs.getString("username") + ":" + rs.getString("text");
			size++;
		}
		rs.close();
		stmt.close();
		con.close();
	}
	catch (Exception e){
	  msg = e.getMessage();
	}

%>



<html>

	<head>
		<title><%=roomName%></title>
	</head>

	<body>

		<div class="header">
			<% if (header_type==0) {%>
				welcome back <%=username%>
				<a href="action_server.jsp?action=logout&roomid=<%=roomid%>">log out</a>
			<% } else { %>
				<a href="index.html">log in</a>
			<% } %>
		</div>

		<div id="chatbox" class="chatbox" style="height: 380px; overflow: scroll">
			<%
				for (int i=0; i<size; i++)
					out.print("<p>" + message[i] + "</p>");
			%>
		</div>

		<script type="text/javascript">
			document.getElementById('chatbox').scrollTop = document.getElementById('chatbox').scrollHeight;
		</script>

		<div class="inputbox">
			<form method="POST">
				say something:<br>
				<input type="textarea" name="text" style="height: 200px; width: 400px"><br>
				<input type="submit" value="submit">
			</form>
		</div>

		<div class="bottom_message">
			<%=error_msg%>
			<%=msg%>
		</div>

	</body>
</html>