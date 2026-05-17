package product;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        String name = req.getParameter("name");
        String category = req.getParameter("category");
        String priceStr = req.getParameter("price");
        String quantityStr = req.getParameter("quantity");

        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            // Validation: product name must be letters only
            if (!name.matches("[a-zA-Z ]+")) {
                out.println("<html><body style='font-family:Arial;text-align:center;margin-top:100px;"
                          + "background-color:#ffebee;color:#c62828;'>");
                out.println("<h2 style='color:#c62828;'>Error: Product name must contain only letters</h2>");
                out.println("<a href='addProduct.jsp' style='display:inline-block;margin-top:20px;"
                          + "padding:10px 20px;background-color:#c62828;color:#fff;text-decoration:none;"
                          + "border-radius:4px;margin-right:10px;'>Try Again</a>");
                out.println("<a href='dashboard.jsp' style='display:inline-block;margin-top:20px;"
                          + "padding:10px 20px;background-color:#6a1b9a;color:#fff;text-decoration:none;"
                          + "border-radius:4px;'>Home</a>");
                out.println("</body></html>");
                return;
            }

            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);

            con = DBConnection.getCon();

            String sql = "INSERT INTO products (name, category, price, quantity) VALUES (?, ?, ?, ?)";

            pst = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            pst.setString(1, name);
            pst.setString(2, category);
            pst.setDouble(3, price);
            pst.setInt(4, quantity);

            int result = pst.executeUpdate();

            if (result > 0) {
                rs = pst.getGeneratedKeys();
                int generatedId = 0;
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }

                out.println("<html><body style='font-family:Arial;text-align:center;margin-top:100px;"
                          + "background:linear-gradient(135deg,#a8e6cf,#dcedc1);'>");
                out.println("<h2 style='color:#2e7d32;'>Product Added Successfully!</h2>");
                out.println("<h3 style='color:#388e3c;'>Generated Product ID: " + generatedId + "</h3>");
                out.println("<a href='addProduct.jsp' style='display:inline-block;margin-top:20px;"
                          + "padding:10px 20px;background-color:#2e7d32;color:#fff;text-decoration:none;"
                          + "border-radius:4px;margin-right:10px;'>Add More</a>");
                out.println("<a href='dashboard.jsp' style='display:inline-block;margin-top:20px;"
                          + "padding:10px 20px;background-color:#6a1b9a;color:#fff;text-decoration:none;"
                          + "border-radius:4px;'>Home</a>");
                out.println("</body></html>");
            } else {
                out.println("<html><body style='font-family:Arial;text-align:center;margin-top:100px;"
                          + "background-color:#fff3e0;color:#e65100;'>");
                out.println("<h2 style='color:#e65100;'>Failed to add product</h2>");
                out.println("<a href='addProduct.jsp' style='display:inline-block;margin-top:20px;"
                          + "padding:10px 20px;background-color:#e65100;color:#fff;text-decoration:none;"
                          + "border-radius:4px;margin-right:10px;'>Try Again</a>");
                out.println("<a href='dashboard.jsp' style='display:inline-block;margin-top:20px;"
                          + "padding:10px 20px;background-color:#6a1b9a;color:#fff;text-decoration:none;"
                          + "border-radius:4px;'>Home</a>");
                out.println("</body></html>");
            }

        } catch (Exception e) {
            out.println("<html><body style='font-family:Arial;text-align:center;margin-top:100px;"
                      + "background-color:#ffebee;color:#c62828;'>");
            out.println("<h2 style='color:#c62828;'>Error: " + e.getMessage() + "</h2>");
            out.println("<a href='addProduct.jsp' style='display:inline-block;margin-top:20px;"
                      + "padding:10px 20px;background-color:#c62828;color:#fff;text-decoration:none;"
                      + "border-radius:4px;margin-right:10px;'>Back</a>");
            out.println("<a href='dashboard.jsp' style='display:inline-block;margin-top:20px;"
                      + "padding:10px 20px;background-color:#6a1b9a;color:#fff;text-decoration:none;"
                      + "border-radius:4px;'>Home</a>");
            out.println("</body></html>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (Exception e) {}
        }
    }
}
