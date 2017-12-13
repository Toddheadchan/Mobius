<%@ page language="java" import="java.util.*,java.io.*" pageEncoding="UTF-8" 
contentType="text/html;charset=UTF-8"%>

<%
	String username = request.getParameter("username").toString();
	session.setAttribute("username",request.getParameter("username").toString());
	response.sendRedirect("chatroom.jsp");
%>