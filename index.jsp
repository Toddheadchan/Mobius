<%@ page language="java" import="java.util.*,java.io.*,java.sql.*,java.text.*" pageEncoding="UTF-8" 
contentType="text/html;charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/index.css">
	<title>Mobius</title>
</head>
<body>

	<div class="home_logo">
		<a href="index.jsp">
			<img src="image/logo.png">
		</a>
	</div>

	<div class="searching_box">
		<form action="action_server.jsp" method="get">
			<input type="hidden" name="action" value="keyword">
			<input type="text" class="keyword" name="keyword">
			<input type="submit" name="submit" value="搜索">
		</form>
	</div>

</body>
</html>