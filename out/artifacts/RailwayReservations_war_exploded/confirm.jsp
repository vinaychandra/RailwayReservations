<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
  <title>Book</title>
  <link rel="stylesheet" href="css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body>
<%
  if (session.getAttribute("isloggedin") == null) {
    String site = "index.jsp";
    response.setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
    response.setHeader("Location", site);
  } else {
%>
<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">Railway Reservation</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li class="active"><a href="availability.jsp">Availability</a></li>
        <li><a href="history.jsp">History</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a class="btn" href="logout"><%= session.getAttribute("name") %>(Logout)</a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>

<div class="container-fluid">
  <form class="form-horizontal" role="form">
    <div class="row">
      <div class="col-md-3 col-md-offset-3">
        <div class="form-group">
          <label class="col-sm-8 control-label">Train Number</label>
          <div class="col-sm-4">
            <p class="form-control-static" id="tno"><%=request.getParameter("tno")%></p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="form-group">
          <label class="col-sm-6 control-label">Train Name</label>
          <div class="col-sm-6">
            <p class="form-control-static" id="tname"><%=request.getParameter("tname")%></p>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-3 col-md-offset-3">
        <div class="form-group">
          <label class="col-sm-8 control-label">From</label>
          <div class="col-sm-4">
            <p class="form-control-static" id="src"><%=request.getParameter("src")%></p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="form-group">
          <label class="col-sm-6 control-label">To</label>
          <div class="col-sm-6">
            <p class="form-control-static" id="dst"><%=request.getParameter("dst")%></p>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-4 col-md-offset-4">
        <div class="form-group">
          <label class="col-sm-3 control-label">Date</label>
          <div class="col-sm-9">
            <p class="form-control-static" id="doj"><%=request.getParameter("doj")%></p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-md-offset-3">
        <table class="table table-bordered">
          <thead>
          <tr>
            <th>Name</th>
            <th>Age</th>
            <th>Gender</th>
          </tr>
          </thead>
          <tbody>
          <% if(!request.getParameter("name1").isEmpty() && !request.getParameter("age1").isEmpty()) {%>
          <tr>
            <td><p class="form-control-static" id="name1"><%=request.getParameter("name1")%></p></td>
            <td><p class="form-control-static" id="age1"><%=request.getParameter("age1")%></p></td>
            <td><p class="form-control-static" id="g1"><%=request.getParameter("g1")%></p></td>
          </tr>
          <%}%>
          <% if(!request.getParameter("name2").isEmpty() && !request.getParameter("age2").isEmpty()) {%>
          <tr>
            <td><p class="form-control-static" id="name2"><%=request.getParameter("name2")%></p></td>
            <td><p class="form-control-static" id="age2"><%=request.getParameter("age2")%></p></td>
            <td><p class="form-control-static" id="g2"><%=request.getParameter("g2")%></p></td>
          </tr>
          <%}%>
          <% if(!request.getParameter("name3").isEmpty() && !request.getParameter("age3").isEmpty()) {%>
          <tr>
            <td><p class="form-control-static" id="name3"><%=request.getParameter("name3")%></p></td>
            <td><p class="form-control-static" id="age3"><%=request.getParameter("age3")%></p></td>
            <td><p class="form-control-static" id="g3"><%=request.getParameter("g3")%></p></td>
          </tr>
          <%}%>
          <% if(!request.getParameter("name4").isEmpty() && !request.getParameter("age4").isEmpty()) {%>
          <tr>
            <td><p class="form-control-static" id="name4"><%=request.getParameter("name4")%></p></td>
            <td><p class="form-control-static" id="age4"><%=request.getParameter("age4")%></p></td>
            <td><p class="form-control-static" id="g4"><%=request.getParameter("g4")%></p></td>
          </tr>
          <%}%>
          <% if(!request.getParameter("name5").isEmpty() && !request.getParameter("age5").isEmpty()) {%>
          <tr>
            <td><p class="form-control-static" id="name5"><%=request.getParameter("name5")%></p></td>
            <td><p class="form-control-static" id="age5"><%=request.getParameter("age5")%></p></td>
            <td><p class="form-control-static" id="g5"><%=request.getParameter("g5")%></p></td>
          </tr>
          <%}%>
          </tbody>
        </table>
      </div>
      <div class="col-md-4 col-md-offset-4">
        <div class="form-group">
          <div class="col-sm-offset-3 col-sm-9">
            <button id="book" type="button" class="btn btn-default">Confirm</button>
          </div>
        </div>
      </div>
    </div>
  </form>
</div>
<%
  }
%>
</body>
<script src="js/jquery-2.1.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>
  /*Helper function*/
  $.extend({
    redirectPost: function(location, args)
    {
      var form = '';
      $.each( args, function( key, value ) {
        form += '<input type="hidden" name="'+key+'" value="'+value+'">';
      });
      $('<form action="' + location + '" method="POST">' + form + '</form>').appendTo($(document.body)).submit();
    }
  });

  $("#book").click(function (){
    var redirect = "bookme";
    $.redirectPost(redirect, {
      src: $("#src").html(),
      dst: $("#dst").html(),
      tno: $("#tno").html(),
      tname: $("#tname").html(),
      doj: $("#doj").html(),
      name1: $("#name1").html(),
      name2: $("#name2").html(),
      name3: $("#name3").html(),
      name4: $("#name4").html(),
      name5: $("#name5").html(),
      age1: $("#age1").html(),
      age2: $("#age2").html(),
      age3: $("#age3").html(),
      age4: $("#age4").html(),
      age5: $("#age5").html(),
      g1: $("#g1").html(),
      g2: $("#g2").html(),
      g3: $("#g3").html(),
      g4: $("#g4").html(),
      g5: $("#g5").html()
    });
  });
</script>
</html>