package product;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class UpdateProductServlet extends HttpServlet {

protected void doPost(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {

    String sid = req.getParameter("id");
    String name = req.getParameter("name");
    String p = req.getParameter("price");
    String q = req.getParameter("quantity");

    try {

        int id = Integer.parseInt(sid);
        double price = Double.parseDouble(p);
        int quantity = Integer.parseInt(q);

        if (price < 0 || quantity < 0) {
            res.sendRedirect("updateProduct.jsp?msg=fail");
            return;
        }

        Connection con = DBConnection.getCon();

        PreparedStatement ps = con.prepareStatement(
            "update products set name=?, price=?, quantity=? where id=?"
        );

        ps.setString(1, name);
        ps.setDouble(2, price);
        ps.setInt(3, quantity);
        ps.setInt(4, id);

        int x = ps.executeUpdate();

        if (x > 0) {
            res.sendRedirect("updateProduct.jsp?msg=updated");
        } else {
            res.sendRedirect("updateProduct.jsp?msg=notfound");
        }

    } catch (Exception e) {
        e.printStackTrace();
        res.sendRedirect("updateProduct.jsp?msg=fail");
    }
}
}