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
	
	
	<title>글작성</title>
	

</head>
<body data-target="#nino-navbar" data-spy="scroll" style="padding-top: 50px;" class="nino-fixed-nav">


 <!-- container Form
    ================================================== -->
<section id="onlineAdd">
		<div class="container">
			<h2 class="nino-sectionHeading">
				<span class="nino-subHeading">SimpleBoard</span>
				 수정
			</h2>
<form class="form-signin" action="${pageContext.request.contextPath}/Board/edit" method="post" enctype="multipart/form-data">
  <input type="hidden" name="num" value="${r.num}">
  
  <fieldset>
  
	 <div class="form-group">
		<c:if test="${not empty file0 }">
			<table style="margin-left: auto; margin-right: auto;">
				<tr>
					<td colspan="3"><img id="bigImg" src="${pageContext.request.contextPath }/img?fname=${file0}&num=${r.num}" style="width: 450px; height: 300px;"></td>
				</tr>
							
				<tr>
					<td><img src="${pageContext.request.contextPath }/img?fname=${file0}&num=${r.num}" class="img" width="150" height="150"></td>
					<td><img src="${pageContext.request.contextPath }/img?fname=${file1}&num=${r.num}" class="img" width="150" height="150"></td>
					<td><img src="${pageContext.request.contextPath }/img?fname=${file2}&num=${r.num}" class="img" width="150" height="150"></td>
				</tr>
			</table>
		</c:if>
	</div>
  
  <div class="form-group">
      <label for="inputName">작성자</label>
      <input type="text" class="form-control" id="writer"  name="writer" value="${sessionScope.nickname }" readonly="readonly">
    </div>
  
    <div class="form-group">
      <label for="inputName">제목</label>
      <input type="text" class="form-control" id="title"  name="title" placeholder="제목을 입력하세요." value="${r.title}">
    </div>
   
    <div class="form-group">
      <label for="input">내용</label>
      <textarea class="form-control" id="content" name="content" rows="10">${r.content}</textarea>
    </div>
 
    <button type="submit" class="nino-btn" style="background: #95e1d3;" name="">저장</button>
     </fieldset>
</form>
</div>
</section>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>  
		
</body>
</html>
