<%--
  Created by IntelliJ IDEA.
  User: vinaychandra
  Date: 16/11/14
  Time: 3:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<HTML>
<head>
  <link rel="stylesheet" href="css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body>

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
      <a class="navbar-brand" href="availability.jsp">Railway Reservation</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li class=""><a href="#">Availability</a></li>
        <li><a href="history.jsp">History</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a class="btn" data-toggle="modal" data-target="#loginModal">Login</a></li>
        <li><a class="btn" data-toggle="modal" data-target="#signupModal">Signup</a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>

<!-- Modal -->
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="ModalLabel1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">&times;</span>
          <span class="sr-only">Close</span>
        </button>
        <h4 class="modal-title" id="ModalLabel1">Login</h4>
      </div>
      <div class="modal-body">
        <form role="form">
          <div class="form-group" id="l1">
            <label for="loginEmail">Username</label>
            <input type="email" class="form-control" id="loginEmail" placeholder="Enter username">
          </div>
          <div class="form-group" id="l2">
            <label for="loginPassword">Password</label>
            <input type="password" class="form-control" id="loginPassword" placeholder="Password">
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button onclick="login()" type="button" class="btn btn-primary">Submit</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="signupModal" tabindex="-1" role="dialog" aria-labelledby="ModalLabel2" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">&times;</span>
          <span class="sr-only">Close</span>
        </button>
        <h4 class="modal-title" id="ModalLabel2">Signup</h4>
      </div>
      <div class="modal-body">
        <form role="form">
          <div class="form-group">
            <label for="signupName">Name</label>
            <input type="email" class="form-control" id="signupName" placeholder="Enter your Name">
          </div>
          <div class="form-group">
            <label for="signupUsername">Username</label>
            <input type="email" class="form-control" id="signupUsername" placeholder="Enter username">
          </div>
          <div class="form-group" id="c1">
            <label for="signupPassword1">Password</label>
            <input type="password" class="form-control" id="signupPassword1" placeholder="Password">
          </div>
          <div class="form-group" id="c2">
            <label for="signupPassword2">Re-enter Password</label>
            <input type="password" class="form-control" id="signupPassword2" placeholder="Password">
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" id="signupbtn" class="btn btn-primary">Submit</button>
      </div>
    </div>
  </div>
</div>

<div class="page-header" style="text-align: center;"><h1>Railway Reservation Site <small>CS 387</small></h1></div>
<div style="text-align: center;"><h3>Vinay Chandra Dommeti</h3></div>
<div style="text-align: center;"><h3>Harish Koilada</h3></div>
<div style="text-align: center;"><h3>Nikhil Sri Ram Dodda</h3></div>
</body>
<script src="js/jquery-2.1.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>

<script>
  function login(){
    $.post("login",{
      email: $("#loginEmail").val(),
      pass: $("#loginPassword").val()
    }, function(data){
      console.log(data);
      data = jQuery.parseJSON(data);
      if(data['redirect']) {
        console.log("Redirecting to "+data['redirect']);
        window.location.replace(data['redirect']);
      } else if(data['error']){
        console.log(data['error']);
        $("#l1").addClass("has-error");
        $("#l2").addClass("has-error");
      } else console.log("Unknown error");
    });
  }

  $("#signupbtn").click(function() {
    var sp1 = $("#signupPassword1");
    if(sp1.val() != $("#signupPassword2").val()) {
      $("#c1").addClass("has-error");
      $("#c2").addClass("has-error");
    }
    else {
      $.post("signup",
              {
                name: $("#signupName").val(),
                uname: $("#signupUsername").val(),
                pwd: sp1.val()
              },
              function (data) {
                window.location.href = data;
              })
    }
  })
</script>
</HTML>