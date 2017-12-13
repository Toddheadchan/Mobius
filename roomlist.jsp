<%@ page language="java" import="java.util.*,java.io.*,java.sql.*,java.text.*,java.net.*" pageEncoding="UTF-8" 
contentType="text/html;charset=UTF-8"%>

<!-- operation for form and request -->
<%
	Object keywordObject = request.getParameter("keyword");
	if (keywordObject == null) {
		// goto 404
	}
	String keyword = keywordObject.toString();
	// decode for Chinese keyword
	keyword = URLDecoder.decode(keyword,"iso-8859-1");

	// if the keyword is empty, then back to index
	if (keyword.equals("")) response.sendRedirect("index.jsp");

%>

<!-- operation for database -->
<%
	// the string to get the error connecting database
	String error_msg = "no error"; 

	// the size of the result from the database
	int size = 0;
	String roomname[] = new String [1000];
	String roomid[] = new String [1000];

	try {

		// connect to the chatroom database
		String connectString = "jdbc:mysql://172.18.94.83:3306/chatroom"
								+ "?autoReconnect=true&useUnicode=true"
								+ "&characterEncoding=UTF-8";

		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, "chatroom", "chatroom");
		Statement stmt=con.createStatement();
		ResultSet rs=stmt.executeQuery("select * from roomlist where roomname like '%" + keyword + "%'");

		// set down all the information of the query
		while (rs.next()) {
			roomname[size] = rs.getString("roomname");
			roomid[size] = rs.getString("roomid");
			size++;
		}

	}

	catch (Exception ex) {
		error_msg = ex.getMessage();
	}

%>

<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/roomlist.css">
	<title>Mobius_<%=keyword%></title>
</head>
<body>

	<div class="header">

		<div class="logo">
			<a href="index.jsp">
				<img src="image/logo.png">
			</a>
		</div>

		<div class="blank">       </div>

		<div class="searching_box">
			<form action="action_server.jsp" method="get">
				<input type="hidden" name="action" value="keyword">
				<input type="text" class="keyword" name="keyword" value="<%=keyword%>">
				<input type="submit" name="submit" value="搜索">
			</form>
		</div>

	</div>

	<div class="roomlist">

	<%
		for (int ind=0; ind<size; ind++) {
			// a link
			out.print("<a href=\"action_server.jsp?action=intoroom&roomid=" + roomid[ind] + "\">"
						+ roomname[ind] + "</a>" + "<br>\n");
		}
	%>

	</div>

</body>
</html>