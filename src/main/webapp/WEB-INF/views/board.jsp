<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginInOut" value="${empty loginId ? 'Login' : 'Logout'}"/>
<c:set var="loginInOutLink" value="${empty loginId ? '/login/login' : '/login/logout'}"/>
<c:set var="field" value="${{'A' : 'All', 'IT' : 'IT', 'FN' : 'Finance'}}"/>
<c:set var="spec" value="${{'A' : 'All', 'WD' : 'Web Development', 'SD' : 'Software Development', 'FA': 'Financial Analysis', 'RM' : 'Risk Management'}}"/>
<c:set var="selectedField" value="${boardDto.field}"/>
<c:set var="selectedSpec" value="${boardDto.specialization}"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Board</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/water.css@2/out/water.css">
</head>
<body>
<div>
    <ul>
        <li><a href="<c:url value='/'/>">Logo</a></li>
        <li><a href="<c:url value='/'/>">Home</a></li>
        <li><a href="">About</a></li>
        <li><a href="<c:url value='/board/list'/>">Team Building</a></li>
        <li><a href="<c:url value='/team/list'/>">Team Management</a></li>
        <li><a href="<c:url value='${loginInOutLink}'/>"><c:out value="${loginInOut}"/></a></li>
        ${loginId}
    </ul>
</div>
<div>
    <form action="" id="form">
        <input type="text" name="writer" value="<c:out value='${boardDto.writer}'/>" readonly>
        <select name="field">
            <c:forEach var="i" items="${field}">
                <option value="${i.key}" ${i.key == selectedField ? 'selected' : ''}>${i.value}</option>
            </c:forEach>
        </select>
        <select name="specialization">
            <c:forEach var="i" items="${spec}">
                <option value="${i.key}" ${i.key == selectedSpec ? 'selected' : ''}>${i.value}</option>
            </c:forEach>
        </select>
        <input type="text" name="bno" value="<c:out value='${boardDto.bno}'/>" readonly>
        <input type="text" name="title" value="<c:out value='${boardDto.title}'/>" readonly>
        <textarea name="content" cols="30" rows="10" readonly><c:out value="${boardDto.content}"/></textarea>
        <button type="button" id="boardWrtBtn" class="btn">Write</button>
        <c:if test="${loginId eq boardDto.writer}">
        <button type="button" id="boardModBtn" class="btn">Modify</button>
        <button type="button" id="boardRemBtn" class="btn">Remove</button>
        </c:if>
        <button type="button" id="boardListBtn" class="btn">List</button>
    </form>
</div>
<button type="button" id="inviteBtn" class="btn">Invite</button>
<div id="teams"></div>
<br>
<br>
<div id="commentFunction">
    comment: <input type="text" name="comment">
    <button type="button" id="commentWrtBtn">Write</button>
    <button type="button" id="commentUpdBtn">Modify</button>
    <div id="commentList"></div>
    <div id="replyComment" style="display: none">
        <input type="text" name="replyComment">
        <button type="button" id="commentWrtRepBtn">Write</button>
    </div>
</div>
</body>
<script>
    $(document).ready(function() {
        let msg = "${msg}";
        let mode = "${mode}";

        let bno = $("input[name=bno]").val();
        let title = $("input[name=title]");
        let content = $("textarea[name=content]");
        let boardWrtBtn = $("#boardWrtBtn");
        let boardModBtn = $("#boardModBtn");
        let boardRemBtn = $("#boardRemBtn");
        let boardListBtn = $("#boardListBtn");
        let commentList = $("#commentList");

        displayMsg(msg);
        displayCommentList(bno);

        if(mode === "WRT_BOARD") {
            title.attr("readonly", false);
            content.attr("readonly", false);

            $("#commentFunction").css("display", "none");
        }

        if(mode === "READ_BOARD") {
            boardWrtBtn.hide();
        }

        boardWrtBtn.on("click", function() {
            if (!isBoardEmpty()) return;
            let form = $("#form");

            form.attr("action", "<c:url value='/board/write'/>");
            form.attr("method", "post");
            form.submit();
        });

        boardModBtn.on("click", function() {
            let form = $("#form");

            if(title.attr("readonly") && content.attr("readonly")) {
                title.attr("readonly", false);
                content.attr("readonly", false);
                boardModBtn.html("Write");
                boardRemBtn.hide();
                return;
            }

            form.attr("action", "<c:url value='/board/modify${boardListCondition.queryString}'/>");
            form.attr("method", "post");
            form.submit();
        });

        boardRemBtn.on("click", function() {
            if(!confirm("Would you like to delete the board?")) return;
            let form = $("#form");

            form.attr("action", "<c:url value='/board/remove${boardListCondition.queryString}'/>");
            form.attr("method", "post");
            form.submit();
        });

        boardListBtn.on("click", function() {
            location.href = "<c:url value='/board/list${boardListCondition.queryString}'/>";
        });

        commentList.on("click", "#commentModBtn", function() {
            let cno = $(this).parent().attr("data-cno");
            let comment = $("span.comment", $(this).parent()).text();

            $("input[name=comment]").val(comment);
            $("#commentUpdBtn").attr("data-cno", cno);
        });

        commentList.on("click", "#commentRemBtn", function() {
            let cno = $(this).parent().attr("data-cno");
            let bno = $(this).parent().attr("data-bno");

            $.ajax({
                type: "DELETE",
                url: "/collaborateam/comments/"+cno+"?bno="+bno,
                success: function(result){
                    alert(result);
                    displayCommentList(bno)
                },
                error: function(jqXHR) {
                    alert(jqXHR.responseText);
                }
            });
        });

        commentList.on("click", "#commentRepBtn", function() {
            $("#replyComment").appendTo($(this).parent());
            $("#replyComment").css("display", "block");
        });

        $("#commentWrtRepBtn").on("click", function() {
            let comment = $("input[name=replyComment]").val();
            let pcno = $("#replyComment").parent().attr("data-pcno");

            if(comment.trim()==="") {
                alert("Write the comment");
                $("input[name=replyComment]").focus();
                return;
            }

            $.ajax({
                type: "POST",
                url: "/collaborateam/comments?bno="+bno,
                headers: {"content-type": "application/json"},
                data: JSON.stringify({pcno: pcno, bno: bno, comment: comment}),
                success: function(result){
                    alert(result)
                    displayCommentList(bno)
                },
                error: function(jqXHR) {
                    alert(jqXHR.responseText);
                }
            });

            $("#replyComment").css("display", "none");
            $("input[name=replyComment]").val("");
            $("#replyComment").appendTo("body");
        });

        $("#commentWrtBtn").on("click", function() {
            let comment = $("input[name=comment]").val();

            if(comment.trim()==="") {
                alert("Write the comment");
                $("input[name=comment]").focus();
                return;
            }

            $.ajax({
                type: "POST",
                url: "/collaborateam/comments?bno="+bno,
                headers: {"content-type": "application/json"},
                data: JSON.stringify({bno: bno, comment: comment}),
                success: function(result){
                    alert(result)
                    displayCommentList(bno)
                },
                error: function(jqXHR) {
                    alert(jqXHR.responseText);
                }
            });

            $("input[name=comment]").val("");
        });

        $("#commentUpdBtn").on("click", function() {
            let cno = $(this).attr("data-cno");
            let comment = $("input[name=comment]").val();

            if(comment.trim()==="") {
                alert("Write the comment");
                $("input[name=comment]").focus();
                return;
            }

            $.ajax({
                type: "PATCH",
                url: "/collaborateam/comments/"+cno,
                headers: {"content-type": "application/json"},
                data: JSON.stringify({cno: cno, comment: comment}),
                success: function(result){
                    alert(result)
                    displayCommentList(bno)
                },
                error: function(jqXHR) {
                    alert(jqXHR.responseText);
                }
            });
        });

        $("#inviteBtn").on("click", function() {
            let leader = "${loginId}";

            $.ajax({
                type: "GET",
                url: "/collaborateam/team/teams?leader="+leader,
                success: function(result){
                    $("#teams").html(formatTeam(result))
                },
                error: function(jqXHR) {
                    alert(jqXHR.responseText);
                }
            });
        });
    });

    function displayMsg(msg) {
        if(msg === "BOARD_WRT_ERR") alert("Failed to create the board");
        if(msg === "BOARD_DEL_ERR") alert("Failed to delete the board");
        if(msg === "BOARD_MOD_ERR") alert("Failed to modify the board");
    }

    function isBoardEmpty() {
        const title = $("input[name=title]").val().trim();
        const content = $("textarea[name=content]").val().trim();

        if (title === "" || content === "") {
            alert("Title and content are empty");
            return false;
        }
        return true;
    }

    function displayCommentList(bno) {
        $.ajax({
            type: "GET",
            url: "/collaborateam/comments?bno="+bno,
            success : function(result){
                $("#commentList").html(formatComment(result));
            },
            error : function(){ alert("Failed to load the comment list")}
        });
    }

    function formatTeam(teams) {
        let tmp = "";

        teams.forEach(function(team) {
            tmp += "<ul>"
            tmp += "<li data-tno=" + team.tno + ">"
            tmp += " team : <span class='team'>" + team.name + "</span>"
            tmp += "</li>"
            tmp += "</ul>"
        })
        tmp += "<button type='button' id='teamSelectBtn' class='btn'>Confirm</button>"
        return tmp
    }

    $("#teams").on("click", "li", function() {
        $(this).addClass("selected");
        alert($(this).data("tno"));
    });

    $("#teams").on("click", "#teamSelectBtn", function () {
        let writer= "${boardDto.writer}";
        let tno = $("#teams li.selected").data("tno");

        $.ajax({
            type: "POST",
            url: "/collaborateam/members",
            contentType: "application/json",
            data: JSON.stringify({ tno: tno, id: writer, role: "M" }),
            success: function(result){
                alert(result)
            },
            error: function(jqXHR) {
                alert(jqXHR.responseText);
            }
        });
    })

    function formatComment(comments) {
        let tmp = "<ul>";
        let user = "${loginId}";

        comments.forEach(function(comment) {
            tmp += "<li data-cno=" + comment.cno
            tmp += " data-pcno=" + comment.pcno
            tmp += " data-bno=" + comment.bno + ">"

            if(comment.cno !== comment.pcno)
                tmp += '->';

            tmp += " comment=<span class='comment'>" + comment.comment + "</span>"
            tmp += " commenter=<span class='commenter'>" + comment.commenter + "</span>"
            tmp += " up_date=" + comment.up_date

            if(user === comment.commenter) {
                tmp += " <button id='commentRemBtn'>Remove</button>"
                tmp += " <button id='commentModBtn'>Modify</button>"
            }

            tmp += " <button id='commentRepBtn'>Reply</button>"
            tmp += "</li>"
        })
        return tmp + "</ul>"
    }
</script>
</html>