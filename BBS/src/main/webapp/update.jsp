<%@page import="file.FileDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%!Board result; %>

	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
			aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP BBS</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class = "active"><a href="board.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>			
		</div>
	</nav>
		<%
		String memberID = null;
		if(session.getAttribute("memberID")!=null){
			memberID = (String) session.getAttribute("memberID");
		}
		
		if(memberID==null)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 해주세요.')");
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
		result = board;
		
		if(!memberID.equals(board.getWriter())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'board.jsp'");
			script.println("</script>");
		}
	%>
	<div class="container">
		<div class="row">
		<form method="post" action="updateAction.jsp?=board_id=<%=boardID %>" enctype="multipart/form-data">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 번호</td>
						<td colspan="3"><input type="text" class="form-control" placeholder="글 번호" name="board_id" maxlength="50" value=<%=result.getBoard_id()%> readonly="readonly"></td>
					</tr>
					<tr>
						<td>글 제목</td>
						<td colspan="3"><input type="text" class="form-control" placeholder="글 제목" name="title" maxlength="50" value=<%=result.getTitle()%>></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="3"><input type="text" class="form-control" placeholder="작성자" name="writer" maxlength="50" value=<%=result.getWriter()%> readonly="readonly"></td>
					</tr>
					<tr>
					<%
					 if(result.isSecret())
					 {
					%>
						<td><input type="checkbox" name="secret" value="true" checked="checked">비밀글</td>
						<td><input type="text" class="form-control" placeholder="4자리 숫자" name="secret_key" maxlenth="4" value=<%=result.getSecret_key() %>></td>						
					<%	 
					 }else{
					%>
						<td><input type="checkbox" name="secret" value="false" >비밀글</td>
						<td><input type="text" class="form-control" placeholder="4자리 숫자" name="secret_key" maxlenth="4"></td>	
					<%
					 }
					%>
						</tr>
					<tr>
						<td>첨부파일</td>
						<td><input type="file" class="form-control"  name="upload"></td>
					</tr>
					<tr>
						<%
								FileDAO fileDAO = new FileDAO();
								String fileName = fileDAO.view(boardID);
								if(!fileName.equals("")){
						%>		
						<td colspan="2">이전에 첨부한 파일을 삭제하시겠습니까?</td>
						<td><a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteFileAction.jsp?board_id=<%=boardID%>" class="btn btn-primary">삭제</a></td>	
						<%
								}
						%>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="3">						
						<textarea class="form-control" placeholder="글 내용" name="content" maxlength="2048" style="height: 350px"><%=result.getContent()%></textarea></td>
					</tr>
				</tbody>
			</table>
			<input type="submit" class="btn btn-primary pull-right" value="글수정">
			</form>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>