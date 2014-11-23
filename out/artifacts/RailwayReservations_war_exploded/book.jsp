<%@ page import="java.sql.*" %>
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
    String trainNameSql = "Select name from train where train_number=?";
    String dbURL = "jdbc:postgresql://localhost/cs387";
    String user = "vinaychandra";
    String pass = "admin123";
    Connection conn;
    try {
      Class.forName("org.postgresql.Driver");
      conn = DriverManager.getConnection(dbURL, user, pass);
      System.out.println("init"+conn);
    } catch (Exception e) {
      e.printStackTrace();
      return;
    }
    try {
      ResultSet resultSet;
      PreparedStatement preparedStatement = conn.prepareStatement(trainNameSql);
      preparedStatement.setInt(1, Integer.parseInt(request.getParameter("train")));
      resultSet = preparedStatement.executeQuery();
      resultSet.next();
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
            <p class="form-control-static" id="tno"><%=request.getParameter("train")%></p>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="form-group">
          <label class="col-sm-6 control-label">Train Name</label>
          <div class="col-sm-6">
            <p class="form-control-static" id="tname"><%=resultSet.getString("name")%></p>
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
          <tr>
            <td><input type="text" class="form-control" id="name1" placeholder="Name"></td>
            <td><input type="number" min="1" max="150" class="form-control" id="age1" placeholder="Age"></td>
            <td>
              <label for="g1"></label><select id="g1" class="form-control">
                <option value="male">Male</option>
                <option value="female">Female</option>
              </select>
            </td>
          </tr>
          <tr>
            <td><input type="text" class="form-control" id="name2" placeholder="Name"></td>
            <td><input type="number" min="1" max="150" class="form-control" id="age2" placeholder="Age"></td>
            <td>
              <label for="g2"></label><select id="g2" class="form-control">
              <option value="male">Male</option>
              <option value="female">Female</option>
            </select>
            </td>
          </tr>
          <tr>
            <td><input type="text" class="form-control" id="name3" placeholder="Name"></td>
            <td><input type="number" min="1" max="150" class="form-control" id="age3" placeholder="Age"></td>
            <td>
              <label for="g3"></label><select id="g3" class="form-control">
              <option value="male">Male</option>
              <option value="female">Female</option>
            </select>
            </td>
          </tr>
          <tr>
            <td><input type="text" class="form-control" id="name4" placeholder="Name"></td>
            <td><input type="number" min="1" max="150" class="form-control" id="age4" placeholder="Age"></td>
            <td>
              <label for="g4"></label><select id="g4" class="form-control">
              <option value="male">Male</option>
              <option value="female">Female</option>
            </select>
            </td>
          </tr>
          <tr>
            <td><input type="text" class="form-control" id="name5" placeholder="Name"></td>
            <td><input type="number" min="1" max="150" class="form-control" id="age5" placeholder="Age"></td>
            <td>
              <label for="g5"></label><select id="g5" class="form-control">
              <option value="male">Male</option>
              <option value="female">Female</option>
            </select>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
      <div class="col-md-4 col-md-offset-4">
        <div class="form-group">
          <div class="col-sm-offset-3 col-sm-9">
            <button id="book" type="button" class="btn btn-default">Book</button>
          </div>
        </div>
      </div>
    </div>
  </form>
</div>
<%
    } catch (SQLException e) {
      e.printStackTrace();
    }
    try{
      conn.close();
      System.out.println("close");
    }catch (Exception e)
    {
      e.printStackTrace();
    }
  }
%>

<div class="modal fade" id="error-modal">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">Error</h4>
      </div>
      <div class="modal-body" id="errVal">

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

</body>
<script src="js/jquery-2.1.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>

  function error(msg)
  {
    $("#error-modal").modal('toggle');
    $("#errVal").html(msg);
  }

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

  $("[type='number']").keypress(function (key) {
    if(key.charCode < 48 || key.charCode > 57) return false;
  });

  $("#book").click(function (){
    var age1 = parseInt($("#age1").val()), age2 = parseInt($("#age2").val()),
            age3 = parseInt($("#age3").val()), age4 = parseInt($("#age4").val()),
            age5 = parseInt($("#age5").val());
    age1 = (isNaN(age1)) ? -1 : age1;
    age2 = (isNaN(age2)) ? -1 : age2;
    age3 = (isNaN(age3)) ? -1 : age3;
    age4 = (isNaN(age4)) ? -1 : age4;
    age5 = (isNaN(age5)) ? -1 : age5;
    var name1 = $("#name1").val().trim();
    var name2 = $("#name2").val().trim();
    var name3 = $("#name3").val().trim();
    var name4 = $("#name4").val().trim();
    var name5 = $("#name5").val().trim();

    var errorMsg, err;
    var agebool, namebool;

    namebool = (age2 == -1) && (name2.length == 0) && (age3 == -1) && (name3.length == 0) &&
    (age4 == -1) && (name4.length == 0) && (age5 == -1) && (name5.length == 0);
    if(!namebool && (name1.length == 0 || age1 == -1)){
      err = true;
      errorMsg = "Fill passengers in order";
    }
    else if(name1.length == 0){
      err = true;
      errorMsg = "The first passenger's name is empty";
    }
    else if(age1 == -1) {
      err = true;
      errorMsg = "The first passenger's age is empty";
    }
    else if(age1 < 1 || age1 >= 100){
      err = true;
      errorMsg = "The first passenger's age is not between 1 to 100";
    }
    agebool = !(age1 == -1) && !(name1.length == 0);
    namebool = (age3 == -1) && (name3.length == 0) && (age4 == -1) && (name4.length == 0) &&
    (age5 == -1) && (name5.length == 0);
    if(agebool && !err){
      if(!namebool && (name2.length == 0 || age2 == -1)){
        err = true;
        errorMsg = "Fill passengers in order";
      }
      else if(name2.length==0 && !(age2==-1)){
        err = true;
        errorMsg = "The second passenger's name is empty";
      }
      else if(age2==-1 && !(name2.length==0)){
        err = true;
        errorMsg = "The second passenger's age is empty";
      }
      else if(age2 != -1 && (age2 < 1 || age2 >= 100)){
        err = true;
        errorMsg = "The second passenger's age is not between 1 to 100";
      }
    }
    agebool = agebool && !(age2 == -1) && !(name2.length == 0);
    namebool = (age4 == -1) && (name4.length == 0) && (age5 == -1) && (name5.length == 0);
    if(agebool && !err){
      if(!namebool && (name3.length == 0 || age3 == -1)){
        err = true;
        errorMsg = "Fill passengers in order";
      }
      else if(name3.length==0 && !(age3==-1)){
        err = true;
        errorMsg = "The third passenger's name is empty";
      }
      else if(age3==-1 && !(name3.length==0)){
        err = true;
        errorMsg = "The third passenger's age is empty";
      }
      else if(age3 != -1 && (age3 < 1 || age3 >= 100)){
        err = true;
        errorMsg = "The third passenger's age is not between 1 to 100";
      }
    }
    agebool = agebool && !(age3 == -1) && !(name3.length == 0);
    namebool = (age5 == -1) && (name5.length == 0);
    if(agebool && !err){
      if(!namebool && (name4.length == 0 || age4 == -1)){
        err = true;
        errorMsg = "Fill passengers in order";
      }
      else if(name4.length==0 && !(age4==-1)){
        err = true;
        errorMsg = "The fourth passenger's name is empty";
      }
      else if(age4==-1 && !(name4.length==0)){
        err = true;
        errorMsg = "The fourth passenger's age is empty";
      }
      else if(age4 != -1 && (age4 < 1 || age4 >= 100)){
        err = true;
        errorMsg = "The fourth passenger's age is not between 1 to 100";
      }
    }
    agebool = agebool && !(age4 == -1) && !(name4.length == 0);
    if(agebool && !err){
      if(name5.length==0 && !(age5==-1)){
        err = true;
        errorMsg = "The fifth passenger's name is empty";
      }
      else if(age5==-1 && !(name5.length==0)){
        err = true;
        errorMsg = "The fifth passenger's age is empty";
      }
      else if(age5 != -1 && (age5 < 1 || age5 >= 100)){
        err = true;
        errorMsg = "The fifth passenger's age is not between 1 to 100";
      }
    }

    if(!err) {
      var redirect = "confirm.jsp";
      $.redirectPost(redirect, {
        src: $("#src").html(),
        dst: $("#dst").html(),
        tno: $("#tno").html(),
        tname: $("#tname").html(),
        doj: $("#doj").html(),
        name1: $("#name1").val(),
        name2: $("#name2").val(),
        name3: $("#name3").val(),
        name4: $("#name4").val(),
        name5: $("#name5").val(),
        age1: $("#age1").val(),
        age2: $("#age2").val(),
        age3: $("#age3").val(),
        age4: $("#age4").val(),
        age5: $("#age5").val(),
        g1: $("#g1").val(),
        g2: $("#g2").val(),
        g3: $("#g3").val(),
        g4: $("#g4").val(),
        g5: $("#g5").val()
      });
    }
    else{
      /*if(name1.length == 0 && name2.length == 0 && name3.length == 0 && name4.length == 0 && name5.length== 0){
        error("Passenger Name should not be empty");
      }
      else error("Age must be between 1 and 150");*/
      error(errorMsg);
    }
  });
</script>
</html>