<%@page import="comment.CommentDAO"%>
<%@page import="file.FileDAO"%>
<%@page import="file.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP BBS</title>
</head>
<body>
	<%
		String memberID = null;
		if(session.getAttribute("memberID")!=null){
			memberID = (String) session.getAttribute("memberID");
		}
		
		if(memberID==null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		
		int commentID=0;
		if(request.getParameter("comment_id")!=null){
			commentID=Integer.parseInt(request.getParameter("comment_id"));
		}
		if(commentID==0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 댓글입니다.')");
			script.println("location.href = 'board.jsp'");
			script.println("</script>");
		}else{
			
			CommentDAO commentDAO = new CommentDAO();
				
				if(!commentDAO.isExist(commentID)){
					 
					commentDAO.delete(commentID);
					
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'board.jsp'");
					script.println("</script>");
				}else{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글 삭제에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
		}
	%>
</body>
</html>