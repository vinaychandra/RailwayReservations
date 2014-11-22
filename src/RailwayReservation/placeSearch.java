package RailwayReservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * Created by vinaychandra on 22/11/14.
 */
public class placeSearch extends HttpServlet {

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
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String q = request.getParameter("q");
        String sql = "SELECT * FROM station WHERE position(lower(?) in lower(name))>0 or position(lower(?) in lower(id))>0";
        try {
            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setString(1, q);
            preparedStatement.setString(2, q);
            ResultSet resultSet = preparedStatement.executeQuery();

            PrintWriter writer = response.getWriter();

            while(resultSet.next()) {
                writer.println("<tr><td>"+resultSet.getString("name")+"("+resultSet.getString("id")+")</td></tr>");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
