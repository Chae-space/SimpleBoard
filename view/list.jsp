<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ include file="/WEB-INF/views/common/header.jsp" %>  
	<%@ include file="/WEB-INF/views/common/css_set.jsp" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="ninodezign.com, ninodezign@gmail.com">
	<meta name="copyright" content="ninodezign.com"> 


	<title>리스트</title>

		<script src="http://code.jquery.com/jquery-latest.min.js"></script>
		<script type="text/javascript">
		function LoginCheck(id) {
			if(id == null){
				alert("로그인후 사용 가능합니다.");
				return false;
			}
		}
		</script>
	
</head>
<body data-target="#nino-navbar" data-spy="scroll" style="padding-top: 50px;" class="nino-fixed-nav">

			
	<!-- Footer ================================================== -->
		<div class="container">
		<br><br><br>
		<h2 class="nino-sectionHeading">
				<span class="nino-subHeading">SimpleBoard</span>
			  리스트
		</h2>
		
		<div class="row">
			<table class="table  table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">닉네임</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">날짜</th>
					</tr>
				</thead>
				
				
				<c:if test="${empty list }">
					<tbody>
						<tr>
							<td colspan="4">등록되어 있는 게시물이 없습니다.</td>
						</tr>
					</tbody>				
				</c:if>
				
				<c:if test="${not empty list }">
				<tbody>
					<c:forEach var="board" items="${list}">
						
							<tr>	
								<td>${board.writer }</td>
								<td><a href="${pageContext.request.contextPath}/Board/boardDetail?num=${board.num}">${board.title }</a></td>
								<td>${board.date }</td>
							</tr>
						
					</c:forEach>	
					</tbody>
				</c:if>	
				
				<a href="${pageContext.request.contextPath}/Board/boardForm" class="nino-btn" onclick="return LoginCheck(${sessionScope.id})" style="background: #95e1d3; margin-bottom: 10px;">글쓰기</a>
				<a href="${pageContext.request.contextPath}/Board/myBoardList" class="nino-btn" style="background: #95e1d3;" onclick="return LoginCheck(${id})">내 게시물</a>
			</table>
		</div>
	</div>
			
 
	<%@ include file="/WEB-INF/views/common/footer.jsp" %>  
	
		
</body>
</html>
