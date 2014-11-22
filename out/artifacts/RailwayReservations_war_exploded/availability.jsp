<%--
  Created by IntelliJ IDEA.
  User: vinaychandra
  Date: 16/11/14
  Time: 5:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Availability</title>
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


<!-- The search dialog -->
<div class="container-fluid">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-4 col-md-offset-4">
        <form class="form-horizontal" role="form">
          <div class="form-group">
            <label for="source" class="col-sm-3 control-label">Source</label>
            <div class="col-sm-9">
              <input type="text" class="form-control" id="source" placeholder="Source Station">
            </div>
          </div>
          <div class="form-group">
            <label for="destination" class="col-sm-3 control-label">Destination</label>
            <div class="col-sm-9">
              <input type="text" class="form-control" id="destination" placeholder="Destination Station">
            </div>
          </div>
          <div class="form-group">
            <label for="doj" class="col-sm-3 control-label">Date of Journey</label>
            <div class="col-sm-9">
              <input type="date" class="form-control" id="doj">
            </div>
          </div>
          <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
              <%--<button type="submit" class="btn btn-default">Find Trains</button>--%>
              <input type="button" class="btn btn-default" onclick="searchTrains()" value="Find Trains">
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<div class="container-fluid">
  <div class="row">
    <div class="col-md-8 col-md-offset-2">
      <table class="table table-hover">
        <thead>
        <tr>
          <th>Train Number</th>
          <th>Train Name</th>
          <th>From</th>
          <th>Departure</th>
          <th>To</th>
          <th>Arrival</th>
          <th>Fare</th>
          <th>Availability</th>
        </tr>
        </thead>
        <tbody id="trainTable">
        </tbody>
      </table>
    </div>
  </div>
</div>

<div class="modal fade" id="trainModal" tabindex="-1" role="dialog" aria-labelledby="trainDetail" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
          <span aria-hidden="true">&times;</span>
          <span class="sr-only">Close</span>
        </button>
        <h4 class="modal-title" id="trainDetail"></h4>
      </div>
      <div class="modal-body">
        <table class="table table-striped">
          <thead>
          <tr>
            <th>Date</th>
            <th>Availability</th>
            <th>Book</th>
          </tr>
          </thead>
          <tbody id="trainJourneys">
          </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<%}%>
</body>
<script src="js/jquery-2.1.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>
  /*Code for ajax of train search*/
  function searchTrains()
  {
    $.post("search",
          {
            source: $("#source").val(),
            destination: $("#destination").val(),
            date: $("#doj").val()
          },
          function(data){
            $("#trainTable").html(data);
          });
  }

  /*Function for loading the modal of a dialog of selected train*/
  function view(train,doj,src,dst)
  {
    $("#trainModal").modal('toggle');
    $("#trainJourneys").html("Please Wait");
    console.log(train);
    console.log(doj);
    $.post("detail", 
            {
              train: train,
              source: src,
              destination: dst,
              doj: doj
            },
    function(data){
      $("#trainDetail").html(train + " : "+ src + " to " +dst);
      $("#trainJourneys").html(data);
    });
  }

  /*Function for booking the selected ticket*/
  function book(src, dst, doj, train)
  {
    var redirect = 'book.jsp';
    $.redirectPost(redirect, { src: src, dst: dst, doj: doj, train: train });
  }

  // jquery extend function
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
</script>
</html>
