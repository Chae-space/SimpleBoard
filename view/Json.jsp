<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

{"reply_num":${b.reply_num}, "board_num":${b.board_num}, "writer_id":"${b.writer_id}", "reply_content":"${b.reply_content}", "reply_date":"${b.reply_date}", "parent_reply_num":${b.parent_reply_num},"child_reply":[<c:forEach var="bb" items="${b.child_reply}" varStatus="bb_state"><c:if test="${not bb_state.first}">,</c:if>{"reply_num":${bb.reply_num}, "board_num":${bb.board_num}, "writer_id":"${bb.writer_id}", "reply_content":"${bb.reply_content}", "reply_date":"${bb.reply_date}", "parent_reply_num":${bb.parent_reply_num}}</c:forEach>]}
