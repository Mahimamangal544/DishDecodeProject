<%-- 
    Document   : user_profile
    Created on : 28 Jan 2026, 9:31:19 am
    Author     : mahim
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>User Profile</title>

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: Arial, sans-serif;
            }

            body {
                background: #f2f4f8;
            }

            .top-bar {
                padding: 15px 30px;
            }

            .back-btn {
                text-decoration: none;
                background: #4CAF50;
                color: white;
                padding: 10px 16px;
                border-radius: 20px;
                font-size: 14px;
                transition: 0.3s;
            }

            .back-btn:hover {
                transform: scale(1.05);
            }

            .container {
                width: 95%;
                max-width: 1100px;
                margin: 25px auto;
            }

            h2 {
                margin-bottom: 15px;
            }

            /* PROFILE */
            .profile-card {
                background: #fff;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 30px;
                transition: 0.3s;
            }

            .profile-card:hover {
                transform: scale(1.01);
            }

            .profile-row {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px solid #eee;
            }

            .label {
                font-weight: bold;
                color: #555;
            }

            .value {
                color: #222;
            }

            .edit-btn {
                margin-top: 20px;
                padding: 8px 18px;
                border: none;
                background: #4CAF50;
                color: white;
                border-radius: 20px;
                cursor: pointer;
                transition: 0.3s;
            }

            .edit-btn:hover {
                transform: scale(1.05);
            }

            /* ORDERS */
            .orders {
                background: #fff;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .order {
                border: 1px solid #eee;
                border-radius: 12px;
                margin-bottom: 20px;
                padding: 15px;
                transition: 0.3s;
            }

            .order:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                transform: scale(1.01);
            }

            .order-header {
                font-weight: bold;
                margin-bottom: 6px;
                color: #333;
            }

            .restaurant {
                color: #777;
                font-size: 14px;
                margin-bottom: 10px;
            }

            .food-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .food-details {
                width: 100%;
            }

            .food-name {
                font-weight: bold;
                margin-bottom: 4px;
            }

            .price {
                color: #e91e63;
                font-weight: bold;
                margin-bottom: 3px;
            }

            .nutrition {
                font-size: 13px;
                color: #555;
            }

        </style>

    </head>

    <body>


        <%
            String email = (String) session.getAttribute("ownerEmail");
            Connection con = null;
            PreparedStatement pst = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/foodorder", "root", "root");
                String q = "select Customer_Name , Customer_Email , Customer_Phoneno , Customer_Address"
                        + " ,Customer_Password from "
                        + "customerdetails where Customer_Email = ?";
                pst = con.prepareStatement(q);
                pst.setString(1, email);
                rs = pst.executeQuery();
                if (rs.next()) {

        %>

        <div class="top-bar">
            <a href="user_homepage.jsp" class="back-btn">← Back to Home</a>
        </div>


        <div class="container">

            <!-- USER PROFILE -->
            <div class="profile-card">
                <h2>User Profile</h2>

                <div class="profile-row">
                    <div class="label">👤 Full Name</div>
                    <div class="value"><%= rs.getString("Customer_Name")%></div>
                </div>
                <div class="profile-row">
                    <div class="label">📧 Email</div>
                    <div class="value"><%= rs.getString("Customer_Email")%></div>
                </div>
                <div class="profile-row">
                    <div class="label">📞 Phone</div>
                    <div class="value"><%= rs.getString("Customer_Phoneno")%></div>
                </div>
                <div class="profile-row">
                    <div class="label">📍 Address</div>
                    <div class="value"><%= rs.getString("Customer_Address")%></div>
                </div>
                <div class="profile-row">
                    <div class="label">🔐 Password</div>
                    <div class="value"><%= rs.getString("Customer_Password")%></div>
                </div>

                <a href="edit_userprofile.jsp" class="edit-btn">Edit Profile</a>

            </div>

            <%
                }

            %>

            <!-- ORDER HISTORY -->
            <div class="orders">
                <h2>Order History</h2>

                <% String q2 = "select od.OrderDetail_UniqueID, od.Fooditem_Quantity, od.Total_Amount, od.OrderDetail_Date,"
                            + " od.calories, od.carbs, od.fats, od.proteins, rd.Resturant_Name, fi.FoodItem_Name from "
                            + "fooditem fi inner join orderdetail od on fi.FoodItem_UniqueID=od.FoodItem_UniqueID inner "
                            + "join resturantdetail rd on od.Resturant_UniqueID=rd.Resturant_UniqueID inner join customerdetails "
                            + "cd on od.Customer_UniqueID=cd.Customer_UniqueID where cd.Customer_Email=?";

                    pst = con.prepareStatement(q2);
                    pst.setString(1, email);
                    rs = pst.executeQuery();
                    while (rs.next()) {
                %>

                <!-- ORDER 1 -->
                <div class="order">
                    <div class="order-header">
                        🧾 Order ID: <%= rs.getString("OrderDetail_UniqueID")%> |
                        📅 <%= rs.getString("OrderDetail_Date")%>
                    </div>
                    <div class="restaurant">
                        🏬 <%= rs.getString("Resturant_Name")%>
                    </div>

                    <div class="food-item">
                        <div class="food-details">
                            <div class="food-name">
                                 <%= rs.getString("FoodItem_Name")%>
                            </div>
                            <div class="price">
                                🍽 Qty : <%= rs.getString("Fooditem_Quantity")%>
                            </div>

                            <div class="price">
                                💰 ₹ <%= rs.getString("Total_Amount")%>
                            </div>
                            <div class="nutrition">
                                Calories: <%= rs.getString("calories")%> |
                                Carbs: <%= rs.getString("carbs")%> |
                                Protein: <%= rs.getString("proteins")%> |
                                Fat: <%= rs.getString("fats")%>
                            </div>
                        </div>
                    </div>

                </div>
                <%
                    }
                %>

            </div>

        </div>
        <%
                rs.close();
                pst.close();
                con.close();
            } catch (Exception e) {
                out.println(e);
            }
        %>

    </body>

</html>
