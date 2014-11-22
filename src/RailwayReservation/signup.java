package RailwayReservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class signup extends HttpServlet {

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
        String name = request.getParameter("name");
        String uname = request.getParameter("uname");
        String pwd = request.getParameter("pwd");

        String sql = "Insert into users VALUES (?,?,?)";
        try {
            PreparedStatement preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setString(1,uname);
            preparedStatement.setString(2,name);
            preparedStatement.setString(3,pwd);
            preparedStatement.execute();
            response.getWriter().print("index.jsp");
        } catch (SQLException e) {
            response.getWriter().print("ucfailed.html");
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("availability.jsp");
    }
}
