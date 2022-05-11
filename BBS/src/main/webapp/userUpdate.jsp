<%@page import="session.SessionDAO"%>
<%@page import="member.Member"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
<%! Member result; %>
	<%
		String memberID = null;
		int session_index = 0;
		if(session.getAttribute("memberID")!=null){
			memberID = (String) session.getAttribute("memberID");
			session_index = (int)session.getAttribute("session_index");
			
			MemberDAO memDAO = new MemberDAO();
			result = memDAO.getMember(memberID);
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
			script.println("alert('로그인 해주세요.')");
			script.println("location.href = 'login.jsp'");
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
				<li class = "active"><a href="main.jsp">메인</a></li>
				<li><a href="board.jsp">게시판</a></li>
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
						<li><a href="userCheck.jsp">회원정보수정</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
			
		</div>
		
		<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="userUpdateAction.jsp">
					<h3 style="text-align: center;">회원정보 수정</h3>
					<div class="form-group">
						<input type="text" class="form-control" value="<%=result.getId()%>" name="id" readonly="readonly">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="pw" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="이름" name="name" value="<%=result.getName()%>" maxlength="20">
					</div>
					<div class="form-group" style="text-align: center;">
						<div class="btn-group">
							<label class="btn btn-primary active">
								<input type="radio" name="gender" autocomplete="off" value="남자" checked>남자
							</label>
							<label class="btn btn-primary">
								<input type="radio" name="gender" autocomplete="off" value="여자">여자
							</label>
						</div>
					</div>
					<div class="form-group">
						<input type="email" class="form-control" placeholder="이메일" name="email" value="<%=result.getEmail()%>" maxlength="20">
					</div>
					<input type="submit" class="btn btn-primary form-control" value="수정완료">
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>
	
	<div class="container" style="text-align:center">
		<a onclick="return confirm('정말로 탈퇴하시겠습니까?')" href="userDeleteAction.jsp?userID=<%=memberID%>">회원탈퇴</a>		
	</div>
	</nav>
</body>
</html>