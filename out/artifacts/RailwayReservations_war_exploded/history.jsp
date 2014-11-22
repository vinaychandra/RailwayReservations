<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>History</title>
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
        <li><a href="availability.jsp">Availability</a></li>
        <li class="active"><a href="history.jsp">History</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a class="btn" href="logout"><%= session.getAttribute("name") %>(Logout)</a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
<div class="col-md-8 col-md-offset-2">
  <table class="table table-bordered table-hover">
  	<thead>
  		<tr>
            <th>PNR</th>
            <th>Train Number</th>
            <th>Date</th>
            <th>Source</th>
            <th>Destination</th>
            <th>Travellers</th>
        </tr>
  	</thead>
  	<tbody>
<%
    String ticketSql = "Select * from ticket WHERE username = ?";
    String travellerSql = "Select count(*) as val from people WHERE ticket = ?";
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
      PreparedStatement preparedStatement = conn.prepareStatement(ticketSql);
      PreparedStatement preparedStatement2 = conn.prepareStatement(travellerSql);
      preparedStatement.setString(1, (String) session.getAttribute("uname"));
      ResultSet resultSet = preparedStatement.executeQuery();
      System.out.println(preparedStatement.toString());

      while(resultSet.next()) {
        int pnr = resultSet.getInt("pnr");
        preparedStatement2.setInt(1,pnr);
        ResultSet resultSet1 = preparedStatement2.executeQuery();
        resultSet1.next();
%>
        <tr>
            <td><a onclick="pnr('<%=pnr%>')"><%=pnr%></a></td>
            <td><%=resultSet.getInt("train")%></td>
            <td><%=resultSet.getDate("date")%></td>
            <td><%=resultSet.getString("source")%></td>
            <td><%=resultSet.getString("destination")%></td>
            <td><%=resultSet1.getInt("val")%></td>
        </tr>
<%
      }
%>
    </tbody>
  </table>
</div>

<div class="modal fade" id="pnrDetails">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="mpnrval">Details of Passengers</h4>
			</div>
			<div class="modal-body">
				<table class="table table-hover">
					<thead>
						<tr>
							<th>Name</th>
							<th>Age</th>
							<th>Gender</th>
						</tr>
					</thead>
					<tbody id="mpnrpass">
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" id="ct" class="btn btn-primary">Cancel Ticket</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->


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
</body>
<script src="js/jquery-2.1.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>
    function pnr(num) {
        $("#pnrDetails").modal('toggle');
        $("#ct").attr("onclick","cancel("+num+")");
        $.post("people", {
            pnr: num
        },
        function(data){
            $("#mpnrpass").html(data);
        });
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

    function cancel(num) {
        var redirect = 'cancel';
        $.redirectPost(redirect, { pnr: num });
    }
</script>
</html>
