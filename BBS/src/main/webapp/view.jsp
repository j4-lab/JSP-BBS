<%@page import="session.SessionDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comment.Comment"%>
<%@page import="comment.CommentDAO"%>
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
		
		int pageNumber=1;

		if(request.getParameter("pageNumber")!=null){
			pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
		}
		
		int commentNumber=1;
		
		if(request.getParameter("commentNumber")!=null){
			commentNumber = Integer.parseInt(request.getParameter("commentNumber"));
		}
		
		Board board = new BoardDAO().getBoard(boardID);
		
		if(board.isSecret()){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'secretCheck.jsp'");
			script.println("</script>");
		}
	%>
	
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
			<%
				if(memberID==null){
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			
			<%	
				}else{
			%>
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
			<%
				}
			%>
			
		</div>
	</nav>
	
	<% if(!board.isSecret()){ %>
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd;">
				<thead>
					<tr>
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%=board.getTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%=board.getWriter().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%=board.getRegdate().substring(0,11)+board.getRegdate().substring(11,13)+"시"+board.getRegdate().substring(14,16)+"분"%></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="2">
							<%
								FileDAO fileDAO = new FileDAO();
								String fileName = fileDAO.view(boardID);
								if(!fileName.equals("")){
							%>		
							<div class="item">
								<img src="upload/<%= fileName%>" style="max-width:100%; height:auto;">
							</div>
							<%
								}
							%>
							
							<div class="bbs-content" style="min-height: 200px; text-align: left;">
							<%=board.getContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%>
							</div> 
						</td>
					</tr>
				</tbody>
			</table>
			
			<form method="post" action="commentAction.jsp?board_id=<%=boardID %>">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3" style="background-color: #eeeeeee; text-align: center;">댓글</th>
						</tr>
					</thead>
					<tbody>
					
						<%
							CommentDAO commentDAO=new CommentDAO();
							ArrayList<Comment> list=commentDAO.getList(boardID, commentNumber);
							for(int i=list.size()-1;i>=0;i--){
						%>
						<tr>
							<td style="text-align: left;"><%= list.get(i).getContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
							<td style="text-align: right;"><%= list.get(i).getWriter() %>
							<%
								if(memberID!=null && memberID.equals(list.get(i).getWriter())){
							%>
									<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteCommentAction.jsp?comment_id=<%=list.get(i).getComment_id() %>" class="btn">삭제</a>
							<%
								}
							%>
							</td>
						</tr>
						<%
								}
						%>
						
						<% 
							if(memberID!=null){
						%>
						<tr >
							<td ><textarea type="text" class="form-control"
									placeholder="댓글을 입력하세요." name="commentContent" maxlength="500"></textarea></td>
							<td style="text-align: left; "></td>
						</tr>
						<%
							}
						%>
					</tbody>
				</table>
						<% 
							if(memberID!=null){
						%>
				<div style="text-align: center;">
					<input type="submit" class="btn" value="댓글입력"  >
				</div>
						<%
						}
						%>
			</form>
			<br>
			<%
				if(commentNumber!=1){
			%>
				<a href="view.jsp?board_id=<%=boardID%>&commentNumber=<%=commentNumber-1%>" class = "btn btn-success btn-arraw-left">이전 댓글</a>
			<%
// 				} if(boardDAO.nextPage(pageNumber+1)){
				} if(Math.ceil(commentDAO.countData(boardID)/10)>=commentNumber){
			%>
				<a href="view.jsp?board_id=<%=boardID%>&commentNumber=<%=commentNumber+1%>" class = "btn btn-success btn-arraw-right">다음 댓글</a>
			<%
				}
			%>
			<br>
			<a href="board.jsp" class="btn btn-primary">목록</a>
			<%
				if(memberID==null){}
				else if(memberID!=null & memberID.equals(board.getWriter())){
			%>
					<a href="update.jsp?board_id=<%=boardID%>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?board_id=<%=boardID%>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	
	<%} %>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>