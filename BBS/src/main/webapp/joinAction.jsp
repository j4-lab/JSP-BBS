<%@page import="java.util.regex.Pattern"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="mem" class="member.Member" scope="page" />
<jsp:setProperty name="mem" property="id" />
<jsp:setProperty name="mem" property="pw" />
<jsp:setProperty name="mem" property="name" />
<jsp:setProperty name="mem" property="gender" />
<jsp:setProperty name="mem" property="email" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP BBS</title>
</head>
<body>
	<%
		if(mem.getId() == null || mem.getPw() == null || mem.getName() == null || 
				mem.getGender() == null || mem.getEmail() == null ){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력되지 않은 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else{
			
			MemberDAO memDAO = new MemberDAO();
			int result = memDAO.join(mem);
			
			if(result==-1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('존재하는 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else{
				session.setAttribute("memberID", mem.getId());
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}
		}
	%>
</body>
</html>