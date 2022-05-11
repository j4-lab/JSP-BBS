<%@page import="session.SessionDAO"%>
<%@page import="member.MemberDAO"%>
<%@page import="java.util.regex.Pattern"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	String memberID = null;
	int session_index = 0;
	int session_result = 0;
	
	if(session.getAttribute("memberID")!=null){
		memberID = (String) session.getAttribute("memberID");
		session_index = (int)session.getAttribute("session_index");
		
		SessionDAO sessionDAO = new SessionDAO();
		
		if(sessionDAO.check(session_index).equals("B")){
			session_result = -1;
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('중복로그인 되었습니다.')");
			script.println("location.href = 'logoutAction.jsp'");
			script.println("</script>");
		}
	}
		
		if(session_result == -1 || memberID==null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인 해주세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		
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
			int result = memDAO.update(mem, memberID);
			
			if(result==-1){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('DB error -1')");
				script.println("history.back()");
				script.println("</script>");
			}
			else{
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('수정이 완료되었습니다.')");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}
		}
	%>
</body>
</html>