<%@page import="session.SessionDAO"%>
<%@page import="comment.CommentDAO"%>
<%@page import="comment.Comment"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="file.FileDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.io.PrintWriter" %>


<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP BBS</title>
</head>
<body>
	<%
		int boardID=0;
		if(request.getParameter("board_id")!=null){
			boardID=Integer.parseInt(request.getParameter("board_id"));
		}
		if(boardID==0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'board.jsp'");
			script.println("</script>");
		}
		
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
		
		if(memberID==null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}else{
	
			String content = request.getParameter("commentContent");
			
			if(content==null || content.equals("")){
				PrintWriter script= response.getWriter();
				script.println("<script>");
				script.println("alert('댓글을 입력해주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else{
				CommentDAO commentDAO = new CommentDAO();
				
 				int result = commentDAO.write(boardID, content, memberID);
 			 				
 				if(result==-1 ){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('댓글쓰기에 실패했습니다.')");
				script.println("location.href = 'board.jsp'");
				script.println("</script>");
 				}
 				else{
 					String url = "view.jsp?board_id="+boardID;
 					PrintWriter script = response.getWriter();
 					script.println("<script>");
 					script.println("location.href='"+url+"'");
 					script.println("</script>");
 				}
				
 			}
		}
	%>
</body>
</html>