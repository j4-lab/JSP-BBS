<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="mem" class="member.Member" scope="page" />
<jsp:setProperty name="mem" property="id" />
<jsp:setProperty name="mem" property="pw" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP BBS</title>
</head>
<body>
	<%
		String memberID = null;
		if(session.getAttribute("memberID")!=null){
			memberID = (String) session.getAttribute("memberID");
		}
		
		if(memberID!=null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
	
		MemberDAO memberDAO = new MemberDAO();
		int result = memberDAO.login(mem.getId(), mem.getPw());
		if(result==1){
			
			session.setAttribute("memberID", mem.getId());
			
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href ='main.jsp'");
			script.println("</script>");
		}
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 실패')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>