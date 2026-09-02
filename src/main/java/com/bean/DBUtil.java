package com.bean;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static final String USER = "root";

    // Branch-specific passwords
    private static final String PASSWORD_SRS = "fSPcwMERVlpBdtrGEzxQwKjqYiXqTeWU";
    private static final String PASSWORD_SANPOLY = "WVoVoSyYjGfAPHBNgxmDmcblbcHjbVYk";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection(String branch) throws SQLException {

        String url;
        String password;

        if ("SRS".equalsIgnoreCase(branch)) {

            url = "jdbc:mysql://altaria.proxy.rlwy.net:53217/website"   
                    + "?useSSL=false"
                    + "&allowPublicKeyRetrieval=true"
                    + "&serverTimezone=UTC"
                    + "&tcpKeepAlive=true";
            
            password = PASSWORD_SRS;

        } else if ("Sanpoly".equalsIgnoreCase(branch)) {

            url = "jdbc:mysql://altaria.proxy.rlwy.net:41400/SanWeb"
                    + "?useSSL=false"
                    + "&allowPublicKeyRetrieval=true"
                    + "&serverTimezone=UTC"
                    + "&tcpKeepAlive=true";

            password = PASSWORD_SANPOLY;

        } else {
            throw new SQLException("Invalid Branch: " + branch);
        }

        return DriverManager.getConnection(url, USER, password);
    }
}