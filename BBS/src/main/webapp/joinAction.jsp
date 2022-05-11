<%@page import="session.SessionDAO"%>
<%@page import="java.util.regex.Pattern"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
request.setCharacterEncoding("UTF-8");
%>
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
	String regExpPw = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9ㄱ-힣]).{8,20}$";

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
	
	if (memberID != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 로그인이 되어있습니다.')");
		script.println("location.href = 'main.jsp'");
		script.println("</script>");
	}

	if (mem.getId() == null || mem.getPw() == null || mem.getName() == null || mem.getGender() == null
			|| mem.getEmail() == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력되지 않은 사항이 있습니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else if (!Pattern.matches(regExpPw, mem.getPw())) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('8~20자 사이의 영어소문자/대문자/숫자/특수문자를 포함한 비밀번호를 입력해주세요.')");
		script.println("history.back()");
		script.println("</script>");
	} else {

		MemberDAO memDAO = new MemberDAO();
		int result = memDAO.join(mem);

		if (result == -1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
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