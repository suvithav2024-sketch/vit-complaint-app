package com.smartvit.dao;

import com.smartvit.exception.DatabaseException;
import com.smartvit.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Abstract Generic DAO class demonstrating Abstraction and Generic inheritance in Java.
 * Provides template execution methods for JDBC querying and updates.
 *
 * @param <T> The entity type
 */
public abstract class BaseDAO<T> {
    protected final Logger logger = Logger.getLogger(getClass().getName());

    /**
     * Map a JDBC ResultSet row to entity T. Subclasses must implement this method.
     */
    protected abstract T mapResultSetRow(ResultSet rs) throws SQLException;

    /**
     * Helper method to execute a query and return a list of mapped entities.
     */
    protected List<T> executeQueryList(String sql, Object... params) throws DatabaseException {
        List<T> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetRow(rs));
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database query error: " + sql, e);
            throw new DatabaseException("Failed to execute database query: " + e.getMessage(), e);
        } finally {
            DBConnection.close(rs, stmt, conn);
        }

        return list;
    }

    /**
     * Helper method to execute a query and return a single mapped entity or null.
     */
    protected T executeQuerySingle(String sql, Object... params) throws DatabaseException {
        List<T> list = executeQueryList(sql, params);
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * Helper method to execute DML statements (INSERT, UPDATE, DELETE).
     */
    protected int executeUpdate(String sql, Object... params) throws DatabaseException {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }
            return stmt.executeUpdate();
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database update error: " + sql, e);
            throw new DatabaseException("Failed to execute database update: " + e.getMessage(), e);
        } finally {
            DBConnection.close(stmt, conn);
        }
    }
}
