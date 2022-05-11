<%@page import="session.SessionDAO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.Board"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
<style type="text/css">
a, a:hover {
	color: #000000;
	text-decoration: none;
}
</style>
</head>
<body>
	<%
	String memberID = null;
	int session_index = 0;

	if (session.getAttribute("memberID") != null) {
		memberID = (String) session.getAttribute("memberID");
		session_index = (int) session.getAttribute("session_index");

		SessionDAO sessionDAO = new SessionDAO();

		if (sessionDAO.check(session_index).equals("B")) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('중복로그인 되었습니다.')");
			script.println("location.href = 'logoutAction.jsp'");
			script.println("</script>");
		}
	}

	int pageNumber = 1;
	if (request.getParameter("pageNumber") != null) {
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
	%>

	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP BBS</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="board.jsp">게시판</a></li>
			</ul>
			<%
			if (memberID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul></li>
			</ul>

			<%
			} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
			}
			%>

		</div>
	</nav>

	<div class="container">
		<div class="row" style="padding: 0px 0px 10px 0px;">
			<form method="post" name="search" action="searchBoard.jsp">
				<table class="pull-right">
					<tr>
						<td><select class="form-control" name="searchSelect">
								<option value="title">제목</option>
								<option value="content">내용</option>
								<option value="writer">작성자</option>
						</select></td>
						<td><input type="text" class="form-control"
							placeholder="검색어 입력" name="searchText" maxlength="100"></td>
						<td><button type="submit" class="btn btn-success">검색</button></td>
					</tr>
				</table>
			</form>
		</div>
	</div>

	<div class="container">
		<div class="row">
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
					BoardDAO boardDAO = new BoardDAO();
					ArrayList<Board> list = boardDAO.getList(pageNumber);
					for (int i = 0; i < list.size(); i++) {
					%>
					<tr>
						<td><%=list.get(i).getBoard_id()%></td>

						<%
						if (list.get(i).isSecret()) {
						%>
						<td><a
							href="secretCheck.jsp?board_id=<%=list.get(i).getBoard_id()%>">비밀글
								입니다.</a></td>
						<%
						} else {
						%>
						<td><a
							href="view.jsp?board_id=<%=list.get(i).getBoard_id()%>"><%=list.get(i).getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;")
		.replaceAll("\n", "<br>")%></a></td>
						<%
						}
						%>
						<td><%=list.get(i).getWriter()%></td>
						<td><%=list.get(i).getRegdate().substring(0, 11) + list.get(i).getRegdate().substring(11, 13) + "시"
		+ list.get(i).getRegdate().substring(14, 16) + "분"%></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			<%
			if (pageNumber != 1) {
			%>
			<a href="board.jsp?pageNumber=<%=pageNumber - 1%>&commentNumber=1"
				class="btn btn-success btn-arraw-left">이전</a>
			<%
			// 				} if(boardDAO.nextPage(pageNumber+1)){
			}
			if (Math.ceil(boardDAO.countData() / 10) >= pageNumber) {
			%>
			<a href="board.jsp?pageNumber=<%=pageNumber + 1%>&commentNumber=1"
				class="btn btn-success btn-arraw-right">다음</a>
			<%
			}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>

	</div>

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>