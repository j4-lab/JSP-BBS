<%@page import="session.SessionDAO"%>
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
			script.println("alert('로그인이 필요합니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		else{
	
			String uploadPath = "C:/Users/tax/git/repository/BBS/src/main/webapp/upload";
			int fileSize = 1024 * 1024 * 5;
			String enType = "utf-8";
			
			MultipartRequest multi = new MultipartRequest(request, uploadPath, fileSize, enType, new DefaultFileRenamePolicy());
			request.setCharacterEncoding("utf-8");
			
			String title = multi.getParameter("title");
			String content = multi.getParameter("content");
			String fileName = multi.getFilesystemName("upload");
			String fileType = multi.getContentType("upload");
			int boardID = Integer.parseInt(multi.getParameter("board_id"));
			String writer = multi.getParameter("writer");
			
			String check = multi.getParameter("secret");
			boolean secret = false;
			if(check==null)
				secret = false;
			else
				secret =true;
						
			String secret_key = multi.getParameter("secret_key");
			String wip = request.getRemoteAddr();
			
			if(!memberID.equals(writer)){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			
			File file = multi.getFile("upload");
			long filesize = 0;
			if(file!=null){
				filesize = file.length();
			}
			
			if(title.equals("")|| content.equals("")){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력되지 않은 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else if(secret==true && secret_key.equals("")){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('비밀글 암호를 입력해주세요.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else{
				BoardDAO boardDAO = new BoardDAO();
				int result = 0;
 				int result1 = 0;
 				int count = 0;
 				
				if(filesize!=0){
					FileDAO fileDAO = new FileDAO();
					
					String[] allow = {"image/jpeg","image/png","image/jpg"};
					
					for(int i=0;i<allow.length;i++){
						if(fileType.equals(allow[i])){
							count++;
						}
					}
					
					if(count>0){
						if(fileDAO.isExist(boardID)){
							result1 = fileDAO.update(boardID,fileName);
						}else{
							result1 = fileDAO.upload(boardID,fileName);
						}
		 				result = boardDAO.update(boardID, title, content, secret, secret_key);}
					else{
						result1 = -2;
					}
				}
 				
 				if(result==-1 ){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글쓰기에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
 				}
 				else if(result1==-1){
 					
 					PrintWriter script = response.getWriter();
 					script.println("<script>");
 					script.println("alert('파일업로드에 실패했습니다.')");
 					script.println("history.back()");
 					script.println("</script>");
 				}else if(result1==-2){
 					
 					PrintWriter script = response.getWriter();
 					script.println("<script>");
 					script.println("alert('jpg,png,jpeg 파일만 가능합니다.')");
 					script.println("history.back()");
 					script.println("</script>");
 				}
 				else{
 					PrintWriter script = response.getWriter();
 					script.println("<script>");
 					script.println("location.href = 'board.jsp'");
 					script.println("</script>");
 				}
				
 			}
		}
	%>
</body>
</html>