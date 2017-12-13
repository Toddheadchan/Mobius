<%
	if (session.getAttribute("username")!=null)
		session.removeAttribute("username");
	response.sendRedirect("index.html");
%>