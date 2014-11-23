package RailwayReservation;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class bookme extends HttpServlet {

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
        String src = request.getParameter("src");
        String dst = request.getParameter("dst");
        String tno = request.getParameter("tno");
        String doj = request.getParameter("doj");
        String errorMsg = null;

        try {
            conn.setAutoCommit(false);
            String ticketSql = "Insert into ticket(date, source, destination, train, username) VALUES (?,?,?,?,?) returning pnr";
            String travellerSql = "Insert into people(name, age, gender, ticket) VALUES (?,?,?,?)";
            String updateRoute = "UPDATE availability \n" +
                    "SET seats=seats-? \n" +
                    "WHERE train = ? AND \n" +
                    "      travel_date = ? AND \n" +
                    "      station IN \n" +
                    "      (\n" +
                    "        select station \n" +
                    "        from route \n" +
                    "        where train = ? and \n" +
                    "              stopnum <= (select stopnum \n" +
                    "                          from route \n" +
                    "                          where station = ? and \n" +
                    "                                train = ?) and \n" +
                    "              stopnum > (select stopnum \n" +
                    "                         from route \n" +
                    "                         where station = ? and \n" +
                    "                               train = ?))";

            PreparedStatement preparedStatement = conn.prepareStatement(ticketSql);
            PreparedStatement preparedStatement1 = conn.prepareStatement(travellerSql);
            PreparedStatement preparedStatement2 = conn.prepareStatement(updateRoute);


            /* Create a ticket */
            preparedStatement.setDate(1, Date.valueOf(doj));
            preparedStatement.setString(2, src);
            preparedStatement.setString(3, dst);
            preparedStatement.setInt(4, Integer.parseInt(tno));
            preparedStatement.setString(5, (String) request.getSession().getAttribute("uname"));

            ResultSet resultSet = preparedStatement.executeQuery();
            resultSet.next();
            int pnr = resultSet.getInt("pnr");

            /*Create users*/
            int number_created = 0;
            preparedStatement1.setInt(4, pnr);
            if(!request.getParameter("name1").equals("undefined") && !request.getParameter("age1").equals("undefined")){
                preparedStatement1.setString(1,request.getParameter("name1"));
                preparedStatement1.setString(2,request.getParameter("age1"));
                preparedStatement1.setString(3,request.getParameter("g1"));

                preparedStatement1.execute();
                number_created++;
            }
            if(!request.getParameter("name2").equals("undefined") && !request.getParameter("age2").equals("undefined")){
                preparedStatement1.setString(1,request.getParameter("name2"));
                preparedStatement1.setString(2,request.getParameter("age2"));
                preparedStatement1.setString(3,request.getParameter("g2"));

                preparedStatement1.execute();
                number_created++;
            }
            if(!request.getParameter("name3").equals("undefined") && !request.getParameter("age3").equals("undefined")){
                preparedStatement1.setString(1,request.getParameter("name3"));
                preparedStatement1.setString(2,request.getParameter("age3"));
                preparedStatement1.setString(3,request.getParameter("g3"));

                preparedStatement1.execute();
                number_created++;
            }
            if(!request.getParameter("name4").equals("undefined") && !request.getParameter("age4").equals("undefined")){
                preparedStatement1.setString(1,request.getParameter("name4"));
                preparedStatement1.setString(2,request.getParameter("age4"));
                preparedStatement1.setString(3,request.getParameter("g4"));

                preparedStatement1.execute();
                number_created++;
            }
            if(!request.getParameter("name5").equals("undefined") && !request.getParameter("age5").equals("undefined")){
                preparedStatement1.setString(1,request.getParameter("name5"));
                preparedStatement1.setString(2,request.getParameter("age5"));
                preparedStatement1.setString(3,request.getParameter("g5"));

                preparedStatement1.execute();
                number_created++;
            }

            if(number_created == 0){
                errorMsg = "No passengers mentioned";
                throw new SQLException();
            }

            String sql = "select MIN(seats) as val from availability where train = ? and travel_date = ? and station in (select station from route where train = ? and stopnum <= (select stopnum from route where station = ? and train = ?) and stopnum > (select stopnum from route where station = ? and train = ?))";

            preparedStatement = conn.prepareStatement(sql);
            preparedStatement.setInt(1, Integer.parseInt(tno));
            preparedStatement.setInt(3, Integer.parseInt(tno));
            preparedStatement.setInt(5, Integer.parseInt(tno));
            preparedStatement.setInt(7, Integer.parseInt(tno));
            preparedStatement.setString(4,dst);
            preparedStatement.setString(6,src);
            preparedStatement.setDate(2,Date.valueOf(doj));

            ResultSet resultSet1 = preparedStatement.executeQuery();
            resultSet1.next();
            int val = resultSet1.getInt("val");

            if (val < number_created){
                errorMsg = "More passengers than we can accommodate";
                throw new SQLException();
            }

            System.out.println(val);
            System.out.println(number_created);

            /*update the availabilities*/
            preparedStatement2.setInt(1, number_created);
            preparedStatement2.setInt(2, Integer.parseInt(tno));
            preparedStatement2.setDate(3, Date.valueOf(doj));
            preparedStatement2.setInt(4, Integer.parseInt(tno));
            preparedStatement2.setString(5, dst);
            preparedStatement2.setInt(6, Integer.parseInt(tno));
            preparedStatement2.setString(7, src);
            preparedStatement2.setInt(8, Integer.parseInt(tno));

            preparedStatement2.execute();
            response.sendRedirect("history.jsp");

            conn.commit();
            conn.setAutoCommit(true);

        }catch (SQLException se) {
            try {
                se.printStackTrace(); //Commented because this is used like a feature rather than error
                conn.rollback();
                response.sendRedirect("failed.jsp?q="+errorMsg);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
