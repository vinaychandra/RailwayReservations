package RailwayReservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class cancel extends HttpServlet {

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

        try {
            conn.setAutoCommit(false);
            String peopleSql = "DELETE FROM people WHERE ticket = ?";
            String pnrSql = "DELETE FROM ticket WHERE pnr = ?";
            String pnrVals = "SELECT * FROM ticket WHERE pnr = ?";

            PreparedStatement preparedStatement3 = conn.prepareStatement(pnrVals);
            preparedStatement3.setInt(1, Integer.parseInt(pnr));
            ResultSet resultSet = preparedStatement3.executeQuery();
            resultSet.next();
            Date date = resultSet.getDate("date");
            String source = resultSet.getString("source");
            String destination = resultSet.getString("destination");
            int train;
            train = resultSet.getInt("train");
            String username = resultSet.getString("username");

            PreparedStatement preparedStatement = conn.prepareStatement(peopleSql);
            preparedStatement.setInt(1, Integer.parseInt(pnr));
            int i = preparedStatement.executeUpdate();

            PreparedStatement preparedStatement1 = conn.prepareStatement(pnrSql);
            preparedStatement1.setInt(1, Integer.parseInt(pnr));
            int i1 = preparedStatement1.executeUpdate();

            if (i1 != 1) {
                System.out.println("Other than one pnr updated... :(" + i1 + ")");
                return;
            }

            String availUpdate = "UPDATE availability \n" +
                    "SET seats=seats+? \n" +
                    "WHERE train = ? AND \n" +
                    "      travel_date = ? AND \n" +
                    "      station IN \n" +
                    "      (\n" +
                    "        SELECT station \n" +
                    "        FROM route \n" +
                    "        WHERE train = ? AND \n" +
                    "              stopnum <= (SELECT stopnum \n" +
                    "                          FROM route \n" +
                    "                          WHERE station = ? AND \n" +
                    "                                train = ?) AND \n" +
                    "              stopnum > (SELECT stopnum \n" +
                    "                         FROM route \n" +
                    "                         WHERE station = ? AND \n" +
                    "                               train = ?))";

            PreparedStatement preparedStatement2 = conn.prepareStatement(availUpdate);
            preparedStatement2.setInt(1, i);
            preparedStatement2.setInt(2, train);
            preparedStatement2.setDate(3, date);
            preparedStatement2.setInt(4, train);
            preparedStatement2.setString(5, destination);
            preparedStatement2.setInt(6, train);
            preparedStatement2.setString(7, source);
            preparedStatement2.setInt(8, train);
            preparedStatement2.execute();

            response.sendRedirect("history.jsp");

            conn.commit();
            conn.setAutoCommit(true);

        } catch (SQLException e) {
            try {
                conn.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("availability.jsp");
    }
}
