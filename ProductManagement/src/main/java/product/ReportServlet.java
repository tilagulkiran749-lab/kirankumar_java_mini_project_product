package product;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class ReportServlet extends HttpServlet {

protected void doGet(HttpServletRequest req, HttpServletResponse res)
throws ServletException, IOException {

res.setContentType("text/html;charset=UTF-8");

PrintWriter out = res.getWriter();

String category = req.getParameter("category");
String minPriceStr = req.getParameter("minPrice");
String topNStr = req.getParameter("topN");

if(category == null) category = "";

double minPrice = -1;
int topN = -1;

if(minPriceStr != null && !minPriceStr.isEmpty())
minPrice = Double.parseDouble(minPriceStr);

if(topNStr != null && !topNStr.isEmpty())
topN = Integer.parseInt(topNStr);

out.println("<html><body>");

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

con = DBConnection.getCon();

String sql="SELECT * FROM products WHERE 1=1";

if(!category.isEmpty())
sql += " AND category=?";

if(minPrice>=0)
sql += " AND price>?";

if(topN>0)
sql += " AND quantity>=?";

sql += " ORDER BY id";

ps = con.prepareStatement(sql);

int i=1;

if(!category.isEmpty())
ps.setString(i++,category);

if(minPrice>=0)
ps.setDouble(i++,minPrice);

if(topN>0)
ps.setInt(i++,topN);

rs = ps.executeQuery();

out.println("<h2>Product Report</h2>");
out.println("<table border='1'><tr><th>ID</th><th>Name</th><th>Category</th><th>Price</th><th>Qty</th></tr>");

boolean found=false;

while(rs.next()){
found=true;

out.println("<tr>");
out.println("<td>"+rs.getInt("id")+"</td>");
out.println("<td>"+rs.getString("name")+"</td>");
out.println("<td>"+rs.getString("category")+"</td>");
out.println("<td>"+rs.getDouble("price")+"</td>");
out.println("<td>"+rs.getInt("quantity")+"</td>");
out.println("</tr>");
}

if(!found){
out.println("<tr><td colspan='5'>No Data Found</td></tr>");
}

out.println("</table>");

}catch(Exception e){
out.println("Error: "+e.getMessage());
}finally{
try{
if(rs!=null) rs.close();
if(ps!=null) ps.close();
if(con!=null) con.close();
}catch(Exception e){}
}

out.println("<br><a href='dashboard.jsp'>Back Home</a>");
out.println("</body></html>");
}
}