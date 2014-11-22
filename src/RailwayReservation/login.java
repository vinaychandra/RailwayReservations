package RailwayReservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class login extends HttpServlet {

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
        try {
            String sql = "select * from users where username=? and password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, request.getParameter("email"));
            ps.setString(2, request.getParameter("pass"));
            ResultSet resultSet = ps.executeQuery();

            PrintWriter writer = response.getWriter();

            if(resultSet.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("uname", resultSet.getString("username"));
                session.setAttribute("name", resultSet.getString("name"));
                session.setAttribute("isloggedin", true);
                writer.print("{\"redirect\": \"availability.jsp\"}");
            }
            else {
                writer.print("{\"error\": \"Incorrect email or password\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error !! ");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
