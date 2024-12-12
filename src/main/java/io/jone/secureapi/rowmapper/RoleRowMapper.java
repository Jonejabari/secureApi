package io.jone.secureapi.rowmapper;

import io.jone.secureapi.domain.Role;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

public class RoleRowMapper implements RowMapper<Role> {
    @Override
    public Role mapRow(ResultSet resultSet, int rowNum) throws SQLException {
        return Role.builder()
                .id(resultSet.getLong("id"))               // Maps the "id" column
                .name(resultSet.getString("name"))         // Maps the "name" column
                .permission(resultSet.getString("permission")) // Maps the "permission" column
                .build();
    }
}
