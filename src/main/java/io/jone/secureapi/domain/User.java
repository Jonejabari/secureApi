package io.jone.secureapi.domain;

import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_DEFAULT;

@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(NON_DEFAULT)
public class User {
    private Long id;
    @NotEmpty(message = "First name cannot be empty")
    private String firstName;
    @NotEmpty(message = "Last name cannot be empty")
    private String lastName;
    @NotEmpty(message = "Email cannot be empty")
    @Email(message = "Invalid email. Please enter valid email address")
    private String email;
    @NotEmpty(message = "Password cannot be empty")
    private String password;
    private String address;
    private String phone;

    public void setId(Long id) {
        this.id = id;
    }

    public void setFirstName(@NotEmpty(message = "First name cannot be empty") String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(@NotEmpty(message = "Last name cannot be empty") String lastName) {
        this.lastName = lastName;
    }

    public void setEmail(@NotEmpty(message = "Email cannot be empty") @Email(message = "Invalid email. Please enter valid email address") String email) {
        this.email = email;
    }

    public void setPassword(@NotEmpty(message = "Password cannot be empty") String password) {
        this.password = password;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public void setNotLocked(boolean notLocked) {
        isNotLocked = notLocked;
    }

    public void setUsingMfa(boolean usingMfa) {
        isUsingMfa = usingMfa;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Long getId() {
        return id;
    }

    public @NotEmpty(message = "First name cannot be empty") String getFirstName() {
        return firstName;
    }

    public @NotEmpty(message = "Last name cannot be empty") String getLastName() {
        return lastName;
    }

    public @NotEmpty(message = "Email cannot be empty") @Email(message = "Invalid email. Please enter valid email address") String getEmail() {
        return email;
    }

    public @NotEmpty(message = "Password cannot be empty") String getPassword() {
        return password;
    }

    public String getAddress() {
        return address;
    }

    public String getPhone() {
        return phone;
    }

    public String getTitle() {
        return title;
    }

    public String getBio() {
        return bio;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public boolean isNotLocked() {
        return isNotLocked;
    }

    public boolean isUsingMfa() {
        return isUsingMfa;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    private String title;
    private String bio;
    private String imageUrl;
    private boolean enabled;
    private boolean isNotLocked;
    private boolean isUsingMfa;
    private LocalDateTime createdAt;
}
