package io.jone.secureapi.repository.implementation;

import io.jone.secureapi.Exception.ApiException;
import io.jone.secureapi.domain.Role;
import io.jone.secureapi.domain.User;
import io.jone.secureapi.repository.RoleRepository;
import io.jone.secureapi.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import static io.jone.secureapi.enumeration.RoleType.ROLE_USER;
import static io.jone.secureapi.enumeration.VerificationType.ACCOUNT;
import static io.jone.secureapi.query.UserQuery.*;
import static java.util.Map.of;
import static java.util.Objects.requireNonNull;

@Repository
@RequiredArgsConstructor
@Slf4j
public class UserRepositoryImp implements UserRepository<User> {
    private NamedParameterJdbcTemplate jdbc;
    private RoleRepository<Role> roleRepository;
    private BCryptPasswordEncoder encoder;

    @Override
    public User create(User user) {
        // Check the mail is unique
        if (getEmailCount(user.getEmail().trim().toLowerCase()) > 0)
            throw new ApiException("Email already in use. Please use different email and try again.");
        // Save new user
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            SqlParameterSource parameterSource = getSqlParameterSource(user);
            jdbc.update(INSERT_USER_QUERY, parameterSource, keyHolder);
            user.setId(requireNonNull(keyHolder.getKey()).longValue());
            // Add role to the user
            roleRepository.addRoleToUser(user.getId(), ROLE_USER.name());
            // Send verification URL
            String verificationUrl = getVerificationUrl(UUID.randomUUID().toString(), ACCOUNT.getType());
            // Save URL in verification table
            jdbc.update(INSERT_ACCOUNT_VERIFICATION_URL_QUERY, of("userId", user.getId(), "url", verificationUrl));
            // Send email to user with verification URL
            // emailService.sendVerificationUrl(user.getFirstName(), user.getEmail(), verificationUrl, ACCOUNT);
            user.setEnabled(false);
            user.setNotLocked(true);
            // Return the newly created user
            return user;
            // If any errors, throw exception with proper message
        } catch (Exception exception) {
            throw new ApiException("An error occurred. Please try again. ");
        }
    }


    @Override
    public Collection<User> list(int page, int pageSize) {
        return List.of();
    }

    @Override
    public User get(Long id) {
        return null;
    }

    @Override
    public User update(User data) {
        return null;
    }

    @Override
    public Boolean delete(Long id) {
        return null;
    }

    private Integer getEmailCount(String email) {
        return jdbc.queryForObject(COUNT_USER_EMAIL_QUERY, of("email", email), Integer.class);
    }

    private SqlParameterSource getSqlParameterSource(User user) {
        return new MapSqlParameterSource()
                .addValue("firstName", user.getFirstName())
                .addValue("lastName", user.getLastName())
                .addValue("email", user.getEmail())
                .addValue("password", encoder.encode(user.getPassword()));
    }

    private String getVerificationUrl(String key, String type) {
        return ServletUriComponentsBuilder.fromCurrentContextPath().path("user/verify" + type + "/" + key).toUriString();
    }
}
