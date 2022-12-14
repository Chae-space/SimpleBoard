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
	<title>게시판 자세히 보기</title>
	
	<style>
	.li_reply{
		border-bottom: 1px solid; 
		border-color: #C0C0C0; 
		padding: 15px; 
		margin: 5px 40px 5px;
	}
	.li_childReply{
		border-bottom: 1px solid; 
		border-color: #C0C0C0; 
		padding: 15px; 
		margin: 5px 40px 5px;
		margin-left: 150px;
	}
	</style>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script>
		var member_id="${sessionScope.id}";
		var member_type = "${sessionScope.type}";
		var board_num = ${r.num};
		var str= "";
		
			 $(document).ready(function () {
				// 글의 이미지 관련 스크립트
				$(".img").mouseover(function () {
					$("#bigImg").attr("src",this.src);
				});
				
			// 댓글 입력(비동기)
				$(document).on("click","#btn_addReply",function(){
					if (member_id == "" || member_id == null) {
						var flag = confirm("로그인이 필요합니다. 로그인하시겠습니까?");
						if (flag) {
							fn_loginPopup();
						} else {
							return false;
						}
					} else if($("#reply_content").val()=="" || $("#reply_content").val()==null) {
						alert("댓글 내용을 입력해주세요.");
						$("#reply_content").focus();
						return false;
					} else {
						$.post("/boardReply/add",{
							board_num:board_num,
							writer_id:member_id,
							parent_reply_num:-1,
							reply_content:$("#reply_content").val()
						}).done(function(data){
							alert("댓글이 등록되었습니다!");
							$("#reply_content").val("");
							var reply = $.parseJSON(data);
							var html = makeTbl(reply);
							 $("#reply_list").append(html);
						});
					}
					
				});
				
		
				// 댓글 전체 리스트 불러오기 (비동기)
				getAllReply();
				
				// 댓글 버튼 누르면 대댓글 작성폼이 나온다.
				$(document).on("click","button[type='btn_rr']",function(){
					var num = $(this).attr("num");
					toggleReply(num);
				});
						
				$(document).on("click","button[type='editReplyForm']",function(){
					var num = $(this).attr("num");
					var flag = confirm("수정하시겠습니까?");
					if(flag) {
						$.post("/boardReply/get",{
							reply_num:num
						}).done(function(data){
							var r = $.parseJSON(data);
							var id = "editReply";
							var name = "li_reply_";
							
							if (r.parent_reply_num != -1){
								// 자식 댓글인 경우
								id = "editReply2";
								name = "li_childReply_";
							}
							makeEditForm(id,name,r);
								
						});
						
					} else {
						return false;
					}
					
				});
				
				$(document).on("click","button[name='btn_editReply']",function(){
					var reply_num = $(this).attr("num");
					var type = $(this).attr("type");
					var txt = $("#edit_content_"+reply_num).val();
					if(txt=="") {
						alert("댓글 내용을 입력해주세요.");
						$("#edit_content_"+reply_num).focus();
						return false;
					} else {
						$.post("/boardReply/edit",{
							board_num:board_num,
							writer_id:member_id,
							reply_num:reply_num,
							reply_content:txt
						}).done(function(data){
							var reply = $.parseJSON(data);
							var html = "";
							if (type == "editReply"){
								html = makeReply(reply);
							} else {
								html = makeChildReply(reply);
							}
							$("#edit_r_reply-"+reply_num).replaceWith(html);
							alert("댓글이 수정되었습니다!");
							 
						});
					}
				});		
				
				$(document).on("click","button[type='deleteReply']",function(){
					var num = $(this).attr("num");
					var flag = confirm("삭제하시겠습니까?");
					if(flag) {
						$.post("/boardReply/delete",{
							reply_num:num
						}).done(function(data){
							var r = $.parseJSON(data);
							if (r.parent_reply_num == -1){
								 $("#ul_reply_"+num).remove();
								 
							} else {
								$("#li_childReply_"+num).remove();
								
							}
						});
					} else {
						return false;
					}
					
				});
				
				$(document).on("click","button[type='addReply2']",function(){
					var parent_reply_num = $(this).attr("num");
					var txt = $("#childReply_content_"+parent_reply_num).val();
					if (member_id == "" || member_id == null) {
						var flag = confirm("로그인이 필요합니다. 로그인하시겠습니까?");
						if (flag) {
							fn_loginPopup();
						} else {
							return false;
						}
					} else if(txt=="") {
						alert("댓글 내용을 입력해주세요.");
						$("#childReply_content_"+parent_reply_num).focus();
						return false;
					} else {
						$.post("/boardReply/add",{
							board_num:board_num,
							writer_id:member_id,
							parent_reply_num:parent_reply_num,
							reply_content:txt
						}).done(function(data){
							alert("댓글이 등록되었습니다!");
							$("#childReply_content_"+parent_reply_num).val("");
							var reply = $.parseJSON(data);
							var html = makeChildReply(reply);
							$(`#input_r_reply-${"${parent_reply_num}"}`).slideToggle();
							 $("#childReply_list_"+parent_reply_num).append(html);
						});
					}
				});
				
			});
			
			 var makeTbl = function(reply){
				// 댓글 리스트 + 대댓글, 수정, 삭제 버튼
				str = "<ul id='ul_reply_"+reply.reply_num+"'>";
				str += makeRL(reply);
				str += "</ul>";
				return str;
			 }
			
			 function makeRL (reply) {
				 str = makeReply(reply);
				
				// 대댓글 작성폼
				str += "<div id='input_r_reply-"+reply.reply_num+"' style='display:none;'><textarea id ='childReply_content_"+reply.reply_num+"' name='reply_content' class='form-control' rows='3' placeholder='댓글을 입력하세요.'>";
				str += "</textarea><button id='btn_addChildReply' type='addReply2' num='"+reply.reply_num+"' class='btn btn-danger btn-block'>댓글 등록</button></div><div id='childReply_list_"+reply.reply_num+"'>";
			
				// 대댓글 리스트 + 수정, 삭제 버튼
				if (reply.child_reply !="undefined" && reply.child_reply !=null){
					for (i=0;i<reply.child_reply.length;i++){
						str += makeChildReply(reply.child_reply[i]);
					}
				}
				str += "</div>";
				 return str;
			 }
			 
			 function makeReply(reply){
				 // 부모 댓글 리스트 + 대댓글, 수정, 삭제 버튼
				 str = "<li class='li_reply' id='li_reply_"+reply.reply_num+"'><div class='reply-writer'>";
				str += "<span class='regency' style='font-weight: bold;'>ID : " + reply.writer_id + "</span></div>";
				str += "<div class='reply-content' id='reply-"+reply.reply_num+"'>" + reply.reply_content + "</div>";
				str += "<div class='reply_date' align='right' style='padding: 0 1em;'>" + reply.reply_date + "</div>";
				str += "<div class='reply-menu' align='right'>";
				str += "<button type='btn_rr' num='"+reply.reply_num+"' class='btn btn-link btn-sm'>";
				str += "<span class='glyphicon glyphicon-share-alt' aria-hidden='true'></span>댓글";
				str += "</button>";
				
				if (member_id == reply.writer_id || member_type == "2") {
					str += "<button type='editReplyForm' num='"+reply.reply_num+"' class='btn btn-link btn-sm'>";
					str += "<span class='glyphicon glyphicon-erase' aria-hidden='true'></span>수정</button>";
					str += "<button type='deleteReply' num='"+reply.reply_num+"' class='btn btn-link btn-sm'>";
					str += "<span class='glyphicon glyphicon-trash' aria-hidden='true'></span>삭제";
					str += "</button>";
				}
				str += "</div></li>";
				return str;
			 }
			 
			function makeChildReply(reply){
				// 자식 댓글 리스트 + 수정, 삭제 버튼
				str = "<li class='li_childReply' id='li_childReply_"+reply.reply_num+"'><div class='childReply-writer'>";
				str += "<span class='regency' style='font-weight: bold;'>ID : " + reply.writer_id + "</span></div>";
				str += "<div class='childReply-content' id='reply-"+reply.reply_num+"'>" + reply.reply_content + "</div>";
				str += "<div class='childReply_date' align='right' style='padding: 0 1em;'>" + reply.reply_date + "</div>";
				str += "<div class='reply-menu' align='right'>";
				if (member_id == reply.writer_id || member_type == "2"){
					str += "<button type='editReplyForm' num='"+reply.reply_num+"' class='btn btn-link btn-sm'>";
					str += "<span class='glyphicon glyphicon-erase' aria-hidden='true'></span>수정</button>";
					str += "<button type='deleteReply' num='"+reply.reply_num+"' class='btn btn-link btn-sm'>";
					str += "<span class='glyphicon glyphicon-trash' aria-hidden='true'></span>삭제";
					str += "</button>";
				}
				str += "</div></li>";
				return str;
			}
		
			 function getAllReply() {
				 // 전체 댓글 리스트 가져오기
				$.ajax({
					url:"/boardReply/getReplyList",
					data: "board_num="+board_num,
					type:'post',
					success: function(result){
						var arr = $.parseJSON(result);
						makeList(arr);
					}
					
				});
			 }
			 
			var makeList = function(arr){
				// 전체 리스트 작성
				 for (x=0;x<arr.length;x++){
					 var html = makeTbl(arr[x]);
					 $("#reply_list").append(html);
				 }
			 }
			
			function makeEditForm(id,name,r){
				// 수정 폼 만드는 함수
				str = "<div id='edit_r_reply-"+r.reply_num+"' ><textarea id ='edit_content_"+r.reply_num+"' name='reply_content' class='form-control' rows='3'>";
				str += r.reply_content+"</textarea>";
				str += "<button name='btn_editReply' type='"+id+"' num='"+r.reply_num+"' class='btn btn-danger btn-block'>댓글 수정</button></div>";
				$("#"+name+r.reply_num).replaceWith(str);
			}
			 
			 function fn_loginPopup(){
				// loginPopup   window.open('팝업주소','팝업창 이름','팝업창 설정');
				var popup=window.open("/Member/loginFormPopup","t로그인",
					"width=460px, height=340px, scrollbars=no, top=100px, left=300px, location=no");
				return false;
			}
		
			 // 대댓글 등록창 (비동기)
			function toggleReply(reply_num) {
				$(`#input_r_reply-${"${reply_num}"}`).slideToggle();
			}

// 수정!			 
			// 게시글 삭제
			/*function deleteBoard() {
				console.log(board_num);
				if(confirm("삭제하시겠습니까?")) {
					location.href="${pageContext.request.contextPath}/Board/delete?num=" + board_num;
					alert("게시글이 삭제되었습니다!");
				}
			} */
//

	function deleteBoard() {
				console.log(board_num);
				Swal.fire({
                    title: '삭제하시겠습니까?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: '삭제',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
					location.href="${pageContext.request.contextPath}/Board/delete?num=" + board_num;
					alert("게시글이 삭제되었습니다!");
				}
            })
			} 

		</script>
	
</head>
<body data-target="#nino-navbar" data-spy="scroll" style="padding-top: 50px;" class="nino-fixed-nav">


 <!-- container Form
    ================================================== -->

		<div class="container">
			<h2 class="nino-sectionHeading">
				<span class="nino-subHeading">SimpleBoard</span>
				게시판
			</h2>
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
	
	<div class="board-menu" align="right">		  
	<c:if test="${sessionScope.nickname==r.w_writer}">
	<a href="${pageContext.request.contextPath}/Board/editBoardForm?num=${r.num}" class="nino-btn" style="background: #95e1d3;">수정</a>
	<a href="#" onclick="deleteBoard();" class="nino-btn" id="delete" num="${r.num}" style="background: #95e1d3;">삭제</a>
	</c:if>
	</div>
					  
  <div class="form-group">
  
      <label for="inputName">작성자</label>
      <input type="text" class="form-control" id="w_writer"  name="w_writer" value="${r.w_writer }" readonly="readonly">
    </div>
  
    <div class="form-group">
      <label for="inputName">제목</label>
      <input type="text" class="form-control" id="title"  name="title" value="${r.title }" readonly="readonly">
    </div>
   
    
    <div class="form-group">
      <label for="inputBreed">내용</label>
      <textarea class="form-control" id="content" name="content" rows="10" readonly="readonly">${r.content }</textarea>
    </div>
    <div class="board-menu" align="right">
    <a href="${pageContext.request.contextPath}/Board/boardList" class="nino-btn" style="background: #95e1d3;">목록</a>
	</div>
     </fieldset>
</div>

		<!-- 댓글리스트 시작 -->
		<div class="container">
			<h2 class="nino-sectionHeading" style="margin-top: 8%;">
				<span class="nino-subHeading">Reply</span> 댓글
			</h2>

			<!-- 댓글 작성란 -->
			<div class="sectionContent">
				<div class="replys" id="reply-add-form" style="border-radius: 35px; padding: 5px 15px; margin: 30px;">

					<!-- 댓글 등록폼 -->
					<div  id="input_reply">
						<span class="regency" style="font-weight: bold; margin: 5px;">ID : ${sessionScope.id}</span>
						<textarea id ="reply_content" name="reply_content" class="form-control" rows="3" placeholder="댓글을 입력하세요."></textarea>
						<button id="btn_addReply" type="button" class="btn btn-danger btn-block">댓글 등록</button>
					</div>
				</div>

				<!-- 댓글목록 -->
				<div id="reply_list"></div>
			</div>
		</div>
		<!-- 댓글리스트 끝-->

	
<%@ include file="/WEB-INF/views/common/footer.jsp" %>  
</body>
</html>
