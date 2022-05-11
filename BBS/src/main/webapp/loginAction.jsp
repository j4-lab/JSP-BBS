<%@page import="session.SessionDAO"%>
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
		
		if(memberID!=null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
	
		MemberDAO memberDAO = new MemberDAO();
		SessionDAO sessionDAO = new SessionDAO();
		
		int fail_count = memberDAO.getFailCount(mem.getId());
		if(fail_count>=3){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('실패 횟수를 초과하였습니다. 관리자에게 문의하세요.')");
			script.println("location.href ='main.jsp'");
			script.println("</script>");
		}else{
			int result = memberDAO.login(mem.getId(), mem.getPw());
			if(result==1){
				
				session.setAttribute("memberID", mem.getId());
				int result1 = sessionDAO.update(String.valueOf(session.getAttribute("memberID")));
				session.setAttribute("session_index", sessionDAO.getSessionIndex());
				
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
		}
	%>
</body>
</html>