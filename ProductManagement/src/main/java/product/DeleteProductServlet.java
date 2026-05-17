package product;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class DeleteProductServlet extends HttpServlet {

protected void doPost(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {

    String action = req.getParameter("action");

    try {

        // ================= SEARCH =================
        if ("search".equals(action)) {

            String sid = req.getParameter("id");
            int id = Integer.parseInt(sid);

            Connection con = DBConnection.getCon();

            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM products WHERE id=?"
            );

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            HttpSession session = req.getSession();

            if (rs.next()) {

                // store product in session
                session.setAttribute("pid", rs.getInt("id"));
                session.setAttribute("pname", rs.getString("name"));
                session.setAttribute("pprice", rs.getDouble("price"));
                session.setAttribute("pqty", rs.getInt("quantity"));

                res.sendRedirect("deleteProduct.jsp?msg=found");

            } else {
                session.invalidate();
                res.sendRedirect("deleteProduct.jsp?msg=notfound");
            }
        }

        // ================= DELETE =================
        else if ("delete".equals(action)) {

            String sid = req.getParameter("id");
            int id = Integer.parseInt(sid);

            Connection con = DBConnection.getCon();

            PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM products WHERE id=?"
            );

            ps.setInt(1, id);

            int x = ps.executeUpdate();

            if (x > 0) {
                res.sendRedirect("deleteProduct.jsp?msg=deleted");
            } else {
                res.sendRedirect("deleteProduct.jsp?msg=fail");
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        res.sendRedirect("deleteProduct.jsp?msg=fail");
    }
}
}