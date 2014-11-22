package RailwayReservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.Calendar;

public class trainDetail extends HttpServlet {

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
        try{
            String trainNo = request.getParameter("train");
            Date doj = Date.valueOf(request.getParameter("doj"));
            String source = request.getParameter("source");
            String destination = request.getParameter("destination");

            PrintWriter writer = response.getWriter();

            Calendar c = Calendar.getInstance();
            c.setTime(doj);

            String sql = "select MIN(seats) as val from availability where train = ? and travel_date = ? and station in (select station from route where train = ? and stopnum <= (select stopnum from route where station = ? and train = ?) and stopnum > (select stopnum from route where station = ? and train = ?))";

            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setInt(1, Integer.parseInt(trainNo));
            preparedStatement.setInt(3, Integer.parseInt(trainNo));
            preparedStatement.setInt(5, Integer.parseInt(trainNo));
            preparedStatement.setInt(7, Integer.parseInt(trainNo));
            preparedStatement.setString(4,destination);
            preparedStatement.setString(6,source);

            for (int i = 0; i < 7; i++) {

                Date ndate = new Date(c.getTimeInMillis());

                preparedStatement.setDate(2, ndate);

                ResultSet resultSet = preparedStatement.executeQuery();
                if(resultSet.next()) {
                    int val = resultSet.getInt("val");

                    writer.print("<tr>");

                    writer.print("<td>");
                    writer.print(ndate);
                    writer.print("</td>");

                    writer.print("<td>");
                    writer.print(val);
                    writer.print("</td>");

                    writer.print("<td>");
                    if (val > 0)
                        writer.print("<a onclick='book(\""+source+"\",\""+destination+"\",\""+ndate+"\",\""+trainNo+"\")'>Book</a>");
                    else
                        writer.print("Full");
                    writer.print("</td>");

                    writer.print("</tr>");
                }else  {
                    System.out.println("Incorrect resultSet result... May be wrong data received");
                    return;
                }
                c.add(Calendar.DATE, 1);
            }

        } catch (Exception e) {
            System.out.println("Error: Something failed in the train detail dialog");
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
