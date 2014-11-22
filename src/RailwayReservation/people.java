package RailwayReservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class people extends HttpServlet {

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
        }catch(Exception e)
        {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pnr = request.getParameter("pnr");
        String sql = "SELECT * FROM people WHERE ticket = ?";
        try {
            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setInt(1, Integer.parseInt(pnr));
            ResultSet resultSet = preparedStatement.executeQuery();
            PrintWriter writer = response.getWriter();
            while(resultSet.next()) {
                writer.print("<tr>");
                writer.print("<td>");
                writer.print(resultSet.getString("name"));
                writer.print("</td>");
                writer.print("<td>");
                writer.print(resultSet.getInt("age"));
                writer.print("</td>");
                writer.print("<td>");
                writer.print(resultSet.getString("gender"));
                writer.print("</td>");
                writer.println("</tr>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("availability.jsp");
    }
}
