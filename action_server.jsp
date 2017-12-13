<%@ page language="java" import="java.util.*,java.io.*,java.sql.*,java.text.*,java.net.*" pageEncoding="UTF-8" 
contentType="text/html;charset=UTF-8"%>

<%request.setCharacterEncoding("utf-8");%>

<%
	// get the type of submit
	Object actionObject = request.getParameter("action");
	String actionContent = actionObject.toString();

	// input a new keyword and jump to the roomlist
	if (actionContent.equals("keyword")) {

		String keyword = request.getParameter("keyword").toString();
	
		// if the keyword is empty, then back to index
		if (keyword.equals("")) response.sendRedirect("index.jsp");

		// the keyword is not empty
		else {
			String encodeKeyword = URLEncoder.encode(keyword,"utf-8");
			response.sendRedirect("roomlist.jsp?keyword=" + encodeKeyword);
		}
	}	

	// if input a room id
	// get if the session has the user name in this room
	// or to enter a new username for the chatroom
	if (actionContent.equals("intoroom")) {
		String roomid = request.getParameter("roomid").toString();
		String roomname = "room" + roomid;
		Object usernameObject = session.getAttribute(roomname);
		// a null username for the chatroom
		// so the user should enter a new user name for the chatroom
		if (usernameObject == null) {
			response.sendRedirect("newuser.jsp?roomid=" + roomid);
		}
		// the user has a username for such a chatroom
		// to directorily redirect to the target chatroom
		else {
			response.sendRedirect("chatroom.jsp?roomid=" + roomid);
		}
	}

	String roomid = "";
	String username = "";

	// the user set a new user name
	// set it to the session
	// and jump into the chatroom
	if (actionContent.equals("set_new_user")) {
		roomid = request.getParameter("roomid").toString();
		username = request.getParameter("username").toString();
		session.setAttribute("room"+roomid,username);
		response.sendRedirect("chatroom.jsp?roomid=" + roomid);
	}

	// log out a username in a room
	// remove the info from the session
	// and jump to newuser page 
	if (actionContent.equals("logout")) {
		roomid=request.getParameter("roomid").toString();
		session.removeAttribute("room"+roomid);
		response.sendRedirect("newuser.jsp?roomid=" + roomid);
	}

%>

<html>
	<body>
		<%=roomid%><br>
		<%=username%>
	</body>
</html>