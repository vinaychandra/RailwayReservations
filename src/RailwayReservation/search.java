package RailwayReservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;


public class search extends HttpServlet {

    Connection conn = null;
    Statement st = null;

    public void init(){
        String dbURL = "jdbc:postgresql://localhost/cs387";
        String user = "vinaychandra";
        String pass = "admin123";

        try {
            Class.forName("org.postgresql.Driver");

            conn = DriverManager.getConnection(dbURL, user, pass);
            st = conn.createStatement();
            System.out.println("init"+conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void destroy(){
        try{
            conn.close();
            System.out.println("close");
        }catch (Exception e)
        {
            e.printStackTrace();
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String source = request.getParameter("source");
            String destination = request.getParameter("destination");
            String doj = request.getParameter("date");

            PrintWriter writer = response.getWriter();

            String sql = "Select src.train as trainno, src.departure as departure, dst.arrival as arrival "+
                    " from route as src join route as dst "+
                    "on src.station=? and dst.station=? and src.train=dst.train and src.stopnum < dst.stopnum";
            String trainNameSql = "Select name from train where train_number=?";
            String fareSql = "Select fare from fareTable where station1 = ? and station2 = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            PreparedStatement ps2 = conn.prepareStatement(trainNameSql);
            PreparedStatement ps3 = conn.prepareStatement(fareSql);
            ps.setString(1, source);
            ps.setString(2, destination);
            ResultSet resultSet = ps.executeQuery();

            if (!resultSet.next() ) {
                System.out.println("no data");
            } else {

                ps3.setString(1, source);
                ps3.setString(2, destination);
                ResultSet rst = ps3.executeQuery();
                rst.next();
                int fare = rst.getInt("fare");

                do {
                    int trainno = resultSet.getInt("trainno");

                    writer.print("<tr>");

                    writer.print("<td>");
                    writer.print(trainno);
                    writer.print("</td>");

                    ps2.setInt(1, trainno);
                    ResultSet resultSet1 = ps2.executeQuery();
                    resultSet1.next();
                    writer.print("<td>");
                    writer.print(resultSet1.getString("name"));
                    writer.print("</td>");

                    writer.print("<td>");
                    writer.print(source);
                    writer.print("</td>");

                    writer.print("<td>");
                    writer.print(resultSet.getString("departure"));
                    writer.print("</td>");

                    writer.print("<td>");
                    writer.print(destination);
                    writer.print("</td>");

                    writer.print("<td>");
                    writer.print(resultSet.getString("arrival"));
                    writer.print("</td>");

                    writer.print("<td>");
                    writer.print(fare);
                    writer.print("</td>");

                    writer.print("<td class='text-center'>");
                    writer.print("<a onclick='view("+trainno+",\""+doj+"\",\""+source+"\",\""+destination+"\")" +
                            "'>view</a>");
                    writer.print("</td>");

                    writer.print("</tr>");
                } while (resultSet.next());
            }
        } catch (SQLException e){
            System.out.println("Getting this means that there might be incomplete data entered into the database");
            e.printStackTrace();
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.jsp");
        /*PrintWriter writer = response.getWriter();
        if(conn == null)
            writer.print("Connection Failed");
        else
            writer.print("working");*/
    }
}
