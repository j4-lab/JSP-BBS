<%@page import="session.SessionDAO"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="mem" class="member.Member" scope="page" />
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
	int session_index = 0;
	
	if(session.getAttribute("memberID")!=null){
		memberID = (String) session.getAttribute("memberID");
		session_index = (int)session.getAttribute("session_index");
		
		SessionDAO sessionDAO = new SessionDAO();
		
		if(sessionDAO.check(session_index).equals("B")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('중복로그인 되었습니다.')");
			script.println("location.href = 'logoutAction.jsp'");
			script.println("</script>");
		}
	}
		
		MemberDAO memDAO = new MemberDAO();
		
		int result = memDAO.login(memberID, mem.getPw());
		if(result==1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href ='userUpdate.jsp'");
			script.println("</script>");
		}
		else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀렸습니다.')");
			script.println("location.href = 'userCheck.jsp'");
			script.println("</script>");
		}
	%>
</body>
</html>