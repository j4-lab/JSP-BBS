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
		
		Board board = new BoardDAO().getBoard(boardID);
		
		if(!memberID.equals(board.getWriter())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		else{
				FileDAO fileDAO = new FileDAO();
				
				if(!fileDAO.isExist(boardID)){
					
					fileDAO.delete(boardID);
					
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'board.jsp'");
					script.println("</script>");
				}else{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('파일 삭제에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
		}
	%>
</body>
</html>